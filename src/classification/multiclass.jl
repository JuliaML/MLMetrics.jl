# Binary and Multiclass
# --------------------------------------------------------------------

@reduce_fraction """
Returns the fraction of positive predicted outcomes in `outputs`
that are true positives according to the correspondig `targets`.
This is also known as "precision" (alias `precision_score`).

```jldoctest
julia> precision_score([0,1,1,0,1], [1,1,1,0,1])
0.75

julia> precision_score([-1,1,1,-1,1], [1,1,1,-1,1])
0.75
```

$ENCODING_DESCR

```jldoctest
julia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:c))
0.6666666666666666
```

$AVGMODE_DESCR

```jldoctest
julia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 1.0
  :b => 0.0
  :c => 0.666667

julia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
0.6

julia> precision_score([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
0.5555555555555555
```
""" ->
positive_predictive_value := true_positives / predicted_condition_positive

const precision_score = positive_predictive_value

# --------------------------------------------------------------------

@reduce_fraction """
Returns the fraction of negative predicted outcomes in `outputs`
that are true negatives according to the corresponding `targets`.

```jldoctest
julia> negative_predictive_value([0,1,1,0,1], [1,1,1,0,1])
1.0

julia> negative_predictive_value([-1,1,1,-1,1], [1,1,1,-1,1])
1.0
```

$ENCODING_DESCR

```jldoctest
julia> negative_predictive_value([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))
0.75
```

$AVGMODE_DESCR

```jldoctest
julia> negative_predictive_value([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 0.75
  :b => 0.75
  :c => 1.0

julia> negative_predictive_value([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
0.8

julia> negative_predictive_value([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
0.8333333333333334
```
""" ->
negative_predictive_value := true_negatives / predicted_condition_negative

# --------------------------------------------------------------------

@reduce_fraction """
Returns the fraction of positive predicted outcomes in `outputs`
that are false positives according to the corresponding
`targets`.

```jldoctest
julia> false_discovery_rate([0,1,1,0,1], [1,1,1,0,1])
0.25

julia> false_discovery_rate([-1,1,1,-1,1], [1,1,1,-1,1])
0.25
```

$ENCODING_DESCR

```jldoctest
julia> false_discovery_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))
1.0
```

$AVGMODE_DESCR

```jldoctest
julia> false_discovery_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 0.0
  :b => 1.0
  :c => 0.333333

julia> false_discovery_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
0.4

julia> false_discovery_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
0.4444444444444444
```
""" ->
false_discovery_rate := false_positives / predicted_condition_positive

# --------------------------------------------------------------------

@reduce_fraction """
Returns the fraction of negative predicted outcomes in `outputs`
that are false negatives according to the corresponding
`targets`.

```jldoctest
julia> false_omission_rate([0,1,1,0,1], [1,1,1,0,1])
0.0

julia> false_omission_rate([-1,1,1,-1,1], [1,1,1,-1,1])
0.0
```

$ENCODING_DESCR

```jldoctest
julia> false_omission_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))
0.25
```

$AVGMODE_DESCR

```jldoctest
julia> false_omission_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 0.25
  :b => 0.25
  :c => 0.0

julia> false_omission_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
0.2

julia> false_omission_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
0.16666666666666666
```
""" ->
false_omission_rate := false_negatives / predicted_condition_negative

# --------------------------------------------------------------------

@reduce_fraction """
Returns the fraction of truly positive observations in `outputs`
that were predicted as positives. What constitutes "truly
positive" depends on to the corresponding `targets`. This is also
known as `recall` or `sensitivity`.

```jldoctest
julia> recall([0,1,1,0,1], [1,1,1,0,1])
1.0

julia> recall([-1,1,1,-1,1], [1,1,1,-1,1])
1.0
```

$ENCODING_DESCR

```jldoctest
julia> recall([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:a))
0.5
```

$AVGMODE_DESCR

```jldoctest
julia> recall([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 0.5
  :b => 0.0
  :c => 1.0

julia> recall([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
0.6

julia> recall([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
0.5
```
""" ->
true_positive_rate := true_positives / condition_positive

const sensitivity = true_positive_rate
const recall = true_positive_rate

# --------------------------------------------------------------------

@reduce_fraction """
Returns the fraction of truly negative observations in `outputs`
that were (wrongly) predicted as positives. What constitutes
"truly negative" depends on to the corresponding `targets`.

```jldoctest
julia> false_positive_rate([0,1,1,0,1], [1,1,1,0,1])
0.5

julia> false_positive_rate([-1,1,1,-1,1], [1,1,1,-1,1])
0.5
```

$ENCODING_DESCR

```jldoctest
julia> false_positive_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))
0.25
```

$AVGMODE_DESCR

```jldoctest
julia> false_positive_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 0.0
  :b => 0.25
  :c => 0.333333

julia> false_positive_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
0.2

julia> false_positive_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
0.19444444444444442
```
""" ->
false_positive_rate := false_positives / condition_negative

# --------------------------------------------------------------------

@reduce_fraction """
Returns the fraction of truely positive observations that were
(wrongly) predicted as negative. What constitutes "truly
positive" depends on to the corresponding `targets`.

```jldoctest
julia> false_negative_rate([0,1,1,0,1], [1,1,1,0,1])
0.0

julia> false_negative_rate([-1,1,1,-1,1], [1,1,1,-1,1])
0.0
```

$ENCODING_DESCR

```jldoctest
julia> false_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:a))
0.5
```

$AVGMODE_DESCR

```jldoctest
julia> false_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 0.5
  :b => 1.0
  :c => 0.0

julia> false_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
0.4

julia> false_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
0.5
```
""" ->
false_negative_rate := false_negatives / condition_positive

# --------------------------------------------------------------------

@reduce_fraction """
Returns the fraction of negative predicted outcomes that are true
negatives according to the corresponding `targets`. This is also
known as `specificity`.

```jldoctest
julia> true_negative_rate([0,1,1,0,1], [1,1,1,0,1])
0.5

julia> true_negative_rate([-1,1,1,-1,1], [1,1,1,-1,1])
0.5
```

$ENCODING_DESCR

```jldoctest
julia> true_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:b))
0.75
```

$AVGMODE_DESCR

```jldoctest
julia> true_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 1.0
  :b => 0.75
  :c => 0.666667

julia> true_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
0.8

julia> true_negative_rate([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
0.8055555555555555
```
""" ->
true_negative_rate := true_negatives / condition_negative

const specificity = true_negative_rate

# --------------------------------------------------------------------

"""
    accuracy(targets, outputs, [encoding]; [normalize = true]) -> Float64

Compute the classification accuracy for the `outputs` given the
`targets`. If `normalize` is `true`, the fraction of correctly
classified observations in `outputs` is returned (according to
`encoding`). Otherwise the total number is returned.

```jldoctest
julia> accuracy([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c])
0.6

julia> accuracy([:a,:b,:a,:c,:c], [:a,:c,:b,:c,:c], normalize=false)
3.0
```

$ENCODING_DESCR

```jldoctest
julia> accuracy([1,0,0,1,1], [1,-1,-1,-1,1], LabelEnc.FuzzyBinary())
0.8
```
"""
function accuracy(targets::AbstractVector,
                  outputs::AbstractArray,
                  encoding::BinaryLabelEncoding;
                  normalize = true)
    @_dimcheck length(targets) == length(outputs)
    tp::Int = 0; tn::Int = 0
    @inbounds for i = 1:length(targets)
        target = targets[i]
        output = outputs[i]
        tp += true_positives(target, output, encoding)
        tn += true_negatives(target, output, encoding)
    end
    correct = tp + tn
    normalize ? Float64(correct/length(targets)) : Float64(correct)
end

function accuracy(object; normalize = true)
    correct = true_positives(object) + true_negatives(object)
    normalize ? Float64(correct/nobs(object)) : Float64(correct)
end

function accuracy(targets::AbstractVector,
                  outputs::AbstractArray,
                  encoding::LabelEncoding;
                  normalize = true)
    @_dimcheck length(targets) == length(outputs)
    correct::Int = 0
    @inbounds for i = 1:length(targets)
        correct += targets[i] == outputs[i]
    end
    normalize ? Float64(correct/length(targets)) : Float64(correct)
end

function accuracy(targets::AbstractVector,
                  outputs::AbstractArray,
                  labels::AbstractVector;
                  normalize = true)
    accuracy(targets, outputs, LabelEnc.NativeLabels(labels), normalize = normalize)::Float64
end

function accuracy(targets::AbstractVector,
                  outputs::AbstractArray;
                  normalize = true)
    accuracy(targets, outputs, comparemode(targets, outputs), normalize = normalize)::Float64
end

# --------------------------------------------------------------------

"""
    f_score(targets, outputs, [encoding], [avgmode], [β = 1]) -> Float64

Compute the F-score for the `outputs` given the `targets`.
The F-score is a measure for accessing the quality of binary
predictor by considering both *recall* and the *precision*.

```jldoctest
julia> recall([1,0,0,1,1], [1,0,0,0,1])
0.6666666666666666

julia> precision_score([1,0,0,1,1], [1,0,0,0,1])
1.0

julia> f_score([1,0,0,1,1], [1,0,0,0,1])
0.8
```

The parameter `β` can be used to balance the importance of recall
vs precision. The default `β = 1` corresponds to the harmonic
mean. A value of `β > 1` weighs recall higher than precision,
while a value of `β < 1` weighs recall lower than precision.

```jldoctest
julia> f_score([1,0,0,1,1], [1,0,0,0,1], 2)
0.7142857142857143

julia> f_score([1,0,0,1,1], [1,0,0,0,1], 0.5)
0.9090909090909091
```

$ENCODING_DESCR

```jldoctest
julia> f_score([1,0,0,1,1], [1,-1,-1,-1,1], LabelEnc.FuzzyBinary())
0.8
```
"""
function f_score(targets::AbstractVector,
                 outputs::AbstractArray,
                 encoding::BinaryLabelEncoding,
                 β::Number = 1.0)
    @_dimcheck length(targets) == length(outputs)
    β² = abs2(β)
    tp::Int = 0; fp::Int = 0; fn::Int = 0
    @inbounds for i = 1:length(targets)
        target = targets[i]
        output = outputs[i]
        tp += true_positives(target,  output, encoding)
        fp += false_positives(target, output, encoding)
        fn += false_negatives(target, output, encoding)
    end
    (1+β²)*tp / ((1+β²)*tp + β²*fn + fp)
end

function f_score(object, β::Number = 1.0)
    β² = abs2(β)
    tp = true_positives(object)
    fp = false_positives(object)
    fn = false_negatives(object)
    (1+β²)*tp / ((1+β²)*tp + β²*fn + fp)
end

# Micro averaging multiclass f-score
function f_score(targets::AbstractVector,
                 outputs::AbstractArray,
                 encoding::LabelEncoding,
                 avgmode::AvgMode.Micro,
                 β::Number = 1.0)
    r = true_positive_rate(targets, outputs, avgmode = avgmode)
    p = positive_predictive_value(targets, outputs, avgmode = avgmode)
    β² = abs2(β)
    ((1+β²)*(p*r)) / (β²*(p+r))
end

# Macro averaging multiclass f-score
function f_score(targets::AbstractVector,
                 outputs::AbstractArray,
                 encoding::LabelEncoding,
                 avgmode::AverageMode,
                 β::Number = 1.0)
    @_dimcheck length(targets) == length(outputs)
    labels = label(encoding)
    n = length(labels)
    ovr = [LabelEnc.OneVsRest(l) for l in labels]
    precision_ = zeros(n)
    recall_ = zeros(n)
    @inbounds for j = 1:n
        recall_[j] = true_positive_rate(targets, outputs, ovr[j])
        precision_[j] = positive_predictive_value(targets, outputs, ovr[j])
    end
    β² = abs2(β)
    scores = ((1.0 .+ β²) .* (precision_ .* recall_)) ./ (β² .* (precision_ .+ recall_))
    aggregate_score(scores, labels, avgmode)
end

function f_score(targets::AbstractVector,
                 outputs::AbstractArray,
                 encoding::LabelEncoding,
                 β::Number = 1.0)
    f_score(targets, outputs, encoding, AvgMode.None(), β)
end

f_score(targets, outputs, labels::AbstractVector, args...) =
    f_score(targets, outputs, LabelEnc.NativeLabels(labels), args...)

f_score(targets, outputs, β::Number = 1.0) =
    f_score(targets, outputs, comparemode(targets, outputs), AvgMode.None(), β)

f_score(targets, outputs, avgmode::AverageMode, β::Number = 1.0) =
    f_score(targets, outputs, comparemode(targets, outputs), avgmode, β)

"""
    f1_score(targets, outputs, [encoding], [avgmode])

Same as [`f_score`](@ref), but with `β` fixed to 1.
"""
f1_score(targets, outputs) = f_score(targets, outputs, 1.0)
f1_score(object) = f_score(object, 1.0)
f1_score(targets, outputs, enc::LabelEncoding) = f_score(targets, outputs, enc, 1.0)
f1_score(targets, outputs, avgmode::AverageMode) = f_score(targets, outputs, avgmode)
f1_score(targets, outputs, enc::LabelEncoding, avgmode::AverageMode) = f_score(targets, outputs, enc, avgmode, 1.0)

aggregate_score(score, labels, ::AvgMode.None) = Dict(Pair.(labels, score))
aggregate_score(score, labels, ::AvgMode.Macro) = mean(score)
aggregate_score(score, labels, ::AvgMode.Micro) = error("AvgMode.Micro is undetermined.")

# --------------------------------------------------------------------

@map_fraction """
Compute the positive likelihood ratio for the given `outputs` and
`targets`. It is a useful meassure for assessing the quality of a
diagnostic test and is defined as `sensitivity / (1 -
specificity)`. This can also be written as `true_positive_rate /
false_positive_rate`.

```jldoctest
julia> positive_likelihood_ratio([0,1,1,0,1], [1,1,1,0,1])
2.0

julia> positive_likelihood_ratio([-1,1,1,-1,1], [1,1,1,-1,1])
2.0
```

$ENCODING_DESCR

```jldoctest
julia> positive_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:c))
3.0
```

$AVGMODE_DESCR

```jldoctest
julia> positive_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 0.0
  :b => 0.0
  :c => 3.0

julia> positive_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
1.3333333333333335

julia> positive_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
1.090909090909091
```
""" ->
positive_likelihood_ratio := true_positive_rate / false_positive_rate

# --------------------------------------------------------------------

@map_fraction """
Compute the negative likelihood ratio for the given `outputs` and
`targets`. It is a useful meassure for assessing the quality of a
diagnostic test and is defined as `(1 - sensitivity) /
specificity`. This can also be written as `false_negative_rate /
true_negative_rate`.

```jldoctest
julia> negative_likelihood_ratio([0,1,1,0,1], [1,0,1,0,1])
0.6666666666666666

julia> negative_likelihood_ratio([-1,1,1,-1,1], [1,-1,1,-1,1])
0.6666666666666666
```

$ENCODING_DESCR

```jldoctest
julia> negative_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], LabelEnc.OneVsRest(:a))
1.3333333333333333
```

$AVGMODE_DESCR

```jldoctest
julia> negative_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 1.33333
  :b => 1.5
  :c => 0.0

julia> negative_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:micro)
0.8571428571428572

julia> negative_likelihood_ratio([:b,:b,:a,:c,:c], [:a,:c,:b,:c,:c], avgmode=:macro)
0.9600000000000002
```
""" ->
negative_likelihood_ratio := false_negative_rate / true_negative_rate

# --------------------------------------------------------------------

@map_fraction """
Compute the diagnostic odds ratio (DOR) for the given `outputs`
and `targets`. It is a useful meassure of the effectiveness of a
diagnostic test and is defined as `positive_likelihood_ratio /
negative_likelihood_ratio`.

```jldoctest
julia> diagnostic_odds_ratio([0,1,1,0,1], [1,0,1,0,1])
2.0

julia> diagnostic_odds_ratio([-1,1,1,-1,1], [1,-1,1,-1,1])
2.0
```

$ENCODING_DESCR

```jldoctest
julia> diagnostic_odds_ratio([:b,:b,:a,:c,:c], [:a,:b,:b,:c,:c], LabelEnc.OneVsRest(:b))
2.0
```

$AVGMODE_DESCR

```jldoctest
julia> diagnostic_odds_ratio([:b,:b,:a,:c,:c], [:a,:b,:b,:c,:c]) # avgmode=:none
Dict{Symbol,Float64} with 3 entries:
  :a => 0.0
  :b => 2.0
  :c => Inf

julia> diagnostic_odds_ratio([:b,:b,:a,:c,:c], [:a,:b,:b,:c,:c], avgmode=:micro)
5.999999999999999

julia> diagnostic_odds_ratio([:b,:b,:a,:c,:c], [:a,:b,:b,:c,:c], avgmode=:macro)
4.142857142857143
```
""" ->
diagnostic_odds_ratio := positive_likelihood_ratio / negative_likelihood_ratio
# FIXME: maybe check if both false negatives and false positives are zero

# --------------------------------------------------------------------

# TODO: make this work for AvgMode and LabelEncoding
function matthews_corrcoef(target, output)
    @_dimcheck length(target) == length(output)
    tp = true_positives(target, output)
    tn = true_negatives(target, output)
    fp = false_positives(target, output)
    fn = false_negatives(target, output)
    numerator = (tp * tn) - (fp * fn)
    denominator = (tp + fp) * (tp + fn) * (tn + fp) * (tn + fn)
    return(numerator / (denominator ^ 0.5))
end
