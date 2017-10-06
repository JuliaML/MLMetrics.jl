const pos_examples = "Positive examples: `1`, `2.0`, `true`, `0.5`."
const neg_examples = "Negative examples: `0`, `-1`, `0.0`, `-0.5`, `false`."

"""
    true_positives(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if both target and output are considered stricktly
positive on their own. They are not compared to each other.
Returns `0` otherwise.
$pos_examples

    true_positives(target, output, encoding::BinaryLabelEncoding) -> Int

Returns `1` if both, `target` and `output` are considered
positive labels according to `encoding`. Returns `0` otherwise.
"""
true_positives(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) & isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    true_negatives(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if both target and output are considered zero or
negative on their own. They are not compared to each other.
Returns `0` otherwise.
$neg_examples

    true_negatives(target, output, encoding::BinaryLabelEncoding) -> Int

Returns `1` if both, `target` and `output` are considered
negative labels according to `encoding`. Returns `0` otherwise.
"""
true_negatives(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding) & isneglabel(output, encoding))

# --------------------------------------------------------------------

"""
    false_positives(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `target` is considered zero or negative,
and `output` is considered stricktly positive.
Returns `0` otherwise.
$pos_examples
$neg_examples

    false_positives(target, output, encoding::BinaryLabelEncoding) -> Int

Returns `1` if `target` is considered a negative label and
`output` is considered a positive label (according to `encoding`).
Returns `0` otherwise.
"""
false_positives(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding) & isposlabel(output, encoding))

type_1_errors = false_positives

# --------------------------------------------------------------------

"""
    false_negatives(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `target` is considered strickly positive,
and `output` is considered zero or negative.
Returns `0` otherwise.
$pos_examples
$neg_examples

    false_negatives(target, output, encoding::BinaryLabelEncoding) -> Int

Returns `1` if `target` is considered a positive label and
`output` is considered a negative label (according to `encoding`).
Returns `0` otherwise.
"""
false_negatives(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) & isneglabel(output, encoding))

type_2_errors = false_negatives

# --------------------------------------------------------------------

"""
    condition_positive(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `target` is considered strictly positive.
Returns `0` otherwise.
$pos_examples

    condition_positive(target, output, encoding::BinaryLabelEncoding) -> Int

Returns `1` if `target` is considered a positive label according
to `encoding`. Returns `0` otherwise.
"""
condition_positive(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding))

"""
    prevalence(targets, outputs, [encoding]) -> Float64

Returns the fraction of positive observations in `targets`.
What constitudes as positive depends on `encoding`.
"""
prevalence(target, output, encoding::BinaryLabelEncoding) =
    condition_positive(target, output, encoding) / length(target)

# --------------------------------------------------------------------

"""
    condition_negative(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `target` is considered zero or negative.
Returns `0` otherwise.
$neg_examples

    condition_negative(target, output, encoding::BinaryLabelEncoding) -> Int

Returns `1` if `target` is considered a negative label according
to `encoding`. Returns `0` otherwise.
"""
condition_negative(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding))

# --------------------------------------------------------------------

"""
    predicted_condition_positive(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `output` is considered strictly positive.
Returns `0` otherwise.
$pos_examples

    predicted_condition_positive(target, output, encoding::BinaryLabelEncoding) -> Int

Returns `1` if `output` is considered a positive label according
to `encoding`. Returns `0` otherwise.
"""
predicted_condition_positive(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    predicted_condition_negative(target, output, ::LabelEnc.FuzzyBinary) -> Int

Returns `1` if `output` is considered zero or negative.
Returns `0` otherwise.
$neg_examples

    predicted_condition_negative(target, output, encoding::BinaryLabelEncoding) -> Int

Returns `1` if `output` is considered a negative label according
to `encoding`. Returns `0` otherwise.
"""
predicted_condition_negative(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(output, encoding))

# --------------------------------------------------------------------
# Generate common fallback functions
for fun in (:true_positives,  :true_negatives,
            :false_positives, :false_negatives,
            :condition_positive, :condition_negative, :prevalence,
            :predicted_condition_positive, :predicted_condition_negative)
    fun_name = string(fun)
    fun_desc = rstrip(replace(string(fun), r"([a-z]+)_?([a-z]*)", s"\1 \2"))

    # Convenience syntax for using native labels
    @eval function ($fun)(targets::AbstractVector, outputs::AbstractArray, encoding::AbstractVector)
        length(encoding) == 2 || throw(ArgumentError("The given values in \"encoding\" contain more than two distinct labels. $($fun) only support binary label encodings. Consider using LabelEnc.OneVsRest"))
        ($fun)(targets, outputs, LabelEnc.NativeLabels(encoding))
    end

    # Generic fallback. Tries to infer label encoding
    @eval function ($fun)(targets, outputs)
        encoding = comparemode(targets, outputs)
        nlabel(encoding) == 2 || throw(ArgumentError("The given values in \"targets\" and/or \"outputs\" contain more than two distinct labels. $($fun) only support binary label encodings. Consider using LabelEnc.OneVsRest"))
        ($fun)(targets, outputs, encoding)
    end

    # prealence is a special case that only needs the fallback
    if fun == :prevalence; continue; end

    # BinaryLabelEncoding: Generate shared accumulator
    @eval @doc """
        $($fun_name)(targets::AbstractVector, outputs::AbstractArray, [encoding]) -> Int

    Counts the total number of **$($fun_desc)** in `outputs` by
    comparing each element against the corresponding value in
    `targets` according to `encoding`. Both parameters are
    expected to be vectors, but `outputs` is allowed to be a
    row-vector (or row-matrix).
    """ $fun
    @eval function ($fun)(target::AbstractVector,
                          output::AbstractArray,
                          encoding::BinaryLabelEncoding)
        @_dimcheck length(target) == length(output)
        result = 0
        @inbounds for i = 1:length(target)
            result += ($fun)(target[i], output[i], encoding)
        end
        result
    end
end
