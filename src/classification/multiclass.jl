# Binary and Multiclass

# --------------------------------------------------------------------
# LabelEncoding average logic

_average(numerator, denominator, labels, ::AvgMode.None) =
    numerator ./ denominator, labels

_average(numerator, denominator, labels, ::AvgMode.Macro) =
    mean(numerator ./ denominator)

_average(numerator, denominator, labels, ::AvgMode.Micro) =
    sum(numerator) / sum(denominator)

# --------------------------------------------------------------------

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
    @assert expr.args[2].args[1] == :/
    numer_fun = expr.args[2].args[2]
    denom_fun = expr.args[2].args[3]
    esc(quote

        # explicit binary case
        @noinline function ($fun)(targets::AbstractVector,
                                  outputs::AbstractArray,
                                  le::BinaryLabelEncoding)
            @_dimcheck length(targets) == length(outputs)
            numer = 0; denom = 0
            @inbounds for I in eachindex(targets, outputs)
                target = targets[I]
                output = outputs[I]
                numer += ($numer_fun)(target, output, le)
                denom += ($denom_fun)(target, output, le)
            end
            (numer / denom)::Float64
        end

        # multiclass case. The function _average dispatches on the mode
        @noinline function ($fun)(targets::AbstractVector,
                                  outputs::AbstractArray,
                                  le::LabelEncoding{T},
                                  avgmode::AverageMode) where T
            @_dimcheck length(targets) == length(outputs)
            labels = label(le)
            n = length(labels)
            numer, denom = zeros(n), zeros(n)
            ovr = [LabelEnc.OneVsRest(l) for l in labels]
            @inbounds for i = 1:length(targets)
                target = targets[i]
                output = outputs[i]
                for j = 1:n
                    numer[j] += ($numer_fun)(target, output, ovr[j])
                    denom[j] += ($denom_fun)(target, output, ovr[j])
                end
            end
            _average(numer, denom, labels, avgmode)
        end

        # fallback for multiclass case to dispatch on average mode
        function ($fun)(target::AbstractVector,
                        output::AbstractArray,
                        le::LabelEncoding;
                        avgmode::AverageMode = AvgMode.None())
            ($fun)(target, output, le, avgmode)
        end

        # fallback to try and choose compare mode automatically
        function ($fun)(target::AbstractVector,
                        output::AbstractArray;
                        nargs...)
            comp_mode = comparemode(target, output)
            ($fun)(target, output, comp_mode; nargs...)
        end

        # add documentation to function
        @eval @doc """$($docstr)""" ($fun)
    end)
end

# --------------------------------------------------------------------

@cmetric """
    precision(target, output, [enc::LabelEncoding], [avgmode::AverageMode])

Returns the fraction of positive predicted outcomes that are true
positives (as Float64).

also known as: `positive_predictive_value`
""" ->
precision := true_positives / predicted_condition_positive

const positive_predictive_value = precision

#const precision_score = positive_predictive_value

# --------------------------------------------------------------------

@cmetric """
    false_discovery_rate(target, output, [enc::LabelEncoding], [avgmode::AverageMode])

Returns the fraction of positive predicted outcomes that
are false positives (as Float64)
""" ->
false_discovery_rate := false_positives / predicted_condition_positive

# --------------------------------------------------------------------

@cmetric """
    negative_predictive_value(target, output, le::(Fuzzy)Binary)

Returns the fraction of negative predicted outcomes that
are true negatives (as Float64)
""" ->
negative_predictive_value := true_negatives / predicted_condition_negative

# --------------------------------------------------------------------

@cmetric """
    false_omission_rate(target, output, le::(Fuzzy)Binary)

Returns the fraction of negative predicted outcomes that
are false negatives (as Float64)
""" ->
false_omission_rate := false_negatives / predicted_condition_negative

# --------------------------------------------------------------------

@cmetric """
    true_positive_rate(target, output, le::(Fuzzy)Binary)

Returns the fraction of truely positive observations that
were predicted as positives (as Float64)

also known as: `recall`, `sensitivity`
""" ->
true_positive_rate := true_positives / condition_positive

const sensitivity = true_positive_rate
const recall = true_positive_rate

# --------------------------------------------------------------------

@cmetric """
    false_positive_rate(target, output, le::(Fuzzy)Binary)

Returns the fraction of truely negative observations that
were (wrongly) predicted as positives (as Float64)
""" ->
false_positive_rate := false_positives / condition_negative

# --------------------------------------------------------------------

@cmetric """
    false_negative_rate(target, output, le::(Fuzzy)Binary)

Returns the fraction of truely positive observations that
were (wrongly) predicted as negative (as Float64)
""" ->
false_negative_rate := false_negatives / condition_positive

# --------------------------------------------------------------------

@cmetric """
    true_negative_rate(target, output, le::(Fuzzy)Binary)

Returns the fraction of negative predicted outcomes that
are true negatives (as Float64).

also known as: `specificity`
""" ->
true_negative_rate := true_negatives / condition_negative

const specificity = true_negative_rate

# --------------------------------------------------------------------

"""
    accuracy(target, output, le::BinaryLabelEncoding; normalize = true)

If `normalize` is `true`, the fraction of correctly classified
observations is returned. Otherwise the total number is returned.
"""
function accuracy(targets::AbstractVector,
                  outputs::AbstractArray,
                  le::BinaryLabelEncoding;
                  normalize = true)
    @_dimcheck length(targets) == length(outputs)
    tp = 0; tn = 0
    @inbounds for i = 1:length(targets)
        target = targets[i]
        output = outputs[i]
        tp += true_positives(target, output, le)
        tn += true_negatives(target, output, le)
    end
    correct = tp + tn
    normalize ? Float64(correct/length(targets)) : Float64(correct)
end

"""
    accuracy(target, output, [le::LabelEncoding]; normalize = true)

If `normalize` is `true`, the fraction of matching elements in
`target` and `output` are returned. Otherwise the total number
of matching elements are returned.
"""
function accuracy(target::AbstractVector,
                  output::AbstractArray,
                  le::LabelEncoding;
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
function accuracy(target::AbstractVector,
                  output::AbstractArray;
                  nargs...)
    accuracy(target, output, FuzzyMultiClass(); nargs...)::Float64
end

# --------------------------------------------------------------------

function f_score(targets::AbstractVector,
                 outputs::AbstractArray,
                 le::BinaryLabelEncoding,
                 β::Float64 = 1.0)
    @_dimcheck length(targets) == length(outputs)
    β² = abs2(β)
    tp = 0; fp = 0; fn = 0
    @inbounds for i = 1:length(targets)
        target = targets[i]
        output = outputs[i]
        tp += true_positives(target,  output, le)
        fp += false_positives(target, output, le)
        fn += false_negatives(target, output, le)
    end
    (1+β²)*tp / ((1+β²)*tp + β²*fn + fp)
end


f1_score(target, output) = f_score(target, output, 1.0)
f1_score(target, output, comp) = f_score(target, output, comp, 1.0)

# --------------------------------------------------------------------

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

