typealias BINARY Union{Bool,Real}

@inline is_positive(value::Bool) = value
@inline is_positive{T<:Real}(value::T) = value > zero(T)
@inline is_negative{T<:Real}(value::T) = value <= zero(T)

"""
    true_positives(target::Bool, output::Bool)

Returns `1` if both target and output are `true`.
Returns `0` otherwise.

    true_positives(target::Bool, output::Real)

Returns `1` if target is `true` and output is stricktly positive.
Returns `0` otherwise.

    true_positives(target::Real, output::Bool)

Returns `1` if target is stricktly positive and output is `true`.
Returns `0` otherwise.
"""
@inline true_positives(target::BINARY, output::BINARY) =
    Int(is_positive(target) && is_positive(output))

"""
    true_positives(target::Real, output::Real)

Returns `1` if both target and output are equal and stricktly positive.
Returns `0` otherwise.
"""
@inline true_positives(target::Real, output::Real) =
    Int(target == output > 0)

"""
    true_positives(target::AbstractArray, output::AbstractArray)

Counts the total number of true positives in `output` by
comparing each element against the corresponding value in `target`.
"""
function true_positives(target::AbstractVector, output::AbstractArray)
    @_dimcheck length(target) == length(output)
    tp = 0
    @inbounds for i = 1:length(target)
        tp += true_positives(target[i], output[i])
    end
    tp
end

# ============================================================

"""
    true_negatives(target::Real, output::Real)

Returns `1` if both target and output are less or equal to zero.
Returns `0` otherwise.

    true_negatives(target::Bool, output::Bool)

Returns `1` if both target and output are `false`.
Returns `0` otherwise.

    true_negatives(target::Bool, output::Real)

Returns `1` if target is `false` and output is less or equal to zero.
Returns `0` otherwise.

    true_negatives(target::Real, output::Bool)

Returns `1` if target is less or equal to zero and output is `false`.
Returns `0` otherwise.
"""
@inline true_negatives(target::BINARY, output::BINARY) =
    Int(is_negative(target) && is_negative(output))

#= Deactivated to make everything non positive a match
"""
    true_negatives(target::Real, output::Real)

Returns `1` if both target and output are equal and less or equal
to zero. Returns `0` otherwise.
"""
@inline true_negatives(target::Real, output::Real) =
    Int(target == output <= 0)
=#

"""
    true_negatives(target::AbstractArray, output::AbstractArray)

Counts the total number of true negatives in `output` by
comparing each element against the corresponding value in `target`.
"""
function true_negatives(target::AbstractVector, output::AbstractArray)
    @_dimcheck length(target) == length(output)
    tn = 0
    @inbounds for i = 1:length(target)
        tn += true_negatives(target[i], output[i])
    end
    tn
end

# ============================================================

"""
    false_positives(target::Real, output::Real)

Returns `1` if output is stricktly positive and target is not.
Returns `0` otherwise.

    false_positives(target::Bool, output::Bool)

Returns `1` if target is `false` and output is `true`.
Returns `0` otherwise.

    false_positives(target::Bool, output::Real)

Returns `1` if target is `false` and output is stricktly positive.
Returns `0` otherwise.

    false_positives(target::Real, output::Bool)

Returns `1` if target is less or equal to zero and output is `true`.
Returns `0` otherwise.
"""
@inline false_positives(target::BINARY, output::BINARY) =
    Int(is_negative(target) && is_positive(output))

"""
    false_positives(target::AbstractArray, output::AbstractArray)

Counts the total number of false positives in `output` by
comparing each element against the corresponding value in `target`.
"""
function false_positives(target::AbstractVector, output::AbstractArray)
    @_dimcheck length(target) == length(output)
    fp = 0
    @inbounds for i = 1:length(target)
        fp += false_positives(target[i], output[i])
    end
    fp
end

# ============================================================

"""
    false_negatives(target::Real, output::Real)

Returns `1` if output is less or equal to zero and target is not.
Returns `0` otherwise.

    false_negatives(target::Bool, output::Bool)

Returns `1` if target is `true` and output is `false`.
Returns `0` otherwise.

    false_negatives(target::Bool, output::Real)

Returns `1` if target is `true` and output is less or equal to zero.
Returns `0` otherwise.

    false_negatives(target::Real, output::Bool)

Returns `1` if target is stricktly positive and output is `false`.
Returns `0` otherwise.
"""
@inline false_negatives(target::BINARY, output::BINARY) =
    Int(is_positive(target) && is_negative(output))

"""
    false_negatives(target::AbstractArray, output::AbstractArray)

Counts the total number of false positives in `output` by
comparing each element against the corresponding value in `target`.
"""
function false_negatives(target::AbstractVector, output::AbstractArray)
    @_dimcheck length(target) == length(output)
    fn = 0
    @inbounds for i = 1:length(target)
        fn += false_negatives(target[i], output[i])
    end
    fn
end

# ============================================================

"""
    condition_positive(target, output)

returns the number of positive observations in `target`
"""
condition_positive(target, output) = sum(is_positive, target)

"""
    prevalence(target, output)

returns the fraction of positive observations in `target`
"""
prevalence(target, output) = condition_positive(target, output) / length(target)

"""
    condition_negative(target, output)

returns the number of negative observations in `target`
"""
condition_negative(target, output) = sum(is_negative, target)

"""
    predicted_condition_positive(target, output)

returns the number of positive observations in `output`
"""
predicted_condition_positive(target, output) = sum(is_positive, output)

"""
    predicted_condition_negative(target, output)

returns the number of negative observations in `output`
"""
predicted_condition_negative(target, output) = sum(is_negative, output)

# ============================================================

"""
    accuracy(target, output; normalize = true)

If `normalize` is `true`, the fraction of matching elements in
`target` and `output` are returned.
Otherwise the total number of matching elements are returned.
"""
function accuracy_score{T1<:BINARY,T2<:BINARY}(
        target::AbstractVector{T1},
        output::AbstractArray{T2};
        normalize = true)
    @_dimcheck length(target) == length(output)
    tp = 0; tn = 0
    @inbounds for i = 1:length(target)
        tp += true_positives(target[i], output[i])
        tn += true_negatives(target[i], output[i])
    end
    correct = tp + tn
    normalize ? correct/length(target) : Float64(correct)
end

function accuracy_score(
        target::AbstractVector,
        output::AbstractArray;
        normalize=true)
    @_dimcheck length(target) == length(output)
    correct = 0
    @inbounds for i = 1:length(target)
        correct += target[i] == output[i]
    end
    normalize ? correct/length(target) : Float64(correct)
end

accuracy = accuracy_score

# ============================================================

"""
    precision(target, output)

Fraction of positive predicted outcomes that are true positives.
"""
function Base.precision(target, output)
    @_dimcheck length(target) == length(output)
    tp = 0; pcp = 0
    @inbounds for i = 1:length(target)
        tp  += true_positives(target[i], output[i])
        pcp += predicted_condition_positive(target[i], output[i])
    end
    tp / pcp
end

"""
    positive_predictive_value(target, output)

Fraction of positive predicted outcomes that are true positives.
"""
positive_predictive_value = precision

# ============================================================

function false_discovery_rate(target, output)
    @_dimcheck length(target) == length(output)
    fp = false_positives(target, output)
    pcp = predicted_condition_positive(target, output)
    return(fp / pcp)
end

function negative_predictive_value(target, output)
    @_dimcheck length(target) == length(output)
    tn = true_negatives(target, output)
    pcn = predicted_condition_negative(target, output)
    return(tn / pcn)
end

function false_omission_rate(target, output)
    @_dimcheck length(target) == length(output)
    fn = false_negatives(target, output)
    pcn = predicted_condition_negative(target, output)
    return(fn / pcn)
end

function true_positive_rate(target, output)
    @_dimcheck length(target) == length(output)
    tp = true_positives(target, output)
    cp = condition_positive(target, output)
    return(tp / cp)
end

sensitivity = true_positive_rate
recall = true_positive_rate

function false_positive_rate(target, output)
    @_dimcheck length(target) == length(output)
    fp = false_positives(target, output)
    cn = condition_negative(target, output)
    return(fp / cn)
end

function false_negative_rate(target, output)
    @_dimcheck length(target) == length(output)
    fn = false_negatives(target, output)
    cp = condition_positive(target, output)
    return(fn / cp)
end

function true_negative_rate(target, output)
    @_dimcheck length(target) == length(output)
    tn = true_negatives(target, output)
    cn = condition_negative(target, output)
    return(tn / cn)
end

specificity = true_negative_rate

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

function f1_score(target, output)
    @_dimcheck length(target) == length(output)
    tp = true_positives(target, output)
    fp = false_positives(target, output)
    fn = false_negatives(target, output)
    return((2 * tp) / (2 * tp + fp + fn))
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

