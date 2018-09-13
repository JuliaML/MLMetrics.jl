# Consider moving this into MLLabelUtils.labelenc

_ambiguous() = throw(ArgumentError("Can't infer the label encoding because argument types/values are ambigous. Please specify the desired LabelEnc manually."))

"""
    _labelenc(targets, outputs)

Tries to automatically infer the compare mode for the given
structure and values in `targets` and `outputs`.
"""
_labelenc(target, output) = _ambiguous()

_labelenc(targets::AbstractArray{Bool}, outputs::AbstractArray{Bool}) =
    LabelEnc.FuzzyBinary()

# Generate the Bool combinations to avoid ambiguity warnings
_labelenc(target::Bool, output::Bool) = LabelEnc.FuzzyBinary()
for _T2 in (:Bool, :Real, :Any)
    @eval begin
        _labelenc(targets::AbstractArray{T2}, outputs::AbstractArray{Bool}) where {T2<:$_T2} = LabelEnc.FuzzyBinary()
        _labelenc(targets::AbstractArray{Bool}, outputs::AbstractArray{T2}) where {T2<:$_T2} = LabelEnc.FuzzyBinary()
    end
    if _T2 != :Bool
        @eval begin
            _labelenc(target::$_T2, output::Bool) =
                LabelEnc.FuzzyBinary()
            _labelenc(target::Bool, output::$_T2) =
                LabelEnc.FuzzyBinary()
        end
    end
end

# Not enough information available to decide for fuzzy binary,
# because we don't want to infer an arbitrary label as positive.
# In this case we decide to let labelenc decide.
function _labelenc(targets::AbstractArray, outputs::AbstractArray)
    labelenc(vcat(vec(targets), vec(outputs)))
end
