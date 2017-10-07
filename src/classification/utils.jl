const ENCODING_DESCR = """
    The optional parameter `encoding` serves as specifcation of
    what labels exist and what they denote (e.g. what constitutes
    as positive or negative). It can either be an object from the
    namespace `LabelEnc`, or a vector of labels. If omitted, the
    appropriate `encoding` will be inferred from the types and/or
    values of `targets` and `outputs`. In general this will be
    slower than specifying the parameter explicitly.
    """

_ambiguous() = throw(ArgumentError("Can't infer the label encoding because argument types/values are ambigous. Please specify the desired LabelEnc manually."))

"""
    comparemode(targets, outputs)

Trys to automatically infer the compare mode for the given
structure and values in `targets` and `outputs`.
"""
comparemode(target, output) = _ambiguous()

comparemode(target::AbstractVector{Bool}, output::AbstractArray{Bool}) =
    LabelEnc.FuzzyBinary()

# Generate the Bool combinations to avoid ambuguity warnings
comparemode(target::Bool, output::Bool) = LabelEnc.FuzzyBinary()
for _T2 in (:Bool, :Real, :Any)
    @eval begin
        comparemode(target::AbstractVector{T2}, output::AbstractArray{Bool}) where {T2<:$_T2} = LabelEnc.FuzzyBinary()
        comparemode(target::AbstractVector{Bool}, output::AbstractArray{T2}) where {T2<:$_T2} = LabelEnc.FuzzyBinary()
    end
    if _T2 != :Bool
        @eval begin
            comparemode(target::$_T2, output::Bool) =
                LabelEnc.FuzzyBinary()
            comparemode(target::Bool, output::$_T2) =
                LabelEnc.FuzzyBinary()
        end
    end
end

# Not enough information available to decide for fuzzy binary,
# because we don't want to infer an arbitrary label as positive.
# In this case we decide to let labelenc decide.
function comparemode(target::AbstractVector, output::AbstractArray)
    labelenc(vcat(target, vec(output)))
end
