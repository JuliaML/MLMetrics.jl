# Binary and Multiclass

# --------------------------------------------------------------------
# LabelEncoding aggregate logic

_aggregate(numerator, denominator, labels, avgmode) =
    throw(ArgumentError("$avgmode is not supported"))

_aggregate(numerator, denominator, labels, ::AvgMode.None) =
    Dict(Pair.(labels, numerator ./ denominator))

_aggregate(numerator, denominator, labels, ::AvgMode.Macro) =
    mean(numerator ./ denominator)

_aggregate(numerator, denominator, labels, ::AvgMode.Micro) =
    sum(numerator) / sum(denominator)

# TODO: add weighted versions

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
        function ($fun)(targets::AbstractVector,
                        outputs::AbstractArray,
                        encoding::BinaryLabelEncoding,
                        avgmode::AverageMode)
            @_dimcheck length(targets) == length(outputs)
            numer = 0; denom = 0
            @inbounds for I in eachindex(targets, outputs)
                target = targets[I]
                output = outputs[I]
                numer += ($numer_fun)(target, output, encoding)
                denom += ($denom_fun)(target, output, encoding)
            end
            (numer / denom)::Float64
        end

        # multiclass case. The function _aggregate dispatches on the mode
        function ($fun)(targets::AbstractVector,
                        outputs::AbstractArray,
                        encoding::LabelEncoding,
                        avgmode::AverageMode)
            @_dimcheck length(targets) == length(outputs)
            labels = label(encoding)
            n = length(labels)
            numer = zeros(n); denom = zeros(n)
            ovr = [LabelEnc.OneVsRest(l) for l in labels]
            @inbounds for i = 1:length(targets)
                target = targets[i]
                output = outputs[i]
                for j = 1:n
                    numer[j] += ($numer_fun)(target, output, ovr[j])
                    denom[j] += ($denom_fun)(target, output, ovr[j])
                end
            end
            _aggregate(numer, denom, labels, avgmode)
        end

        # fallback for native labels as plain vector
        function ($fun)(targets::AbstractVector,
                        outputs::AbstractArray,
                        encoding::AbstractVector,
                        avgmode::AverageMode)
            ($fun)(targets, outputs, LabelEnc.NativeLabels(encoding), convert(AverageMode, avgmode))
        end

        # fallback for multiclass case to dispatch on average mode
        function ($fun)(targets::AbstractVector,
                        outputs::AbstractArray,
                        encoding;
                        avgmode = AvgMode.None())
            ($fun)(targets, outputs, encoding, convert(AverageMode, avgmode))
        end

        # fallbacks to try and choose compare mode automatically
        function ($fun)(targets::AbstractVector,
                        outputs::AbstractArray,
                        avgmode::AverageMode)
            encoding = comparemode(targets, outputs)
            ($fun)(targets, outputs, encoding, avgmode)
        end
        function ($fun)(targets::AbstractVector,
                        outputs::AbstractArray;
                        avgmode = AvgMode.None())
            encoding = comparemode(targets, outputs)
            ($fun)(targets, outputs, encoding, convert(AverageMode, avgmode))
        end

        # add documentation to function
        @eval @doc """
            $($fun)(targets, outputs, [encoding], [avgmode])

        $($docstr)
        """ ($fun)
    end)
end

# --------------------------------------------------------------------

@cmetric """
Returns the fraction of positive predicted outcomes in `outputs`
that are true positives according to `targets`. This is also
known as precision (see `precision_score`).

```jldoctest
julia> precision_score([0,1,1,0,1], [1,1,1,0,1])
0.75

julia> precision_score([-1,1,1,-1,1], [1,1,1,-1,1])
0.75
```

$ENCODING_DESCR

```jldoctest
julia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:c))
0.6666666666666666
```

TODO: avgmode

```jldoctest
julia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=AvgMode.None()
([1.0, 0.0, 0.666667], Symbol[:a, :b, :c])

julia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=AvgMode.Micro())
0.6

julia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=AvgMode.Macro())
0.5555555555555555
```
""" ->
precision_score := true_positives / predicted_condition_positive

const positive_predictive_value = precision_score

# --------------------------------------------------------------------

@cmetric """
Returns the fraction of negative predicted outcomes that
are true negatives (as Float64).
""" ->
negative_predictive_value := true_negatives / predicted_condition_negative

# --------------------------------------------------------------------

@cmetric """
Returns the fraction of positive predicted outcomes that
are false positives (as Float64).
""" ->
false_discovery_rate := false_positives / predicted_condition_positive

# --------------------------------------------------------------------

@cmetric """
Returns the fraction of negative predicted outcomes that
are false negatives (as Float64).
""" ->
false_omission_rate := false_negatives / predicted_condition_negative

# --------------------------------------------------------------------

@cmetric """
Returns the fraction of truely positive observations that were
predicted as positives (as Float64). This is also known as
`recall` or `sensitivity`.
""" ->
true_positive_rate := true_positives / condition_positive

const sensitivity = true_positive_rate
const recall = true_positive_rate

# --------------------------------------------------------------------

@cmetric """
Returns the fraction of truely negative observations that
were (wrongly) predicted as positives (as Float64).
""" ->
false_positive_rate := false_positives / condition_negative

# --------------------------------------------------------------------

@cmetric """
Returns the fraction of truely positive observations that
were (wrongly) predicted as negative (as Float64).
""" ->
false_negative_rate := false_negatives / condition_positive

# --------------------------------------------------------------------

@cmetric """
Returns the fraction of negative predicted outcomes that are true
negatives (as Float64). This is also known as `specificity`.
""" ->
true_negative_rate := true_negatives / condition_negative

const specificity = true_negative_rate

# --------------------------------------------------------------------

"""
    accuracy(target, output, encoding::BinaryLabelEncoding; normalize = true)

If `normalize` is `true`, the fraction of correctly classified
observations is returned (according to `encoding`). Otherwise the
total number is returned.
"""
function accuracy(targets::AbstractVector,
                  outputs::AbstractArray,
                  encoding::BinaryLabelEncoding;
                  normalize = true)
    @_dimcheck length(targets) == length(outputs)
    tp = 0; tn = 0
    @inbounds for i = 1:length(targets)
        target = targets[i]
        output = outputs[i]
        tp += true_positives(target, output, encoding)
        tn += true_negatives(target, output, encoding)
    end
    correct = tp + tn
    normalize ? Float64(correct/length(targets)) : Float64(correct)
end

"""
    accuracy(target, output; normalize = true)

If `normalize` is `true`, the fraction of matching elements in
`target` and `output` are returned. Otherwise the total number
of matching elements are returned.
"""
function accuracy(target::AbstractVector,
                  output::AbstractArray,
                  encoding;
                  normalize = true)
    @_dimcheck length(target) == length(output)
    correct = 0
    @inbounds for i = 1:length(target)
        correct += target[i] == output[i]
    end
    normalize ? Float64(correct/length(target)) : Float64(correct)
end

# Fall back to "nothing", because labels don't matter
# to determine element-wise equality
function accuracy(target::AbstractVector,
                  output::AbstractArray;
                  normalize = true)
    accuracy(target, output, nothing, normalize = normalize)::Float64
end

# --------------------------------------------------------------------

function f_score(targets::AbstractVector,
                 outputs::AbstractArray,
                 encoding::BinaryLabelEncoding,
                 β::Float64 = 1.0)
    @_dimcheck length(targets) == length(outputs)
    β² = abs2(β)
    tp = 0; fp = 0; fn = 0
    @inbounds for i = 1:length(targets)
        target = targets[i]
        output = outputs[i]
        tp += true_positives(target,  output, encoding)
        fp += false_positives(target, output, encoding)
        fn += false_negatives(target, output, encoding)
    end
    (1+β²)*tp / ((1+β²)*tp + β²*fn + fp)
end


f1_score(target, output) = f_score(target, output, 1.0)
f1_score(target, output, enc) = f_score(target, output, enc, 1.0)

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

