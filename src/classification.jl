typealias BINARY Union{Bool,Real}

@inline is_positive(value::Bool) = value
@inline is_positive{T<:Real}(value::T) = value > zero(T)
@inline is_negative{T<:Real}(value::T) = value <= zero(T)

"""
    true_positives(target::Real, output::Real)

Returns `1` if both target and output are equal and stricktly positive.
Returns `0` otherwise.
"""
@inline true_positives(target::Real, output::Real) =
    Int(target == output > 0)

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

Returns `1` if both target and output are equal and less or equal
to zero. Returns `0` otherwise.
"""
@inline true_negatives(target::Real, output::Real) =
    Int(target == output <= 0)

"""
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

function condition_positive(target, output)
    @_dimcheck length(target) == length(output)
    return(sum(target .== 1))
end

function condition_negative(target, output)
    @_dimcheck length(target) == length(output)
    return(sum(target .== 0))
end

function predicted_condition_positive(target, output)
    @_dimcheck length(target) == length(output)
    return(sum(target .== 1))
end

function predicted_condition_negative(target, output)
    @_dimcheck length(target) == length(output)
    return(sum(output .== 0))
end

function accuracy_score(target, output)
    @_dimcheck length(target) == length(output)
    tp = true_positives(target, output)
    tn = true_negatives(target, output)
    tot_pop = length(target)
    return((tp + tn) / tot_pop)
end

accuracy = accuracy_score

function prevalence(target, output)
    @_dimcheck length(target) == length(output)
    cp = condition_positive(target, output)
    tot_pop = length(target)
    return(cp / tot_pop)
end

function Base.precision(target, output)
    @_dimcheck length(target) == length(output)
    tp = true_positives(target, output)
    pcp = predicted_condition_positive(target, output)
    return(tp / pcp)
end

positive_predictive_value = precision

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

