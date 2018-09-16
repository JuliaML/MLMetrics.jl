"""
    true_positives(targets, outputs, [encoding]) -> Union{Int, Dict}

Count how many positive predicted outcomes in `outputs` are also
marked as positive outcomes in `targets`. Which value denotes
"positive" depends on the given (or inferred) `encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`predicted_positive`](@ref),
[`condition_positive`](@ref),
[`true_positive_rate`](@ref)

# Examples

```jldoctest
julia> true_positives(1, 1, LabelEnc.ZeroOne()) # single observation
1

julia> true_positives([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
2

julia> true_positives([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 1
  :b => 2
  :c => 0
```
"""
true_positives(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) & isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    true_negatives(targets, outputs, [encoding]) -> Union{Int, Dict}

Count how many negative predicted outcomes in `outputs` are also
marked as negative outcomes in `targets`. Which value(s) denote
"negative" depends on the given (or inferred) `encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`predicted_negative`](@ref),
[`condition_negative`](@ref),
[`true_negative_rate`](@ref)

# Examples

```jldoctest
julia> true_negatives(0, 0, LabelEnc.ZeroOne()) # single observation
1

julia> true_negatives([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
1

julia> true_negatives([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 2
  :b => 3
  :c => 4
```
"""
true_negatives(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding) & isneglabel(output, encoding))

# --------------------------------------------------------------------

"""
    false_positives(targets, outputs, [encoding]) -> Union{Int, Dict}

Count how many positive predicted outcomes in `outputs` are
actually marked as negative outcomes in `targets`. These
occurrences are also known as `type_1_errors`. Which value
denotes "positive" depends on the given (or inferred) `encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`predicted_positive`](@ref),
[`condition_negative`](@ref),
[`false_positive_rate`](@ref)

# Examples

```jldoctest
julia> false_positives(0, 1, LabelEnc.ZeroOne()) # single observation
1

julia> false_positives([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
1

julia> false_positives([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 2
  :b => 1
  :c => 0
```
"""
false_positives(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding) & isposlabel(output, encoding))

const type_1_errors = false_positives

# --------------------------------------------------------------------

"""
    false_negatives(targets, outputs, [encoding]) -> Union{Int, Dict}

Count how many negative predicted outcomes in `outputs` are
actually marked as positive outcomes in `targets`. These
occurrences are also known as `type_2_errors`. Which value
denotes "positive" depends on the given (or inferred) `encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`predicted_negative`](@ref),
[`condition_positive`](@ref),
[`false_negative_rate`](@ref)

# Examples

```jldoctest
julia> false_negatives(1, 0, LabelEnc.ZeroOne()) # single observation
1

julia> false_negatives([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
1

julia> false_negatives([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 1
  :b => 0
  :c => 2
```
"""
false_negatives(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) & isneglabel(output, encoding))

const type_2_errors = false_negatives

# --------------------------------------------------------------------

"""
    condition_positive(targets, outputs, [encoding]) -> Union{Int, Dict}

Count the number of positive outcomes in `targets`. Which value
denotes "positive" depends on the given (or inferred) `encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`predicted_positive`](@ref),
[`condition_negative`](@ref),
[`prevalence`](@ref)

# Examples

```jldoctest
julia> condition_positive(1, 0, LabelEnc.ZeroOne()) # single observation
1

julia> condition_positive([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
3

julia> condition_positive([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 2
  :b => 2
  :c => 2
```
"""
condition_positive(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding))

# --------------------------------------------------------------------

"""
    condition_negative(targets, outputs, [encoding]) -> Union{Int, Dict}

Count the number of negative outcomes in `targets`. Which values
denote "negative" depends on the given (or inferred) `encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`predicted_negative`](@ref),
[`condition_positive`](@ref)

# Examples

```jldoctest
julia> condition_negative(0, 1, LabelEnc.ZeroOne()) # single observation
1

julia> condition_negative([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
2

julia> condition_negative([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 4
  :b => 4
  :c => 4
```
"""
condition_negative(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(target, encoding))

# --------------------------------------------------------------------

"""
    predicted_positive(targets, outputs, [encoding]) -> Union{Int, Dict}

Count the number of positive predicted outcomes in `outputs`.
Which value denotes "positive" depends on the given (or inferred)
`encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`predicted_negative`](@ref),
[`condition_positive`](@ref)

# Examples

```jldoctest
julia> predicted_positive(0, 1, LabelEnc.ZeroOne()) # single observation
1

julia> predicted_positive([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
3

julia> predicted_positive([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 3
  :b => 3
  :c => 0
```
"""
predicted_positive(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    predicted_negative(targets, outputs, [encoding]) -> Union{Int, Dict}

Count the number of negative predicted outcomes in `outputs`.
Which values denote "negative" depends on the given (or inferred)
`encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`predicted_positive`](@ref),
[`condition_negative`](@ref)

# Examples

```jldoctest
julia> predicted_negative(1, 0, LabelEnc.ZeroOne()) # single observation
1

julia> predicted_negative([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
2

julia> predicted_negative([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 3
  :b => 3
  :c => 6
```
"""
predicted_negative(target, output, encoding::BinaryLabelEncoding) =
    Int(isneglabel(output, encoding))

# --------------------------------------------------------------------

"""
    correctly_classified(targets, outputs, [encoding]) -> Union{Int, Dict}

Count the number of predicted outcomes in `outputs` that agree
with the expected outcomes in `targets` under a two-class
interpretation. Which value(s) denote "positive" or "negative"
depends on the given (or inferred) `encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`incorrectly_classified`](@ref),
[`accuracy`](@ref)

# Examples

```jldoctest
julia> correctly_classified(0, 0, LabelEnc.ZeroOne()) # single observation
1

julia> correctly_classified([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
3

julia> correctly_classified([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 3
  :b => 5
  :c => 4
```
"""
correctly_classified(target, output, encoding::BinaryLabelEncoding) =
    Int(isposlabel(target, encoding) == isposlabel(output, encoding))

# --------------------------------------------------------------------

"""
    incorrectly_classified(targets, outputs, [encoding]) -> Union{Int, Dict}

Count the number of predicted outcomes in `outputs` that are
misclassified according to the expected outcomes in `targets`
under a two-class interpretation. Which value(s) denote
"positive" or "negative" depends on the given (or inferred)
`encoding`.
$SCALAR_DESC

$COUNT_ENCODING_DESCR

# Arguments

$COUNT_ARGS

# See also

[`correctly_classified`](@ref),
[`accuracy`](@ref)

# Examples

```jldoctest
julia> incorrectly_classified(0, 1, LabelEnc.ZeroOne()) # single observation
1

julia> incorrectly_classified([1,0,1,1,0], [1,1,1,0,0]) # multiple observations
2

julia> incorrectly_classified([:a,:a,:b,:b,:c,:c], [:a,:b,:b,:b,:a,:a]) # multi-class
Dict{Symbol,$Int} with 3 entries:
  :a => 3
  :b => 1
  :c => 2
```
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
    @eval function ($fun)(
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
