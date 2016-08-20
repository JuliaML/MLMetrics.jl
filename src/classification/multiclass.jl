# Binary and Multiclass

# ============================================================
# MultiClass average logic

_average(numerator, denominator, labels, ::AverageMode.None) =
    numerator ./ denominator, labels

_average(numerator, denominator, labels, ::AverageMode.Macro) =
    mean(numerator ./ denominator)

_average(numerator, denominator, labels, ::AverageMode.Micro) =
    sum(numerator) / sum(denominator)

# ============================================================

"""
This will allow for readable function definition such as

    @cmetric "..." -> precision := true_positives / predicted_condition_positive

with the added bonus of the functions being implemented in such
a way as to avoid memory allocation and being able to compute
their results in just one pass.
"""
macro cmetric(all)
    @assert all.head == :->
    docstr = all.args[1]
    expr = all.args[2].args[2]
    @assert expr.head == :(:=)
    fun = expr.args[1]
    @assert :/ == expr.args[2].args[1]
    numer_fun = expr.args[2].args[2]
    denom_fun = expr.args[2].args[3]
    esc(quote

        # explicit binary case
        @noinline function $fun(target::AbstractVector,
                                output::AbstractArray,
                                bc::AbstractBinary)
            @_dimcheck length(target) == length(output)
            numer = 0; denom = 0
            @inbounds for i = 1:length(target)
                numer += $numer_fun(target[i], output[i], bc)
                denom += $denom_fun(target[i], output[i], bc)
            end
            (numer / denom)::Float64
        end

        # MultiClass case. The function _average dispatches on the mode
        @noinline function $fun{T}(targets::AbstractVector,
                                   outputs::AbstractArray,
                                   mc::MultiClass{T},
                                   avg::AvgMode)
            @_dimcheck length(target) == length(output)
            labels = mc.labels
            n = length(labels)
            numer, denom = zeros(n), zeros(n)
            ovr = Binary{T}[Binary(l) for l in labels]
            @inbounds for i = 1:length(targets)
                target = targets[i]
                output = outputs[i]
                for j = 1:n
                    numer[j] += $numer_fun(target, output, ovr[j])
                    denom[j] += $denom_fun(target, output, ovr[j])
                end
            end
            _average(numer, denom, labels, avg)
        end

        # fallback for multiclass case to dispatch on average mode
        function $fun(target::AbstractVector,
                      output::AbstractArray,
                      mc::MultiClass;
                      average::AvgMode = AverageMode.None())
            $fun(target, output, mc, average)
        end

        # fallback to try and choose compare mode automatically
        function $fun(target::AbstractVector,
                      output::AbstractArray;
                      nargs...)
            comp_mode = CompareMode.auto(target, output)
            $fun(target, output, comp_mode; nargs...)
        end

        # add documentation to function
        @eval @doc """$($docstr)""" $fun
    end)
end

# ============================================================

@cmetric """
    positive_predictive_value(target, output, bc::(Fuzzy)Binary)

Returns the fraction of positive predicted outcomes that
are true positives (as Float64).

also known as: `precision_score`
""" ->
positive_predictive_value := true_positives / predicted_condition_positive

precision_score = positive_predictive_value

# ============================================================

@cmetric """
    false_discovery_rate(target, output, bc::(Fuzzy)Binary)

Returns the fraction of positive predicted outcomes that
are false positives (as Float64)
""" ->
false_discovery_rate := false_positives / predicted_condition_positive

# ============================================================

@cmetric """
    negative_predictive_value(target, output, bc::(Fuzzy)Binary)

Returns the fraction of negative predicted outcomes that
are true negatives (as Float64)
""" ->
negative_predictive_value := true_negatives / predicted_condition_negative

# ============================================================

@cmetric """
    false_omission_rate(target, output, bc::(Fuzzy)Binary)

Returns the fraction of negative predicted outcomes that
are false negatives (as Float64)
""" ->
false_omission_rate := false_negatives / predicted_condition_negative

# ============================================================

@cmetric """
    true_positive_rate(target, output, bc::(Fuzzy)Binary)

Returns the fraction of truely positive observations that
were predicted as positives (as Float64)

also known as: `recall`, `sensitivity`
""" ->
true_positive_rate := true_positives / condition_positive

sensitivity = true_positive_rate
recall = true_positive_rate

# ============================================================

@cmetric """
    false_positive_rate(target, output, bc::(Fuzzy)Binary)

Returns the fraction of truely negative observations that
were (wrongly) predicted as positives (as Float64)
""" ->
false_positive_rate := false_positives / condition_negative

# ============================================================

@cmetric """
    false_negative_rate(target, output, bc::(Fuzzy)Binary)

Returns the fraction of truely positive observations that
were (wrongly) predicted as negative (as Float64)
""" ->
false_negative_rate := false_negatives / condition_positive

# ============================================================

@cmetric """
    true_negative_rate(target, output, bc::(Fuzzy)Binary)

Returns the fraction of negative predicted outcomes that
are true negatives (as Float64).

also known as: `specificity`
""" ->
true_negative_rate := true_negatives / condition_negative

specificity = true_negative_rate

# ============================================================

"""
    accuracy(target, output, bc::(Fuzzy)Binary; normalize = true)

If `normalize` is `true`, the fraction of correctly classified
observations is returned.
Otherwise the total number is returned.
"""
function accuracy_score(target::AbstractVector,
                        output::AbstractArray,
                        bc::AbstractBinary;
                        normalize = true)
    @_dimcheck length(target) == length(output)
    tp = 0; tn = 0
    @inbounds for i = 1:length(target)
        tp += true_positives(target[i], output[i], bc)
        tn += true_negatives(target[i], output[i], bc)
    end
    correct = tp + tn
    normalize ? Float64(correct/length(target)) : Float64(correct)
end

"""
    accuracy(target, output, [mc::MultiClass]; normalize = true)

If `normalize` is `true`, the fraction of matching elements in
`target` and `output` are returned.
Otherwise the total number of matching elements are returned.
"""
function accuracy_score(target::AbstractVector,
                        output::AbstractArray,
                        mc::AbstractMultiClass;
                        normalize = true)
    @_dimcheck length(target) == length(output)
    correct = 0
    @inbounds for i = 1:length(target)
        correct += target[i] == output[i]
    end
    normalize ? Float64(correct/length(target)) : Float64(correct)
end

# Fall back to FuzzyMultiClass, because labels don't matter
# to determine piecewise equality
function accuracy_score(target::AbstractVector,
                        output::AbstractArray;
                        nargs...)
    accuracy_score(target, output, FuzzyMultiClass(); nargs...)::Float64
end

accuracy = accuracy_score

# ============================================================

function f_score(target::AbstractVector,
                 output::AbstractArray,
                 bc::AbstractBinary,
                 β::Float64 = 1.0)
    @_dimcheck length(target) == length(output)
    β² = abs2(β)
    tp = 0; fp = 0; fn = 0
    @inbounds for i = 1:length(target)
        tp += true_positives(target[i],  output[i], bc)
        fp += false_positives(target[i], output[i], bc)
        fn += false_negatives(target[i], output[i], bc)
    end
    (1+β²)*tp / ((1+β²)*tp + β²*fn + fp)
end


f1_score(target, output) = f_score(target, output, 1.0)
f1_score(target, output, comp) = f_score(target, output, comp, 1.0)

# ============================================================

function positive_likelihood_ratio(target, output)
    @_dimcheck length(target) == length(output)
    tpr = true_positive_rate(target, output)
    fpr = false_positive_rate(target, output)
    return(tpr / fpr)
end

function negative_likelihood_ratio(target, output)
    @_dimcheck length(target) == length(output)
    fnr = false_negative_rate(target, output)
    tnr = true_negative_rate(target, output)
    return(fnr / tnr)
end

function diagnostic_odds_ratio(target, output)
    @_dimcheck length(target) == length(output)
    plr = positive_likelihood_ratio(target, output)
    nlr = negative_likelihood_ratio(target, output)
    return(plr / nlr)
end


function matthews_corrcoef(target, output)
    @_dimcheck length(target) == length(output)
    tp = true_positives(target, output)
    tn = true_negatives(target, output)
    fp = false_positives(target, output)
    fn = false_negatives(target, output)
    numerator = (tp * tn) - (fp * fn)
    denominator = (tp + fp) * (tp + fn) * (tn + fp) * (tn + fn)
    return(numerator / (denominator ^ 0.5))
end

