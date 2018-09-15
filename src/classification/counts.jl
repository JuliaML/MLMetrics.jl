"""
    true_positives(target, output, [encoding]) -> Int

Return `1` if both, `target` and `output`, are considered
positive labels according to `encoding`. Return `0` otherwise.
"""
true_positives(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) & isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    true_negatives(target, output, [encoding]) -> Int

Return `1` if both, `target` and `output`, are considered
negative labels according to `encoding`. Return `0` otherwise.
"""
true_negatives(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding) & isneglabel(output, encoding))

# --------------------------------------------------------------------

"""
    false_positives(target, output, [encoding]) -> Int

Return `1` if `target` is considered a negative label and
`output` is considered a positive label (according to `encoding`).
Return `0` otherwise. This is also known as type 1 error.
"""
false_positives(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding) & isposlabel(output, encoding))

const type_1_errors = false_positives

# --------------------------------------------------------------------

"""
    false_negatives(target, output, [encoding]) -> Int

Return `1` if `target` is considered a positive label and
`output` is considered a negative label (according to `encoding`).
Return `0` otherwise.
"""
false_negatives(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) & isneglabel(output, encoding))

const type_2_errors = false_negatives

# --------------------------------------------------------------------

"""
    condition_positive(target, output, [encoding]) -> Int

Return `1` if `target` is considered a positive label according
to `encoding`. Return `0` otherwise.
"""
condition_positive(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding))

# --------------------------------------------------------------------

"""
    condition_negative(target, output, [encoding]) -> Int

Return `1` if `target` is considered a negative label according
to `encoding`. Return `0` otherwise.
"""
condition_negative(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding))

# --------------------------------------------------------------------

"""
    predicted_positive(target, output, [encoding]) -> Int

Return `1` if `output` is considered a positive label according
to `encoding`. Return `0` otherwise.
"""
predicted_positive(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    predicted_negative(target, output, [encoding]) -> Int

Return `1` if `output` is considered a negative label according
to `encoding`. Return `0` otherwise.
"""
predicted_negative(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(output, encoding))

# --------------------------------------------------------------------

"""
    correctly_classified(target, output, [encoding]) -> Int

Return `1` if `output` is considered equal to `target`
(according to `encoding`). Return `0` otherwise.
"""
correctly_classified(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) == isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    incorrectly_classified(target, output, [encoding]) -> Int

Return `1` if `output` is considered different from `target`
(according to `encoding`). Return `0` otherwise.
"""
incorrectly_classified(target, output, encoding::BinaryLabelEncoding) =
    Int(xor(isposlabel(target, encoding), isposlabel(output, encoding)))

const misclassified = incorrectly_classified

# --------------------------------------------------------------------

# only for internal use to define `prevalence`
_length_targets(target, output, encoding) = 1
_length_targets(target::AbstractArray, output, encoding) = length(targets)

# --------------------------------------------------------------------
# Generate common fallback functions
for fun in (:true_positives,  :true_negatives,
            :false_positives, :false_negatives,
            :condition_positive, :condition_negative,
            :predicted_positive, :predicted_negative,
            :correctly_classified, :incorrectly_classified)
    fun_name = string(fun)
    fun_desc = rstrip(replace(string(fun), r"([a-z]+)_?([a-z]*)" => s"\1 \2"))

    # Convenience syntax for using native labels
    @eval function ($fun)(targets, outputs, encoding::AbstractVector)
        ($fun)(targets, outputs, LabelEnc.NativeLabels(encoding))
    end

    # Generic fallback. Tries to infer label encoding
    @eval function ($fun)(targets, outputs)
        encoding = _labelenc(targets, outputs)
        ($fun)(targets, outputs, encoding)
    end

    # BinaryLabelEncoding: Generate shared accumulator
    @eval function ($fun)(
            targets::AbstractArray,
            outputs::AbstractArray,
            encoding::BinaryLabelEncoding)
        @_dimcheck length(targets) == length(outputs)
        result::Int = 0
        @inbounds for I in eachindex(targets, outputs)
            result += ($fun)(targets[I], outputs[I], encoding)
        end
        result
    end

    # Multiclass LabelEncoding: Implementation for scalar
    @eval function ($fun)(target, output, encoding::LabelEncoding)
        labels = label(encoding)
        result = Dict{eltype(labels),Int}()
        for l in labels
            result[l] = ($fun)(target, output, LabelEnc.OneVsRest(l))
        end
        result
    end

    # Multiclass LabelEncoding: Generate shared accumulator
    @eval @doc """
        $($fun_name)(targets::AbstractArray, outputs::AbstractArray, [encoding]) -> Union{Int, Dict}

    Count the total number of **$($fun_desc)** in `outputs` by
    comparing each element against the corresponding value in
    `targets` (according to `encoding`). Both parameters are
    expected to be vectors of some form, which means they are
    allowed to be row-vectors (or row-matrices).

    $ENCODING_DESCR
    """
    function ($fun)(
            targets::AbstractArray,
            outputs::AbstractArray,
            encoding::LabelEncoding)
        @_dimcheck length(targets) == length(outputs)
        labels = label(encoding)
        results = zeros(Int, length(labels))
        ovr = [LabelEnc.OneVsRest(l) for l in labels]
        @inbounds for I in eachindex(targets, outputs)
            target = targets[I]
            output = outputs[I]
            for j in eachindex(results, ovr)
                results[j] += ($fun)(target, output, ovr[j])
            end
        end
        Dict(Pair.(labels, results))
    end

    # Disable support for OneOfK (otherwise behaviour is misleading)
    @eval function ($fun)(target, output, encoding::LabelEnc.OneOfK)
        throw(ArgumentError("encoding LabelEnc.OneOfK not yet supported"))
    end

    @eval function ($fun)(targets::AbstractArray, outputs::AbstractArray, encoding::LabelEnc.OneOfK)
        throw(ArgumentError("encoding LabelEnc.OneOfK not yet supported"))
    end
end
