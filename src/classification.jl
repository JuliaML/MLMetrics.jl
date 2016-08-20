# ============================================================
# (Fuzzy)Binary only: Define what it means to be positive / negative

@inline is_positive(value) = _ambiguous()
@inline is_positive(value, bc::Binary) = (value == bc.pos_label)
@inline is_positive(value::Bool) = value
@inline is_positive{T<:Real}(value::T) = (value > zero(T))

@inline is_negative(value) = _ambiguous()
@inline is_negative(value, bc::Binary) = (value != bc.pos_label)
@inline is_negative{T<:Real}(value::T) = (value <= zero(T))

# ============================================================

"""
    true_positives(target, output, ::FuzzyBinary)

Returns `1` if both target and output are considered stricktly
positive on their own. They are not compared to each other.
Returns `0` otherwise.
$pos_examples
"""
@inline true_positives(target, output, ::FuzzyBinary) =
    Int(is_positive(target) && is_positive(output))

"""
    true_positives(target, output, bc::Binary)

Returns `1` if both, `target` and `output` are equal to
`bc.pos_label`. Returns `0` otherwise.
"""
@inline true_positives(target, output, bc::Binary) =
    Int(is_positive(target, bc) && is_positive(output, bc))

# ============================================================

"""
    true_negatives(target, output, ::FuzzyBinary)

Returns `1` if both target and output are considered zero or
negative on their own. They are not compared to each other.
Returns `0` otherwise.
$neg_examples
"""
@inline true_negatives(target, output, ::FuzzyBinary) =
    Int(is_negative(target) && is_negative(output))

"""
    true_negatives(target, output, bc::Binary)

Returns `1` if both, `target` and `output` are **not** equal to
`bc.pos_label`. Returns `0` otherwise.
"""
@inline true_negatives(target, output, bc::Binary) =
    Int(is_negative(target, bc) && is_negative(output, bc))

# ============================================================

"""
    false_positives(target, output, ::FuzzyBinary)

Returns `1` if `target` is considered zero or negative,
and `output` is considered stricktly positive.
Returns `0` otherwise.
$pos_examples
$neg_examples
"""
@inline false_positives(target, output, ::FuzzyBinary) =
    Int(is_negative(target) && is_positive(output))

"""
    false_positives(target, output, bc::Binary)

Returns `1` if `target` is **not** equal to `bc.pos_label,
while `output` is equal to it. Returns `0` otherwise.
"""
@inline false_positives(target, output, bc::Binary) =
    Int(is_negative(target, bc) && is_positive(output, bc))

type_1_errors = false_positives

# ============================================================

"""
    false_negatives(target, output, ::FuzzyBinary)

Returns `1` if `target` is considered strickly positive,
and `output` is considered zero or negative.
Returns `0` otherwise.
$pos_examples
$neg_examples
"""
@inline false_negatives(target, output, ::FuzzyBinary) =
    Int(is_positive(target) && is_negative(output))

"""
    false_negatives(target, output, bc::Binary)

Returns `1` if `target` is equal to `bc.pos_label,
while `output` is **not** equal to it. Returns `0` otherwise.
"""
@inline false_negatives(target, output, bc::Binary) =
    Int(is_positive(target, bc) && is_negative(output, bc))

type_2_errors = false_negatives

# ============================================================

"""
    condition_positive(target, output, ::FuzzyBinary)

Returns `1` if `target` is considered strictly positive.
Returns `0` otherwise.
$pos_examples
"""
@inline condition_positive(target, output, ::FuzzyBinary) =
    Int(is_positive(target))

"""
    condition_positive(target, output, bc::Binary)

Returns `1` if `target` is equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline condition_positive(target, output, bc::Binary) =
    Int(is_positive(target, bc))

"""
    prevalence(target, output, bc::(Fuzzy)Binary)

Returns the fraction of positive observations in `target`.
What constitudes as positive depends on `bc`
"""
prevalence(target, output, bc) =
    condition_positive(target, output, bc) / length(target)

# ============================================================

"""
    condition_negative(target, output, ::FuzzyBinary)

Returns `1` if `target` is considered zero or negative.
Returns `0` otherwise.
$neg_examples
"""
@inline condition_negative(target, output, ::FuzzyBinary) =
    Int(is_negative(target))

"""
    condition_negative(target, output, bc::Binary)

Returns `1` if `target` is **not** equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline condition_negative(target, output, bc::Binary) =
    Int(is_negative(target, bc))

# ============================================================

"""
    predicted_condition_positive(target, output, ::FuzzyBinary)

Returns `1` if `output` is considered strictly positive.
Returns `0` otherwise.
$pos_examples
"""
@inline predicted_condition_positive(target, output, ::FuzzyBinary) =
    Int(is_positive(output))

"""
    predicted_condition_positive(target, output, bc::Binary)

Returns `1` if `output` is equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline predicted_condition_positive(target, output, bc::Binary) =
    Int(is_positive(output, bc))

# ============================================================

"""
    predicted_condition_negative(target, output, ::FuzzyBinary)

Returns `1` if `output` is considered zero or negative.
Returns `0` otherwise.
$neg_examples
"""
@inline predicted_condition_negative(target, output, ::FuzzyBinary) =
    Int(is_negative(output))

"""
    predicted_condition_negative(target, output, bc::Binary)

Returns `1` if `output` is **not** equal to `bc.pos_label.
Returns `0` otherwise.
"""
@inline predicted_condition_negative(target, output, bc::Binary) =
    Int(is_negative(output, bc))

# ============================================================
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

        If either `target` or `output` is of type `Bool` then
        `FuzzyBinary` is inferred to compute the
        **$($fun_desc)**. Any other type combination is ambiguous
        and will result in an error.
        """ ->
        ($fun)(target, output) = ($fun)(target, output, CompareMode.auto(target,output))
    end

    # Default to fuzzy comparison if boolean values are involed
    for _T2 in (:Bool, :Real, :Any)
        @eval begin
            ($fun)(target::$_T2, output::Bool) =
                ($fun)(target, output, FuzzyBinary())
            ($fun)(target::Bool, output::$_T2) =
                ($fun)(target, output, FuzzyBinary())
        end
    end
end

# ============================================================
# (Fuzzy)Binary: Generate shared accumulator
for fun in (:true_positives,  :true_negatives,
            :false_positives, :false_negatives,
            :condition_positive, :condition_negative,
            :predicted_condition_positive, :predicted_condition_negative)
    fun_name = string(fun)
    fun_desc = rstrip(replace(string(fun), r"([a-z]+)_?([a-z]*)", s"\1 \2"))
    @eval @doc """
        $($fun_name)(target::AbstractVector, output::AbstractArray, bc::(Fuzzy)Binary)

    Counts the total number of **$($fun_desc)** in `output` by
    comparing each element against the corresponding value in
    `target` according to `bc`. Both parameters are expected
    to be vectors, but `output` is allowed to be a row-vector.
    """ $fun
    for _T in (:FuzzyBinary, :Binary) # avoid ambiguity warnings
        @eval function ($fun)(target::AbstractVector,
                              output::AbstractArray,
                              compare::$_T)
            @_dimcheck length(target) == length(output)
            result = 0
            @inbounds for i = 1:length(target)
                result += ($fun)(target[i], output[i], compare)
            end
            result
        end
    end
end

# ============================================================

"""
    accuracy(target, output, bc::(Fuzzy)Binary; normalize = true)

If `normalize` is `true`, the fraction of correctly classified
observations is returned. Returns the total number otherwise.
"""
function accuracy_score(target::AbstractVector,
                        output::AbstractArray,
                        bc::AbstractBinary;
                        normalize = true)
    @_dimcheck length(target) == length(output)
    tp = 0; tn = 0
    @inbounds for i = 1:length(target)
        tp += true_positives(target[i], output[i], bc)
        tn += true_negatives(target[i], output[i], bc)
    end
    correct = tp + tn
    normalize ? correct/length(target) : Float64(correct)
end

"""
    accuracy(target, output, [mc::MultiClass]; normalize = true)

If `normalize` is `true`, the fraction of matching elements in
`target` and `output` are returned.
Otherwise the total number of matching elements are returned.
"""
function accuracy_score(target::AbstractVector,
                        output::AbstractArray,
                        mc::AbstractMultiClass;
                        normalize = true)
    @_dimcheck length(target) == length(output)
    correct = 0
    @inbounds for i = 1:length(target)
        correct += target[i] == output[i]
    end
    normalize ? correct/length(target) : Float64(correct)
end

function accuracy_score(target::AbstractVector,
                        output::AbstractArray;
                        nargs...)
    accuracy_score(target, output, FuzzyMultiClass(); nargs...)::Float64
end

accuracy = accuracy_score

# ============================================================

"""
    precision_score(target, output, bc::(Fuzzy)Binary)

Returns the fraction of positive predicted outcomes that
are true positives (as Float64).
"""
function precision_score(target::AbstractVector,
                         output::AbstractArray,
                         bc::AbstractBinary)
    @_dimcheck length(target) == length(output)
    tp = 0; pcp = 0
    @inbounds for i = 1:length(target)
        tp  += true_positives(target[i], output[i], bc)
        pcp += predicted_condition_positive(target[i], output[i], bc)
    end
    tp / pcp
end

positive_predictive_value = precision_score

# ============================================================

function false_discovery_rate(target, output)
    @_dimcheck length(target) == length(output)
    fp = false_positives(target, output)
    pcp = predicted_condition_positive(target, output)
    return(fp / pcp)
end

function negative_predictive_value(target, output)
    @_dimcheck length(target) == length(output)
    tn = true_negatives(target, output)
    pcn = predicted_condition_negative(target, output)
    return(tn / pcn)
end

function false_omission_rate(target, output)
    @_dimcheck length(target) == length(output)
    fn = false_negatives(target, output)
    pcn = predicted_condition_negative(target, output)
    return(fn / pcn)
end

function true_positive_rate(target, output)
    @_dimcheck length(target) == length(output)
    tp = true_positives(target, output)
    cp = condition_positive(target, output)
    return(tp / cp)
end

sensitivity = true_positive_rate
recall = true_positive_rate

function false_positive_rate(target, output)
    @_dimcheck length(target) == length(output)
    fp = false_positives(target, output)
    cn = condition_negative(target, output)
    return(fp / cn)
end

function false_negative_rate(target, output)
    @_dimcheck length(target) == length(output)
    fn = false_negatives(target, output)
    cp = condition_positive(target, output)
    return(fn / cp)
end

function true_negative_rate(target, output)
    @_dimcheck length(target) == length(output)
    tn = true_negatives(target, output)
    cn = condition_negative(target, output)
    return(tn / cn)
end

specificity = true_negative_rate

function positive_likelihood_ratio(target, output)
    @_dimcheck length(target) == length(output)
    tpr = true_positive_rate(target, output)
    fpr = false_positive_rate(target, output)
    return(tpr / fpr)
end

function negative_likelihood_ratio(target, output)
    @_dimcheck length(target) == length(output)
    fnr = false_negative_rate(target, output)
    tnr = true_negative_rate(target, output)
    return(fnr / tnr)
end

function diagnostic_odds_ratio(target, output)
    @_dimcheck length(target) == length(output)
    plr = positive_likelihood_ratio(target, output)
    nlr = negative_likelihood_ratio(target, output)
    return(plr / nlr)
end

function f1_score(target, output)
    @_dimcheck length(target) == length(output)
    tp = true_positives(target, output)
    fp = false_positives(target, output)
    fn = false_negatives(target, output)
    return((2 * tp) / (2 * tp + fp + fn))
end

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

