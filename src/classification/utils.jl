const ENCODING_DESCR = """
    The optional parameter `encoding` serves as specifcation of
    the existing labels and their interpretation (e.g. what
    constitutes as positive or negative). It can either be an
    object from the namespace `LabelEnc`, or a vector of labels.
    If omitted, the appropriate `encoding` will be inferred from
    the types and/or values of `targets` and `outputs`. In
    general this will be slower than specifying the `encoding`
    explicitly.
    """

const AVGMODE_DESCR = """
    The optional (keyword) parameter `avgmode` can be used to
    specify if and how class-specific results should be
    aggregated. This is mainly useful if there are more than two
    classes. Typical values are `:none` (default), `:micro` for
    micro averaging, or `:macro` for macro averaging. It is also
    possible to specify `avgmode` as a type-stable positional
    argument using an object from the `AvgMode` namespace.
    """

_ambiguous() = throw(ArgumentError("Can't infer the label encoding because argument types/values are ambigous. Please specify the desired LabelEnc manually."))

"""
    comparemode(targets, outputs)

Tries to automatically infer the compare mode for the given
structure and values in `targets` and `outputs`.
"""
comparemode(target, output) = _ambiguous()

comparemode(targets::AbstractArray{Bool}, outputs::AbstractArray{Bool}) =
    LabelEnc.FuzzyBinary()

# Generate the Bool combinations to avoid ambiguity warnings
comparemode(target::Bool, output::Bool) = LabelEnc.FuzzyBinary()
for _T2 in (:Bool, :Real, :Any)
    @eval begin
        comparemode(targets::AbstractArray{T2}, outputs::AbstractArray{Bool}) where {T2<:$_T2} = LabelEnc.FuzzyBinary()
        comparemode(targets::AbstractArray{Bool}, outputs::AbstractArray{T2}) where {T2<:$_T2} = LabelEnc.FuzzyBinary()
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
function comparemode(targets::AbstractArray, outputs::AbstractArray)
    labelenc(vcat(vec(targets), vec(outputs)))
end
