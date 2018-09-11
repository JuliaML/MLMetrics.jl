@testset "test that synonyms work"  begin
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
y_hat_symb  = convertlabel([:pos,:neg], y_hat_p,  LabelEnc.ZeroOne())

# f_score

y_true = [0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2]
y_pred = [0, 1, 0, 1, 0, 1, 0, 1, 2, 2, 1]
@test f_score(y_true, y_pred) == Dict{Int, Float64}(0 => 0.5714285714285715, 1 => 0.6, 2=>0.8)
@test f_score(y_true, y_pred, 2.0) == Dict(0 => 0.35714285714285715, 2 => 0.5, 1 => 0.375)
@test f_score(y_true, y_pred, LabelEnc.NativeLabels(unique(y_true))) == Dict{Int, Float64}(0 => 0.5714285714285715, 1 => 0.6, 2=>0.8)
@test f_score(y_true, y_pred, LabelEnc.NativeLabels(unique(y_true)), 1) == Dict{Int, Float64}(0 => 0.5714285714285715, 1 => 0.6, 2=>0.8)
@test f_score(y_true, y_pred, AvgMode.Macro()) ≈ 0.6571428571428571
@test f_score(y_true, y_pred, AvgMode.Macro(), 1) ≈ 0.6571428571428571
@test f_score(y_true, y_pred, AvgMode.Micro()) ≈ 0.6363636363636364
@test f_score(y_true, y_pred, LabelEnc.NativeLabels(unique(y_true)), AvgMode.Micro()) ≈ 0.6363636363636364
@test f_score(y_true, y_pred, LabelEnc.NativeLabels(unique(y_true)), AvgMode.Micro(), 1) ≈ 0.6363636363636364
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
        cm3 = @inferred confusions(y_true_symb, y_hat_symb, LabelEnc.NativeLabels([:pos, :neg]))
        @test cm1 === cm2
        @test cm1 === cm3
        @test @inferred(fun(cm1)) ≈ ref
    end
end
#=
# matthews_corrcoef
@test matthews_corrcoef(y_true, y_hat) == 0.0
=#
