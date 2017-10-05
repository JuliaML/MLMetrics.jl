const pos_examples = "Positive examples: `1`, `2.0`, `true`, `0.5`, `:2`."
const neg_examples = "Negative examples: `0`, `-1`, `0.0`, `-0.5`, `false`, `:0`."

"""
    true_positives(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if both target and output are considered stricktly
positive on their own. They are not compared to each other.
Returns `0` otherwise.
$pos_examples

    true_positives(target, output, le::BinaryLabelEncoding) -> Int

Returns `1` if both, `target` and `output` are considered
positive labels according to `le`. Returns `0` otherwise.
"""
true_positives(target, output, le::BinaryLabelEncoding) =
    Int(isposlabel(target, le) & isposlabel(output, le))

# --------------------------------------------------------------------

"""
    true_negatives(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if both target and output are considered zero or
negative on their own. They are not compared to each other.
Returns `0` otherwise.
$neg_examples

    true_negatives(target, output, le::BinaryLabelEncoding) -> Int

Returns `1` if both, `target` and `output` are considered
negative labels according to `le`. Returns `0` otherwise.
"""
true_negatives(target, output, le::BinaryLabelEncoding) =
    Int(isneglabel(target, le) & isneglabel(output, le))

# --------------------------------------------------------------------

"""
    false_positives(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `target` is considered zero or negative,
and `output` is considered stricktly positive.
Returns `0` otherwise.
$pos_examples
$neg_examples

    false_positives(target, output, le::BinaryLabelEncoding) -> Int

Returns `1` if `target` is considered a negative label and
`output` is considered a positive label (according to `le`).
Returns `0` otherwise.
"""
false_positives(target, output, le::BinaryLabelEncoding) =
    Int(isneglabel(target, le) & isposlabel(output, le))

type_1_errors = false_positives

# --------------------------------------------------------------------

"""
    false_negatives(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `target` is considered strickly positive,
and `output` is considered zero or negative.
Returns `0` otherwise.
$pos_examples
$neg_examples

    false_negatives(target, output, le::BinaryLabelEncoding) -> Int

Returns `1` if `target` is considered a positive label and
`output` is considered a negative label (according to `le`).
Returns `0` otherwise.
"""
false_negatives(target, output, le::BinaryLabelEncoding) =
    Int(isposlabel(target, le) & isneglabel(output, le))

type_2_errors = false_negatives

# --------------------------------------------------------------------

"""
    condition_positive(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `target` is considered strictly positive.
Returns `0` otherwise.
$pos_examples

    condition_positive(target, output, le::BinaryLabelEncoding) -> Int

Returns `1` if `target` is considered a positive label according
to `le`. Returns `0` otherwise.
"""
condition_positive(target, output, le::BinaryLabelEncoding) =
    Int(isposlabel(target, le))

"""
    prevalence(target, output, le::BinaryLabelEncoding) -> Float64

Returns the fraction of positive observations in `target`.
What constitudes as positive depends on `le`.
"""
prevalence(target, output, le::BinaryLabelEncoding) =
    condition_positive(target, output, le) / length(target)

# --------------------------------------------------------------------

"""
    condition_negative(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `target` is considered zero or negative.
Returns `0` otherwise.
$neg_examples

    condition_negative(target, output, le::BinaryLabelEncoding) -> Int

Returns `1` if `target` is considered a negative label according
to `le`. Returns `0` otherwise.
"""
condition_negative(target, output, le::BinaryLabelEncoding) =
    Int(isneglabel(target, le))

# --------------------------------------------------------------------

"""
    predicted_condition_positive(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `output` is considered strictly positive.
Returns `0` otherwise.
$pos_examples

    predicted_condition_positive(target, output, le::BinaryLabelEncoding) -> Int

Returns `1` if `output` is considered a positive label according
to `le`. Returns `0` otherwise.
"""
predicted_condition_positive(target, output, le::BinaryLabelEncoding) =
    Int(isposlabel(output, le))

# --------------------------------------------------------------------

"""
    predicted_condition_negative(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `output` is considered zero or negative.
Returns `0` otherwise.
$neg_examples

    predicted_condition_negative(target, output, le::BinaryLabelEncoding) -> Int

Returns `1` if `output` is considered a negative label according
to `le`. Returns `0` otherwise.
"""
predicted_condition_negative(target, output, le::BinaryLabelEncoding) =
    Int(isneglabel(output, le))

# --------------------------------------------------------------------
# Generate common fallback functions
for fun in (:true_positives,  :true_negatives,
            :false_positives, :false_negatives,
            :condition_positive, :condition_negative, :prevalence,
            :predicted_condition_positive, :predicted_condition_negative)
    fun_name = string(fun)
    fun_desc = rstrip(replace(string(fun), r"([a-z]+)_?([a-z]*)", s"\1 \2"))

    # Generic fallback. Tries to infer compare mode
    @eval begin
        @doc """
            $($fun_name)(target, output)

        If either `target` or `output` is of (el)type `Bool`
        then `FuzzyBinary` is inferred as compare mode to compute
        the **$($fun_desc)**. Any other type combination is
        ambiguous and will result in an error.
        """ ->
        ($fun)(target, output) = ($fun)(target, output, comparemode(target,output))
    end

    # prealence is a special case that only needs the fallback
    if fun == :prevalence; continue; end

    # BinaryLabelEncoding: Generate shared accumulator
    @eval @doc """
        $($fun_name)(target::AbstractVector, output::AbstractArray, le::BinaryLabelEncoding)

    Counts the total number of **$($fun_desc)** in `output` by
    comparing each element against the corresponding value in
    `target` according to `le`. Both parameters are expected to
    be vectors, but `output` is allowed to be a row-vector (or
    row matrix).
    """ $fun
    @eval function ($fun)(target::AbstractVector,
                          output::AbstractArray,
                          compare::BinaryLabelEncoding)
        @_dimcheck length(target) == length(output)
        result = 0
        @inbounds for i = 1:length(target)
            result += ($fun)(target[i], output[i], compare)
        end
        result
    end
end
