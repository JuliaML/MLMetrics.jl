# (Fuzzy)Binary only

# ============================================================
# Define what it means to be positive / negative

@inline is_positive(value) = CompareMode._ambiguous()
@inline is_positive(value, bc::Binary) = (value == bc.pos_label)
@inline is_positive(value::Bool) = value
@inline is_positive(value::T) where {T<:Real} = (value > zero(T))

@inline is_negative(value) = CompareMode._ambiguous()
@inline is_negative(value, bc::Binary) = (value != bc.pos_label)
@inline is_negative(value::T) where {T<:Real} = (value <= zero(T))

# ============================================================

"""
    true_positives(target, output, ::FuzzyBinary)

Returns `1` if both target and output are considered stricktly
positive on their own. They are not compared to each other.
Returns `0` otherwise.
$pos_examples
"""
@inline true_positives(target, output, ::FuzzyBinary) =
    Int(is_positive(target) && is_positive(output))

"""
    true_positives(target, output, bc::Binary)

Returns `1` if both, `target` and `output` are equal to
`bc.pos_label`. Returns `0` otherwise.
"""
@inline true_positives(target, output, bc::Binary) =
    Int(is_positive(target, bc) && is_positive(output, bc))

# ============================================================

"""
    true_negatives(target, output, ::FuzzyBinary)

Returns `1` if both target and output are considered zero or
negative on their own. They are not compared to each other.
Returns `0` otherwise.
$neg_examples
"""
@inline true_negatives(target, output, ::FuzzyBinary) =
    Int(is_negative(target) && is_negative(output))

"""
    true_negatives(target, output, bc::Binary)

Returns `1` if both, `target` and `output` are **not** equal to
`bc.pos_label`. Returns `0` otherwise.
"""
@inline true_negatives(target, output, bc::Binary) =
    Int(is_negative(target, bc) && is_negative(output, bc))

# ============================================================

"""
    false_positives(target, output, ::FuzzyBinary)

Returns `1` if `target` is considered zero or negative,
and `output` is considered stricktly positive.
Returns `0` otherwise.
$pos_examples
$neg_examples
"""
@inline false_positives(target, output, ::FuzzyBinary) =
    Int(is_negative(target) && is_positive(output))

"""
    false_positives(target, output, bc::Binary)

Returns `1` if `target` is **not** equal to `bc.pos_label,
while `output` is equal to it. Returns `0` otherwise.
"""
@inline false_positives(target, output, bc::Binary) =
    Int(is_negative(target, bc) && is_positive(output, bc))

type_1_errors = false_positives

# ============================================================

"""
    false_negatives(target, output, ::FuzzyBinary)

Returns `1` if `target` is considered strickly positive,
and `output` is considered zero or negative.
Returns `0` otherwise.
$pos_examples
$neg_examples
"""
@inline false_negatives(target, output, ::FuzzyBinary) =
    Int(is_positive(target) && is_negative(output))

"""
    false_negatives(target, output, bc::Binary)

Returns `1` if `target` is equal to `bc.pos_label,
while `output` is **not** equal to it. Returns `0` otherwise.
"""
@inline false_negatives(target, output, bc::Binary) =
    Int(is_positive(target, bc) && is_negative(output, bc))

type_2_errors = false_negatives

# ============================================================

"""
    condition_positive(target, output, ::FuzzyBinary)

Returns `1` if `target` is considered strictly positive.
Returns `0` otherwise.
$pos_examples
"""
@inline condition_positive(target, output, ::FuzzyBinary) =
    Int(is_positive(target))

"""
    condition_positive(target, output, bc::Binary)

Returns `1` if `target` is equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline condition_positive(target, output, bc::Binary) =
    Int(is_positive(target, bc))

"""
    prevalence(target, output, bc::(Fuzzy)Binary)

Returns the fraction of positive observations in `target`.
What constitudes as positive depends on `bc`
"""
prevalence(target, output, bc) =
    condition_positive(target, output, bc) / length(target)

# ============================================================

"""
    condition_negative(target, output, ::FuzzyBinary)

Returns `1` if `target` is considered zero or negative.
Returns `0` otherwise.
$neg_examples
"""
@inline condition_negative(target, output, ::FuzzyBinary) =
    Int(is_negative(target))

"""
    condition_negative(target, output, bc::Binary)

Returns `1` if `target` is **not** equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline condition_negative(target, output, bc::Binary) =
    Int(is_negative(target, bc))

# ============================================================

"""
    predicted_condition_positive(target, output, ::FuzzyBinary)

Returns `1` if `output` is considered strictly positive.
Returns `0` otherwise.
$pos_examples
"""
@inline predicted_condition_positive(target, output, ::FuzzyBinary) =
    Int(is_positive(output))

"""
    predicted_condition_positive(target, output, bc::Binary)

Returns `1` if `output` is equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline predicted_condition_positive(target, output, bc::Binary) =
    Int(is_positive(output, bc))

# ============================================================

"""
    predicted_condition_negative(target, output, ::FuzzyBinary)

Returns `1` if `output` is considered zero or negative.
Returns `0` otherwise.
$neg_examples
"""
@inline predicted_condition_negative(target, output, ::FuzzyBinary) =
    Int(is_negative(output))

"""
    predicted_condition_negative(target, output, bc::Binary)

Returns `1` if `output` is **not** equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline predicted_condition_negative(target, output, bc::Binary) =
    Int(is_negative(output, bc))

# ============================================================
# Generate common fallback functions
for fun in (:true_positives,  :true_negatives,
            :false_positives, :false_negatives,
            :condition_positive, :condition_negative, :prevalence,
            :predicted_condition_positive, :predicted_condition_negative)
    fun_name = string(fun)
    fun_desc = rstrip(replace(string(fun), r"([a-z]+)_?([a-z]*)" => s"\1 \2"))

    # Generic fallback. Tries to infer compare mode
    @eval begin
        @doc """
            $($fun_name)(target, output)

        If either `target` or `output` is of type `Bool` then
        `FuzzyBinary` is inferred as compare mode to compute the
        **$($fun_desc)**. Any other type combination is ambiguous
        and will result in an error.
        """ ->
        ($fun)(target, output) = ($fun)(target, output, CompareMode.auto(target,output))
    end

    # prealence is a special case that only needs the fallback
    if fun == :prevalence; continue; end

    # (Fuzzy)Binary: Generate shared accumulator
    @eval @doc """
        $($fun_name)(target::AbstractVector, output::AbstractArray, bc::(Fuzzy)Binary)

    Counts the total number of **$($fun_desc)** in `output` by
    comparing each element against the corresponding value in
    `target` according to `bc`. Both parameters are expected
    to be vectors, but `output` is allowed to be a row-vector.
    """ $fun
    for _T in (:FuzzyBinary, :Binary) # avoid ambiguity warnings
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

