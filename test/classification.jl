@testset "test that synonyms work"  begin
    @test accuracy === accuracy_score
    @test precision_score === positive_predictive_value
end

y_true_p = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0]
y_true_m = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1,-1,-1,-1]
y_true_b = Vector{Bool}(y_true_p)
y_true_pf = Vector{Float64}(y_true_p)
y_true_mf = Vector{Float64}(y_true_m)
targets_p = (y_true_p, y_true_b, y_true_pf)
targets_m = (y_true_m, y_true_b, y_true_mf)

y_hat_p  = [1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0]
y_hat_m  = [1, 1,-1,-1, 1,-1, 1,-1,-1, 1,-1, 1,-1, 1,-1, 1,-1]
y_hat_b  = Vector{Bool}(y_hat_p)
y_hat_pf = Vector{Float64}(y_hat_p)
y_hat_mf = Vector{Float64}(y_hat_m)
outputs_p = (y_hat_p, y_hat_b, y_hat_pf, y_hat_b')
outputs_m = (y_hat_m, y_hat_b, y_hat_mf, y_hat_b')

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
            @test fun(false, false, FuzzyBinaryCompare()) === mask[1]
            @test fun(false, true , FuzzyBinaryCompare()) === mask[2]
            @test fun(true,  false, FuzzyBinaryCompare()) === mask[3]
            @test fun(true,  true , FuzzyBinaryCompare()) === mask[4]
        end
        @testset "Real parameters" begin
            for pos = (1, 2), neg = (0, -1, -2)
                for T1 = (Int32, Int64, Float32, Float64)
                    for T2 = (Int32, Int64, Float32, Float64)
                        @testset "$T1 against $T2" begin
                            @test fun(T1(neg), T2(neg), FuzzyBinaryCompare()) === mask[1]
                            @test fun(T1(neg), T2(pos), FuzzyBinaryCompare()) === mask[2]
                            @test fun(T1(pos), T2(neg), FuzzyBinaryCompare()) === mask[3]
                            @test fun(T1(pos), T2(pos), FuzzyBinaryCompare()) === mask[4]
                        end
                    end
                end
            end
        end
        @testset "mixed parameters" begin
            for pos = (1, true, 0.5, 1.), neg = (0, -1, -2, false, 0.)
                @testset "pos = $pos, neg = $neg" begin
                    @test fun(neg, neg, FuzzyBinaryCompare()) === mask[1]
                    @test fun(neg, pos, FuzzyBinaryCompare()) === mask[2]
                    @test fun(pos, neg, FuzzyBinaryCompare()) === mask[3]
                    @test fun(pos, pos, FuzzyBinaryCompare()) === mask[4]
                    if typeof(pos) <: Bool || typeof(neg) <: Bool
                        @test fun(neg, pos) === mask[2]
                        @test fun(pos, neg) === mask[3]
                    end
                end
            end
        end
    end
end

#=
@testset "multiclass sanity check" begin
    # We count positive strickly positive matches as positives
    @test true_positives([1,2,3,4], [1,3,2,4]) === 2
    @test true_negatives([1,2,3,4], [4,3,2,1]) === 0
    @test accuracy([1,2,3,4], [1,3,2,4]) === .5
    @test accuracy([:a,:b,:b,:c], [:c,:b,:a,:a]) === .25
end
=#
_accuracy_score_nonorm(t,o) = accuracy_score(t,o, normalize=false)
for (fun, ref) = ((true_positives,  5),
                  (true_negatives,  4),
                  (false_positives, 3),
                  (false_negatives, 5),
                  (prevalence,     10/17),
                  (condition_positive, 10),
                  (condition_negative, 7),
                  (predicted_condition_positive, 8),
                  (predicted_condition_negative, 9))
#                  (accuracy_score,  9/17),
#                  (_accuracy_score_nonorm, 9.),
#                  (positive_predictive_value, 5/8))
   @testset "$fun: check against known result" begin
        for (targets, outputs) = ((targets_p, outputs_p),
                                  (targets_m, outputs_m))
            for target in targets, output in outputs
                @testset "$(typeof(target)) against $(typeof(output))" begin
                    @test fun(target,output,FuzzyBinaryCompare())===ref
                end
            end
        end
    end
end
#=

# false_discovery_rate
@test false_discovery_rate(y_true, y_hat) == 0.5

# negative_predictive_value
@test negative_predictive_value(y_true, y_hat) == 0.5

# false_omission_rate
@test false_omission_rate(y_true, y_hat) == 0.5

# true_positive_rate
# sensitivity
# recall
@test positive_predictive_value(y_true, y_hat) == precision(y_true, y_hat) == 0.5

# false_positive_rate
@test false_positive_rate(y_true, y_hat) == 0.5

# false_negative_rate
@test false_negative_rate(y_true, y_hat) == 0.5

# true_negative_rate
# specificity
@test true_negative_rate(y_true, y_hat) == specificity(y_true, y_hat) == 0.5

# positive_likelihood_ratio
@test positive_likelihood_ratio(y_true, y_hat) == 1.0

# negative_likelihood_ratio
@test negative_likelihood_ratio(y_true, y_hat) == 1.0

# diagnostic_odds_ratio
@test diagnostic_odds_ratio(y_true, y_hat) == 1.0

# f1_score
@test f1_score(y_true, y_hat) == 0.5

# matthews_corrcoef
@test matthews_corrcoef(y_true, y_hat) == 0.0
=#
