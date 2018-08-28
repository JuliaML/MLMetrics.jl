using MLLabelUtils: LabelEnc.FuzzyBinary

@testset "test that synonyms work"  begin
    @test type_1_errors === false_positives
    @test type_2_errors === false_negatives
    @test precision_score === positive_predictive_value
    @test sensitivity === true_positive_rate
    @test recall === true_positive_rate
    @test specificity === true_negative_rate
end

y_true_p = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0]
y_true_m = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1,-1,-1,-1]
y_true_b = Vector{Bool}(y_true_p)
y_true_pf = Vector{Float64}(y_true_p)
y_true_mf = Vector{Float64}(y_true_m)
targets = (y_true_p, y_true_m, y_true_b, y_true_pf, y_true_mf)
y_true_symb = convertlabel([:pos,:neg], y_true_p, LabelEnc.ZeroOne())

y_hat_p  = [1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0]
y_hat_m  = [1, 1,-1,-1, 1,-1, 1,-1,-1, 1,-1, 1,-1, 1,-1, 1,-1]
y_hat_b  = Vector{Bool}(y_hat_p)
y_hat_pf = Vector{Float64}(y_hat_p)
y_hat_mf = Vector{Float64}(y_hat_m)
outputs = (y_hat_p, y_hat_m, y_hat_b, y_hat_pf, y_hat_mf, y_hat_b')
y_hat_symb = convertlabel([:pos,:neg], y_hat_p, LabelEnc.ZeroOne())

# Compare output of functions with single value parameters against mask
# This also tests type stability
for (fun, mask) = ((true_positives,  (0,0,0,1)),
                   (true_negatives,  (1,0,0,0)),
                   (false_positives, (0,1,0,0)),
                   (false_negatives, (0,0,1,0)),
                   (condition_positive, (0,0,1,1)),
                   (condition_negative, (1,1,0,0)),
                   (predicted_condition_positive, (0,1,0,1)),
                   (predicted_condition_negative, (1,0,1,0)))
    @testset "$fun: fuzzy binary matching" begin
        @testset "Bool parameters" begin
            @test fun(false, false) === mask[1]
            @test fun(false, true ) === mask[2]
            @test fun(true,  false) === mask[3]
            @test fun(true,  true ) === mask[4]
            @test fun(false, false, FuzzyBinary()) === mask[1]
            @test fun(false, true , FuzzyBinary()) === mask[2]
            @test fun(true,  false, FuzzyBinary()) === mask[3]
            @test fun(true,  true , FuzzyBinary()) === mask[4]
        end
        @testset "Real parameters" begin
            for pos = (1, 2), neg = (0, -1, -2)
                for T1 = (Int32, Int64, Float32, Float64)
                    for T2 = (Int32, Int64, Float32, Float64)
                        @testset "$T1 against $T2" begin
                            @test fun(T1(neg), T2(neg), FuzzyBinary()) === mask[1]
                            @test fun(T1(neg), T2(pos), FuzzyBinary()) === mask[2]
                            @test fun(T1(pos), T2(neg), FuzzyBinary()) === mask[3]
                            @test fun(T1(pos), T2(pos), FuzzyBinary()) === mask[4]
                        end
                    end
                end
            end
        end
        @testset "mixed parameters" begin
            for pos = (1, true, 0.5, 1.), neg = (0, -1, -2, false, 0.)
                @testset "pos = $pos, neg = $neg" begin
                    @test fun(neg, neg, FuzzyBinary()) === mask[1]
                    @test fun(neg, pos, FuzzyBinary()) === mask[2]
                    @test fun(pos, neg, FuzzyBinary()) === mask[3]
                    @test fun(pos, pos, FuzzyBinary()) === mask[4]
                    if typeof(pos) <: Bool || typeof(neg) <: Bool
                        @test fun(neg, pos) === mask[2]
                        @test fun(pos, neg) === mask[3]
                    end
                end
            end
        end
    end
end

# f_score

y_true = [0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2]
y_pred = [0, 1, 0, 1, 0, 1, 0, 1, 2, 2, 1]
@test f_score(y_true, y_pred) == Dict{Int, Float64}(0 => 0.5714285714285715, 1 => 0.6, 2=>0.8)
@test f_score(y_true, y_pred, AvgMode.Macro()) ≈ 0.6571428571428571
@test f_score(y_true, y_pred, AvgMode.Micro()) ≈ 0.6363636363636364
@test f_score(y_true, y_pred, LabelEnc.NativeLabels(unique(y_true)), AvgMode.Micro()) ≈ 0.6363636363636364
@test f_score(y_true, y_pred, 2.0) == Dict(0=>0.35714285714285715,2=>0.5,1=>0.375)
@test sort(collect(keys(f_score(y_true, y_pred, [0, 1, 2])))) == [0, 1, 2]

#=
@testset "multiclass sanity check" begin
    # We count positive strickly positive matches as positives
    @test true_positives([1,2,3,4], [1,3,2,4]) === 2
    @test true_negatives([1,2,3,4], [4,3,2,1]) === 0
    @test accuracy([1,2,3,4], [1,3,2,4]) === .5
    @test accuracy([:a,:b,:b,:c], [:c,:b,:a,:a]) === .25
end
=#
_accuracy_nonorm(args...) = accuracy(args...; normalize=false)
for (fun, ref) = ((true_positives,  5),
                  (true_negatives,  4),
                  (false_positives, 3),
                  (false_negatives, 5),
                  (prevalence, 10/17),
                  (condition_positive, 10),
                  (condition_negative, 7),
                  (predicted_condition_positive, 8),
                  (predicted_condition_negative, 9),
                  (f_score, 0.5555555555555556),
                  (f1_score, 0.5555555555555556),
                  (accuracy, 9/17),
                  (_accuracy_nonorm, 9.),
                  (positive_predictive_value, 5/8),
                  (false_discovery_rate, 3/8),
                  (negative_predictive_value, 4/9),
                  (false_omission_rate, 5/9),
                  (true_positive_rate, 5/10),
                  (false_positive_rate, 3/7),
                  (false_negative_rate, 5/10),
                  (true_negative_rate, 4/7),
                  (positive_likelihood_ratio, 5/10 * 7/3),
                  (negative_likelihood_ratio, 5/10 * 7/4),
                  (diagnostic_odds_ratio, (5/10 * 7/3) / (5/10 * 7/4)))
   @testset "$fun: check against known result" begin
        for target in targets, output in outputs
            @testset "$(typeof(target)) against $(typeof(output))" begin
                @test @inferred(fun(target, output, FuzzyBinary())) ≈ ref
                cm = @inferred confusions(target, output, FuzzyBinary())
                @test cm isa MLMetrics.BinaryConfusionMatrix
                @test @inferred(fun(cm)) ≈ ref
            end
        end
        cm1 = @inferred confusions(y_true_symb, y_hat_symb)
        cm2 = @inferred confusions(y_true_symb, y_hat_symb, [:pos, :neg])
        @test cm1 === cm2
        @test @inferred(fun(cm1)) ≈ ref
    end
end

@testset "BinaryConfusionMatrix" begin
    cm1 = @inferred MLMetrics.BinaryConfusionMatrix(1,2,3,4)
    @test size(cm1) == (2,2)
    @test_reference "references/BinaryConfusionMatrix1.txt" @io2str show(::IO, cm1)
    @test_reference "references/BinaryConfusionMatrix2.txt" @io2str show(::IO, MIME"text/plain"(), cm1)
    @test cm1 == @inferred MLMetrics.BinaryConfusionMatrix(copy(cm1))
    @test cm1 == [1 3; 2 4]
    cm2 = @inferred MLMetrics.BinaryConfusionMatrix(5,6,7,8)
    @test cm2 == [5 7; 6 8]
    cm3 = @inferred cm1 + cm2
    @test cm3 == [6 10; 8 12]
end

@testset "ROCCurve" begin
    y_hat_roc = [.9, 1, 0, .4, .5, .4, .7, .1, .15, .95, .3, .6, .2, .9, .05, .8, .48]
    r = @inferred roc(y_true_symb, y_hat_roc, 10)
    @test length(r) == 10
    r = @inferred roc(y_true_symb, y_hat_roc)
    @test r isa MLMetrics.ROCCurve
    @test r isa AbstractVector
    @test length(r) == 100
    @test_reference "references/ROCCurve1.txt" @io2str show(::IO, r)
    @test_reference "references/ROCCurve2.txt" @io2str show(::IO, MIME"text/plain"(), r)
    @test @inferred(r[1]) == (1.0, [1 9; 0 7])
    @test r[1][2] isa MLMetrics.BinaryConfusionMatrix
    @test precision_score(r) == precision_score.(r.confusions)
    # pROC says 0.5357
    @test @inferred(auc(r)) ≈ 0.5357142857142858
    for target in targets
        @test @inferred(roc(target, y_hat_roc)) == r
        @test @inferred(roc(target, y_hat_roc, LabelEnc.ZeroOne())) == r
        @test @inferred(roc(target, y_hat_roc, 100)) == r
        @test @inferred(roc(target, y_hat_roc, 100, LabelEnc.ZeroOne())) == r
    end
    y_true_roc2 = [1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0]
    y_hat_roc2 = [20, 19, 18, 17, 16, 15, 14, 13, 11.5, 11.5, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1] ./ 20
    r = @inferred roc(y_true_roc2, y_hat_roc2)
    r2 = r + r
    @test r2[10][1] == r[10][1]
    @test r2[10][2] == r[10][2] + r[10][2]
    # pROC says 0.825
    @test @inferred(auc(r)) ≈ 0.825
    @test @inferred(auc(y_true_roc2, y_hat_roc2)) ≈ 0.825
    @test_throws AssertionError precision_at_sensitivity(r, 1.1)
    @test @inferred(precision_at_sensitivity(r, 0)) == 1
    @test @inferred(precision_at_sensitivity(r, 1)) == 0.625
    @test @inferred(precision_at_sensitivity(r, .9)) ≈ 0.6923076923076923
    @test @inferred(specificity_at_sensitivity(r, 0)) == 1
    @test @inferred(specificity_at_sensitivity(r, 1)) == 0.4
    @test @inferred(accuracy_at_sensitivity(r, 0)) == 0.55
    @test @inferred(accuracy_at_sensitivity(r, 1.)) == 0.7
    # setindex
    r = @inferred roc(y_true_roc2, y_hat_roc2, collect(r.thresholds))
    @test_reference "references/ROCCurve3.txt" @io2str show(::IO, MIME"text/plain"(), r)
    r[1] = MLMetrics.BinaryConfusionMatrix([1 2; 3 4])
    @test r[1] == (1.0, [1 2; 3 4])
    r[1] = (1.1, MLMetrics.BinaryConfusionMatrix([5 6; 7 8]))
    @test r[1] == (1.1, [5 6; 7 8])
end

#=
# matthews_corrcoef
@test matthews_corrcoef(y_true, y_hat) == 0.0
=#
