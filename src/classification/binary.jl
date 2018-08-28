"""
    true_positives(target, output, [encoding]) -> Int

Returns `1` if both, `target` and `output`, are considered
positive labels according to `encoding`. Returns `0` otherwise.
"""
true_positives(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) & isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    true_negatives(target, output, [encoding]) -> Int

Returns `1` if both, `target` and `output`, are considered
negative labels according to `encoding`. Returns `0` otherwise.
"""
true_negatives(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding) & isneglabel(output, encoding))

# --------------------------------------------------------------------

"""
    false_positives(target, output, [encoding]) -> Int

Returns `1` if `target` is considered a negative label and
`output` is considered a positive label (according to `encoding`).
Returns `0` otherwise. This is also known as type 1 error.
"""
false_positives(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding) & isposlabel(output, encoding))

const type_1_errors = false_positives

# --------------------------------------------------------------------

"""
    false_negatives(target, output, [encoding]) -> Int

Returns `1` if `target` is considered a positive label and
`output` is considered a negative label (according to `encoding`).
Returns `0` otherwise.
"""
false_negatives(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) & isneglabel(output, encoding))

const type_2_errors = false_negatives

# --------------------------------------------------------------------

"""
    condition_positive(target, output, [encoding]) -> Int

Returns `1` if `target` is considered a positive label according
to `encoding`. Returns `0` otherwise.
"""
condition_positive(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding))

"""
    prevalence(targets, outputs, [encoding]) -> Float64

Returns the fraction of positive observations in `targets`.
What constitutes as positive depends on `encoding`.
"""
prevalence(targets, outputs, encoding::BinaryLabelEncoding) =
    condition_positive(targets, outputs, encoding) / length(targets)

# --------------------------------------------------------------------

"""
    condition_negative(target, output, [encoding]) -> Int

Returns `1` if `target` is considered a negative label according
to `encoding`. Returns `0` otherwise.
"""
condition_negative(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding))

# --------------------------------------------------------------------

"""
    predicted_condition_positive(target, output, [encoding]) -> Int

Returns `1` if `output` is considered a positive label according
to `encoding`. Returns `0` otherwise.
"""
predicted_condition_positive(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    predicted_condition_negative(target, output, [encoding]) -> Int

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
    fun_desc = rstrip(replace(string(fun), r"([a-z]+)_?([a-z]*)" => s"\1 \2"))

    # Convenience syntax for using native labels
    @eval function ($fun)(targets::AbstractArray, outputs::AbstractArray, encoding::AbstractVector)
        length(encoding) == 2 || throw(ArgumentError("The given values in \"encoding\" contain more than two distinct labels. $($fun) only support binary label encodings. Consider using LabelEnc.OneVsRest"))
        ($fun)(targets, outputs, LabelEnc.NativeLabels(encoding))
    end

    # Generic fallback. Tries to infer label encoding
    @eval function ($fun)(targets, outputs)
        encoding = comparemode(targets, outputs)
        nlabel(encoding) == 2 || throw(ArgumentError("The given values in \"targets\" and/or \"outputs\" contain more than two distinct labels. $($fun) only support binary label encodings. Consider using LabelEnc.OneVsRest"))
        ($fun)(targets, outputs, encoding)
    end

    # prevalence is a special case that only needs the fallback
    if fun == :prevalence; continue; end

    # BinaryLabelEncoding: Generate shared accumulator
    @eval @doc """
        $($fun_name)(targets::AbstractArray, outputs::AbstractArray, [encoding]) -> Int

    Counts the total number of **$($fun_desc)** in `outputs` by
    comparing each element against the corresponding value in
    `targets` (according to `encoding`). Both parameters are
    expected to be vectors of some form, which means they are
    allowed to be row-vectors (or row-matrices).

    $ENCODING_DESCR
    """
    function ($fun)(targets::AbstractArray,
                    outputs::AbstractArray,
                    encoding::BinaryLabelEncoding)
        @_dimcheck length(targets) == length(outputs)
        result::Int = 0
        @inbounds for i = 1:length(targets)
            result += ($fun)(targets[i], outputs[i], encoding)
        end
        result
    end
end
