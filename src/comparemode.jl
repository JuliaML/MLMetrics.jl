module CompareMode

export
    FuzzyBinary,
    Binary,
    MultiClass

using ..MLMetrics: pos_examples, neg_examples

# ============================================================

_ambiguous() = throw(ArgumentError("Can't infer the comparison mode because argument types are ambigous. Please specify the desired CompareMode manually."))

# ============================================================

abstract AbstractBinary

"""
    FuzzyBinary()

Defines the situation as a binary classification problem.
Fuzzy means that one consideres a positive match if both values
are considered stricktly positive on their own, and a negative
match if both values are considered zero or negative.
Other than that the values are not compared to each other.

- $pos_examples
- $neg_examples
"""
immutable FuzzyBinary <: AbstractBinary end


"""
    Binary(pos_label)

Defines the situation as a binary classification problem.
By setting `pos_label` one can specify which value represents
the positive class. Because the problem is assumed to be binary
any value that does not match `pos_label` will be assumed to be
of the negative class.
"""
immutable Binary{T} <: AbstractBinary
    pos_label::T
end

# ============================================================

abstract AbstractMultiClass

"""
    FuzzyMultiClass()

Used internally for multiclass problems that don't require
knowledge about the labels.
"""
immutable FuzzyMultiClass <: AbstractMultiClass end

"""
    MultiClass(labels)

Defines the situation as a multiclass classification problem.
"""
immutable MultiClass{T,N} <: AbstractMultiClass
    labels::Vector{T}
    function MultiClass(labels::Vector{T})
        @assert length(labels) == length(unique(labels)) == N
        new(labels)
    end
end
MultiClass{T}(labels::Vector{T}) =
    MultiClass{T,length(labels)}(labels)

# ============================================================

"""
    auto(target, output)

Trys to automatically infer the compare mode for the given
structure and values in `target` and `output`.
The heuristic follow the roughly the following steps

- If any of the two parameters is a `Bool` or a vector of `Bool`,
`FuzzyBinary` is chosen.

- If both parameters are vectors of `Real` and there are only two
unique values in both parameters, then the larger one will be assumed
to be the positive class in a `Binary` mode.

- If target is a vector, `MultiClass` is chosen with the sorted union
of both parameters as the label set.

- If target is a matrix, `MuliLabel` is chosen.
"""
auto(target, output) = _ambiguous()

auto(target::AbstractVector{Bool}, output::AbstractArray{Bool}) =
    FuzzyBinary()

# Generate the Bool combinations to avoid ambuguity warnings
for _T2 in (:Bool, :Real, :Any)
    @eval begin
        auto{T2<:$_T2}(target::AbstractVector{T2},
                       output::AbstractArray{Bool}) = FuzzyBinary()
        auto{T2<:$_T2}(target::AbstractVector{Bool},
                       output::AbstractArray{T2}) = FuzzyBinary()
        auto(target::$_T2, output::Bool) = FuzzyBinary()
        auto(target::Bool, output::$_T2) = FuzzyBinary()
    end
end

# For Real numbers we will decide to choose Binary if only
# two unique label values are found. MultiClass otherwise
# Unfortunately this function can not be type stable.
function auto{T1<:Real, T2<:Real}(target::AbstractVector{T1},
                                  output::AbstractArray{T2})
    labels = union(target, output)
    if length(labels) == 2
        Binary(maximum(labels))
    else
        MultiClass(sort(labels))
    end
end

# Not enough information available to decide for binary,
# because we don't want to infer an arbitrary label as positive.
# In this case we decide for MultiClass.
function auto(target::AbstractVector,
              output::AbstractArray)
    labels = sort(union(target, output))
    MultiClass(labels)
end

end # sub module
