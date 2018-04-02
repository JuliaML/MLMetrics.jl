struct BinaryConfusionMatrix{T<:Number} <: AbstractArray{T,2}
    true_positives::T
    false_positives::T
    false_negatives::T
    true_negatives::T
end

BinaryConfusionMatrix() = BinaryConfusionMatrix{Int}(0,0,0,0)
BinaryConfusionMatrix(a::AbstractArray) = BinaryConfusionMatrix{Int}(a...)

function Base.:(+)(a::BinaryConfusionMatrix{T},
                   b::BinaryConfusionMatrix{S}) where {T,S}
    BinaryConfusionMatrix{promote_type(T,S)}(
        a.true_positives  + b.true_positives,
        a.false_positives + b.false_positives,
        a.false_negatives + b.false_negatives,
        a.true_negatives  + b.true_negatives,
    )
end

Base.size(c::BinaryConfusionMatrix) = (2, 2)
function Base.getindex(c::BinaryConfusionMatrix, i::Int, j::Int)
    ifelse((i == 1) & (j == 1), c.true_positives,
    ifelse((i == 2) & (j == 1), c.false_positives,
    ifelse((i == 1) & (j == 2), c.false_negatives, c.true_negatives)))
end

true_positives(c::BinaryConfusionMatrix)  = c.true_positives
false_positives(c::BinaryConfusionMatrix) = c.false_positives
true_negatives(c::BinaryConfusionMatrix)  = c.true_negatives
false_negatives(c::BinaryConfusionMatrix) = c.false_negatives
condition_positive(c::BinaryConfusionMatrix) =
    true_positives(c) + false_negatives(c)
condition_negative(c::BinaryConfusionMatrix) =
    true_negatives(c) + false_positives(c)
LearnBase.nobs(c::BinaryConfusionMatrix) =
    condition_positive(c) + condition_negative(c)
prevalence(c::BinaryConfusionMatrix) =
    condition_positive(c) / nobs(c)
predicted_condition_positive(c::BinaryConfusionMatrix) =
    true_positives(c) + false_positives(c)
predicted_condition_negative(c::BinaryConfusionMatrix) =
    true_negatives(c) + false_negatives(c)

function Base.show(io::IO, ::MIME"text/plain", c::BinaryConfusionMatrix)
    println(io, summary(c), ":")
    tp = string(true_positives(c))
    fp = string(false_positives(c))
    fn = string(false_negatives(c))
    tn = string(true_negatives(c))
    len_p = max(maximum(map(length, (tp, fp))), 3)
    len_n = max(maximum(map(length, (fn, tn))), 3)
    tp = lpad(tp, len_p); fp = lpad(fp, len_p)
    fn = lpad(fn, len_n); tn = lpad(tn, len_n)
    pad = "  "
    println(io, pad, " ", "Predicted")
    println(io, pad, "  ", lpad("+",len_p), "   ", lpad("-",len_n))
    println(io, pad, "┌", repeat("─",len_p+2), "┬", repeat("─",len_n+2), "┐")
    println(io, pad, "│ ", tp, " │ ", fn, " │ +")
    println(io, pad, "├", repeat("─",len_p+2), "┼", repeat("─",len_n+2), "┤   Actual")
    println(io, pad, "│ ", fp, " │ ", tn, " │ -")
    println(io, pad, "└", repeat("─",len_p+2), "┴", repeat("─",len_n+2), "┘")
    println(io, pad, "   f1_score: ", round(f1_score(c),4))
    println(io, pad, "   accuracy: ", round(accuracy(c),4))
    println(io, pad, "  precision: ", round(precision_score(c),4))
    println(io, pad, "sensitivity: ", round(sensitivity(c),4))
    print(io, pad,   "specificity: ", round(specificity(c),4))
end

# --------------------------------------------------------------------

function confusions(targets::AbstractArray{T},
                    outputs::AbstractArray,
                    encoding::AbstractVector) where T
    length(encoding) == 2 || error("Multiclass not yet implemented")
    confusions(targets, outputs, LabelEnc.NativeLabels{T,2}(encoding))
end

# Generic fallback. Tries to infer label encoding
function confusions(targets, outputs)
    encoding = comparemode(targets, outputs)
    nlabel(encoding) == 2 || error("Multiclass not yet implemented")
    confusions(targets, outputs, encoding)
end

function confusions(targets::AbstractArray,
                    outputs::AbstractArray,
                    encoding::BinaryLabelEncoding)
    @_dimcheck length(targets) == length(outputs)
    tp = 0; tn = 0;
    fp = 0; fn = 0;
    @inbounds for i in 1:length(targets)
        target = targets[i]
        output = outputs[i]
        tp += true_positives(target, output, encoding)
        fp += false_positives(target, output, encoding)
        fn += false_negatives(target, output, encoding)
        tn += true_negatives(target, output, encoding)
    end
    BinaryConfusionMatrix{Int}(tp, fp, fn, tn)
end

function confusions(targets::AbstractArray,
                    outputs::AbstractArray,
                    thresholds::AbstractVector,
                    encoding::BinaryLabelEncoding)
    @_dimcheck length(targets) == length(outputs)
    curve = fill(BinaryConfusionMatrix(), length(thresholds))
    @inbounds for i in 1:length(targets)
        target = targets[i]
        output = outputs[i]
        for (j, th) in enumerate(thresholds)
            pred = convertlabel(encoding, classify(output, th), LabelEnc.ZeroOne())
            curve[j] += BinaryConfusionMatrix{Int}(
                true_positives(target, pred, encoding),
                false_positives(target, pred, encoding),
                false_negatives(target, pred, encoding),
                true_negatives(target, pred, encoding),
            )
        end
    end
    curve
end

# --------------------------------------------------------------------

struct ROCCurve{T<:Number,F<:Number,V<:AbstractVector{F}} <: AbstractArray{Tuple{F,BinaryConfusionMatrix{T}},1}
    thresholds::V
    confusions::Vector{BinaryConfusionMatrix{T}}
end

function ROCCurve(thresholds::AbstractVector, confusions::Vector{BinaryConfusionMatrix{T}}) where T
    ROCCurve{T,eltype(thresholds),typeof(thresholds)}(thresholds, confusions)
end

function Base.:(+)(r1::ROCCurve, r2::ROCCurve)
    @assert r1.thresholds == r2.thresholds
    nm = r1.confusions .+ r2.confusions
    ROCCurve(r1.thresholds, nm)
end

Base.size(r::ROCCurve) = size(r.confusions)
Base.@propagate_inbounds function Base.getindex(r::ROCCurve, I::Int...)
    (r.thresholds[I...], r.confusions[I...])
end
Base.@propagate_inbounds function Base.setindex!(r::ROCCurve, tup::Tuple, I::Int...)
    r.thresholds[I...] = tup[1]
    r.confusions[I...] = tup[2]
end
Base.@propagate_inbounds function Base.setindex!(r::ROCCurve, v::BinaryConfusionMatrix, I::Int...)
    r.confusions[I...] = v
end

for fun in (:true_positives,  :true_negatives,
            :false_positives, :false_negatives,
            :condition_positive, :condition_negative, :prevalence,
            :predicted_condition_positive, :predicted_condition_negative,
            :true_positive_rate, :false_positive_rate,
            :true_negative_rate, :false_negative_rate,
            :positive_predictive_value, :negative_predictive_value,
            :false_discovery_rate, :false_omission_rate,
            :accuracy, :f_score, :f1_score,
            :positive_likelihood_ratio, :negative_likelihood_ratio,
            :diagnostic_odds_ratio)
    @eval ($fun)(r::ROCCurve) = Base.broadcast(($fun), r.confusions)
end

confusions(r::ROCCurve) = r.confusions

function confusions_at_sensitivity(r::ROCCurve, at::Number)
    @assert 0 <= at <= 1
    idx = findfirst(s -> s >= at, sensitivity(r))
    r[idx][2]
end

function specificity_at_sensitivity(r::ROCCurve, at::Number)
    specificity(confusions_at_sensitivity(r, at))
end

function precision_at_sensitivity(r::ROCCurve, at::Number)
    precision_score(confusions_at_sensitivity(r, at))
end

function accuracy_at_sensitivity(r::ROCCurve, at::Number)
    accuracy(confusions_at_sensitivity(r, at))
end

function Base.show(io::IO, r::ROCCurve)
    print(io, length(r), "-element ", typeof(r).name, " (auc: ", round(auc(r),5), ")")
end

function Base.show(io::IO, ::MIME"text/plain", r::ROCCurve)
    println(io, summary(r), ":")
    fpr = false_positive_rate(r)
    tpr = true_positive_rate(r)
    p = lineplot(fpr, tpr, height=10, width=21, xlim=[0,1], ylim=[0,1], canvas=DotCanvas)
    annotate!(p, :r, 1, "auc: $(round(auc_from_rates(fpr, tpr),5))")
    lineplot!(p, 0, 1, color=:white)
    xlabel!(p, "FPR")
    ylabel!(p, "TPR")
    print(io, string(p)[1:end-6])
end

# --------------------------------------------------------------------

auc(r::ROCCurve) = auc_from_rates(false_positive_rate(r), true_positive_rate(r))
auc(args...) = auc(roc(args...))

function auc_from_rates(fpr::AbstractVector{T}, tpr::AbstractVector{R}) where {T,R}
    O = promote_type(T,R)
    @_dimcheck length(fpr) == length(tpr)
    dfpr = diff(fpr)
    dtpr = diff(tpr)
    a = zero(O); b = zero(O)
    @inbounds for i in 1:length(fpr)-1
        a += tpr[i] * dfpr[i]
        b += dtpr[i] * dfpr[i]
    end
    a + b / 2
end

# --------------------------------------------------------------------

function roc(targets::AbstractArray,
             outputs::AbstractArray,
             thresholds::Number = 100,
             encoding::BinaryLabelEncoding = labelenc(targets))
    roc(targets, outputs, linspace(1,0,thresholds), encoding)
end

function roc(targets::AbstractArray,
             outputs::AbstractArray,
             encoding::BinaryLabelEncoding)
    roc(targets, outputs, 100, encoding)
end

function roc(targets::AbstractArray,
             outputs::AbstractArray,
             thresholds::AbstractVector,
             encoding::BinaryLabelEncoding = labelenc(targets))
    curve = confusions(targets, outputs, thresholds, encoding)
    ROCCurve(thresholds, curve)
end
