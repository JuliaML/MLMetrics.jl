_ambiguous() = throw(ArgumentError("Can't infer the comparison mode because argument types are ambigous. Please specify the desired subtype of LabelCompare manually."))
pos_examples = "Positive examples: `1`, `2.0`, `true`, `0.5`, `:2`."
neg_examples = "Negative examples: `0`, `-1`, `0.0`, `-0.5`, `false`, `:0`."

"""
    abstract LabelCompare

The type of classification problem. Example for concrete types
are `FuzzyBinaryCompare``BinaryCompare`, `MultiClassCompare`,
or `MultiLabel`.
"""
abstract LabelCompare

"""
    FuzzyBinaryCompare()

Defines the situation as a binary classification problem.
Fuzzy means that one consideres a positive match if both values
are considered stricktly positive on their own, and a negative
match if both values are considered zero or negative.
Other than that the values are not compared to each other.

- $pos_examples
- $neg_examples
"""
immutable FuzzyBinaryCompare <: LabelCompare end

"""
    BinaryCompare(pos_label)

Defines the situation as a binary classification problem.
By setting `pos_label` one can specify which value represents
the positive class. Because the problem is assumed to be binary
any value that does not match `pos_label` will be assumed to be
of the negative class.
"""
immutable BinaryCompare{T} <: LabelCompare
    pos_label::T
end

# ============================================================
# (Fuzzy)Binary only: Define what it means to be positive / negative

@inline is_positive(value) = _ambiguous()
@inline is_positive(value, bc::BinaryCompare) = (value == bc.pos_label)
@inline is_positive(value::Bool) = value
@inline is_positive{T<:Real}(value::T) = (value > zero(T))

@inline is_negative(value) = _ambiguous()
@inline is_negative(value, bc::BinaryCompare) = (value != bc.pos_label)
@inline is_negative{T<:Real}(value::T) = (value <= zero(T))

# ============================================================

"""
    true_positives(target, output, ::FuzzyBinaryCompare)

Returns `1` if both target and output are considered stricktly
positive on their own. They are not compared to each other.
Returns `0` otherwise.
$pos_examples
"""
@inline true_positives(target, output, ::FuzzyBinaryCompare) =
    Int(is_positive(target) && is_positive(output))

"""
    true_positives(target, output, bc::BinaryCompare)

Returns `1` if both, `target` and `output` are equal to
`bc.pos_label`. Returns `0` otherwise.
"""
@inline true_positives(target, output, bc::BinaryCompare) =
    Int(is_positive(target, bc) && is_positive(output, bc))

# ============================================================

"""
    true_negatives(target, output, ::FuzzyBinaryCompare)

Returns `1` if both target and output are considered zero or
negative on their own. They are not compared to each other.
Returns `0` otherwise.
$neg_examples
"""
@inline true_negatives(target, output, ::FuzzyBinaryCompare) =
    Int(is_negative(target) && is_negative(output))

"""
    true_negatives(target, output, bc::BinaryCompare)

Returns `1` if both, `target` and `output` are **not** equal to
`bc.pos_label`. Returns `0` otherwise.
"""
@inline true_negatives(target, output, bc::BinaryCompare) =
    Int(is_negative(target, bc) && is_negative(output, bc))

# ============================================================

"""
    false_positives(target, output, ::FuzzyBinaryCompare)

Returns `1` if `target` is considered zero or negative,
and `output` is considered stricktly positive.
Returns `0` otherwise.
$pos_examples
$neg_examples
"""
@inline false_positives(target, output, ::FuzzyBinaryCompare) =
    Int(is_negative(target) && is_positive(output))

"""
    false_positives(target, output, bc::BinaryCompare)

Returns `1` if `target` is **not** equal to `bc.pos_label,
while `output` is equal to it. Returns `0` otherwise.
"""
@inline false_positives(target, output, bc::BinaryCompare) =
    Int(is_negative(target, bc) && is_positive(output, bc))

# ============================================================

"""
    false_negatives(target, output, ::FuzzyBinaryCompare)

Returns `1` if `target` is considered strickly positive,
and `output` is considered zero or negative.
Returns `0` otherwise.
$pos_examples
$neg_examples
"""
@inline false_negatives(target, output, ::FuzzyBinaryCompare) =
    Int(is_positive(target) && is_negative(output))

"""
    false_negatives(target, output, bc::BinaryCompare)

Returns `1` if `target` is equal to `bc.pos_label,
while `output` is **not** equal to it. Returns `0` otherwise.
"""
@inline false_negatives(target, output, bc::BinaryCompare) =
    Int(is_positive(target, bc) && is_negative(output, bc))

# ============================================================

"""
    condition_positive(target, output, ::FuzzyBinaryCompare)

Returns `1` if `target` is considered strictly positive.
Returns `0` otherwise.
$pos_examples
"""
@inline condition_positive(target, output, ::FuzzyBinaryCompare) =
    Int(is_positive(target))

"""
    condition_positive(target, output, bc::BinaryCompare)

Returns `1` if `target` is equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline condition_positive(target, output, bc::BinaryCompare) =
    Int(is_positive(target, bc))

"""
    prevalence(target, output, bc::(Fuzzy)BinaryCompare)

Returns the fraction of positive observations in `target`.
What constitudes as positive depends on `bc`
"""
prevalence(target, output, bc) =
    condition_positive(target, output, bc) / length(target)

# ============================================================

"""
    condition_negative(target, output, ::FuzzyBinaryCompare)

Returns `1` if `target` is considered zero or negative.
Returns `0` otherwise.
$neg_examples
"""
@inline condition_negative(target, output, ::FuzzyBinaryCompare) =
    Int(is_negative(target))

"""
    condition_negative(target, output, bc::BinaryCompare)

Returns `1` if `target` is **not** equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline condition_negative(target, output, bc::BinaryCompare) =
    Int(is_negative(target, bc))

# ============================================================

"""
    predicted_condition_positive(target, output, ::FuzzyBinaryCompare)

Returns `1` if `output` is considered strictly positive.
Returns `0` otherwise.
$pos_examples
"""
@inline predicted_condition_positive(target, output, ::FuzzyBinaryCompare) =
    Int(is_positive(output))

"""
    predicted_condition_positive(target, output, bc::BinaryCompare)

Returns `1` if `output` is equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline predicted_condition_positive(target, output, bc::BinaryCompare) =
    Int(is_positive(output, bc))

# ============================================================

"""
    predicted_condition_negative(target, output, ::FuzzyBinaryCompare)

Returns `1` if `output` is considered zero or negative.
Returns `0` otherwise.
$neg_examples
"""
@inline predicted_condition_negative(target, output, ::FuzzyBinaryCompare) =
    Int(is_negative(output))

"""
    predicted_condition_negative(target, output, bc::BinaryCompare)

Returns `1` if `output` is **not** equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline predicted_condition_negative(target, output, bc::BinaryCompare) =
    Int(is_negative(output, bc))

# ============================================================
# Generate common fallback functions
for fun in (:true_positives,  :true_negatives,
            :false_positives, :false_negatives,
            :condition_positive, :condition_negative, :prevalence,
            :predicted_condition_positive, :predicted_condition_negative)
    fun_name = string(fun)
    fun_desc = rstrip(replace(string(fun), r"([a-z]+)_?([a-z]*)", s"\1 \2"))

    # Throw informative error in ambiguous case
    @eval begin
        @doc """
            $($fun_name)(target, output)

        If either `target` or `output` is of type `Bool` then
        `FuzzyBinaryCompare` is inferred to compute the
        **$($fun_desc)**. Any other type combination is ambiguous
        and will result in an error.
        """ ->
        ($fun)(target, output) = _ambiguous()
    end

    # Default to fuzzy comparison if boolean values are involed
    @eval ($fun)(target::AbstractVector{Bool},
                 output::AbstractArray{Bool}) =
            ($fun)(target, output, FuzzyBinaryCompare())
    for _T2 in (:Bool, :Real, :Any)
        @eval begin
            ($fun){T2<:$_T2}(target::AbstractVector{T2},
                             output::AbstractArray{Bool}) =
                ($fun)(target, output, FuzzyBinaryCompare())
            ($fun){T2<:$_T2}(target::AbstractVector{Bool},
                             output::AbstractArray{T2}) =
                ($fun)(target, output, FuzzyBinaryCompare())
            ($fun)(target::$_T2, output::Bool) =
                ($fun)(target, output, FuzzyBinaryCompare())
            ($fun)(target::Bool, output::$_T2) =
                ($fun)(target, output, FuzzyBinaryCompare())
        end
    end

    # Try to determine if binary or multiclass.
    # Note that this function can not be type stable,
    # because multi class returns a Vector,
    # while binary returns a Float64.
    # As a side note: we know it is not multilabel because
    # target is restricted to be a vector
    @eval function ($fun){T1<:Real, T2<:Real}(
            target::AbstractVector{T1},
            output::AbstractArray{T2})
        labels = union(target, output)
        if length(labels) == 2
            ($fun)(target, output, BinaryCompare(maximum(labels)))
        else
            # TODO: return multiclass version
            error("multiclass not yet implemented")
        end
    end
end

# ============================================================
# (Fuzzy)BinaryCompare: Generate shared accumulator
for fun in (:true_positives,  :true_negatives,
            :false_positives, :false_negatives,
            :condition_positive, :condition_negative,
            :predicted_condition_positive, :predicted_condition_negative)
    fun_name = string(fun)
    fun_desc = rstrip(replace(string(fun), r"([a-z]+)_?([a-z]*)", s"\1 \2"))
    @eval @doc """
        $($fun_name)(target::AbstractVector, output::AbstractArray, bc::(Fuzzy)BinaryCompare)

    Counts the total number of **$($fun_desc)** in `output` by
    comparing each element against the corresponding value in
    `target` according to `bc`. Both parameters are expected
    to be vectors, but `output` is allowed to be a row-vector.
    """ $fun
    for _T in (:FuzzyBinaryCompare, :BinaryCompare)
        @eval function ($fun)(target::AbstractVector,
                              output::AbstractArray,
                              compare::$_T)
            @_dimcheck length(target) == length(output)
            result = 0
            @inbounds for i = 1:length(target)
                result += ($fun)(target[i], output[i], compare)
            end
            result
        end
    end
end

# ============================================================

"""
    accuracy(target, output; normalize = true)

If `normalize` is `true`, the fraction of matching elements in
`target` and `output` are returned.
Otherwise the total number of matching elements are returned.
"""
function accuracy_score{T1<:Union{Bool,Real},T2<:Union{Bool,Real}}(
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
        normalize = true)
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
    precision_score(target, output)

Fraction of positive predicted outcomes that are true positives.
"""
function precision_score(target, output)
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
positive_predictive_value = precision_score

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

