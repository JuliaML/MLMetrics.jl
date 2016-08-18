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

for (fun, mask, ref) = ((true_positives,  (0,0,0,1), 5),
                        (true_negatives,  (1,0,0,0), 4),
                        (false_positives, (0,1,0,0), 3),
                        (false_negatives, (0,0,1,0), 5))
    @testset "$fun" begin
        @testset "Bool parameters" begin
            @test fun(false, false) === mask[1]
            @test fun(false, true ) === mask[2]
            @test fun(true,  false) === mask[3]
            @test fun(true,  true ) === mask[4]
        end
        @testset "Real parameters" begin
            for pos = (1, 2), neg = (0, -1, -2)
                for T1 = (Int32, Int64, Float32, Float64)
                    for T2 = (Int32, Int64, Float32, Float64)
                        @testset "$T1 against $T2" begin
                            @test fun(T1(neg), T2(neg)) === mask[1]
                            @test fun(T1(neg), T2(pos)) === mask[2]
                            @test fun(T1(pos), T2(neg)) === mask[3]
                            @test fun(T1(pos), T2(pos)) === mask[4]
                        end
                    end
                end
            end
        end
        @testset "mixed parameters" begin
            for pos = (1, true, 1.), neg = (0, -1, -2, false, 0.)
                @testset "pos = $pos, neg = $neg" begin
                    @test fun(neg, neg) === mask[1]
                    @test fun(neg, pos) === mask[2]
                    @test fun(pos, neg) === mask[3]
                    @test fun(pos, pos) === mask[4]
                end
            end
        end
        @testset "check against known reference data" begin
            for (targets, outputs) = ((targets_p, outputs_p),
                                      (targets_m, outputs_m))
                for target in targets, output in outputs
                    @testset "$(target) against $(output)" begin
                        @test fun(target, output) === ref
                    end
                end
            end
        end
    end
end

#=
# condition_positive
@test condition_positive(y_true, y_hat) == 8

# condition_negative
@test condition_negative(y_true, y_hat) == 8

# predicted_condition_positive
@test predicted_condition_positive(y_true, y_hat) == 8

# predicted_condition_negative
@test predicted_condition_negative(y_true, y_hat) == 8

# accuracy_score
# accuracy
@test accuracy_score(y_true, y_hat) == accuracy(y_true, y_hat) == 0.5

# prevalence
@test accuracy(y_true, y_hat) == 0.5

# positive_predictive_value
# precision
@test positive_predictive_value(y_true, y_hat) == precision(y_true, y_hat) == 0.5

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
