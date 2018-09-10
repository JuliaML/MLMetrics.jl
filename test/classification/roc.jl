
@testset "BinaryConfusionMatrix" begin
    cm = @inferred MLMetrics.BinaryConfusionMatrix()
    cm isa MLMetrics.BinaryConfusionMatrix{Int}
    cm == [0 0; 0 0]
    cm = @inferred MLMetrics.BinaryConfusionMatrix{Int32}()
    cm isa MLMetrics.BinaryConfusionMatrix{Int32}
    cm == Int32[0 0; 0 0]
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
    y_true_p = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0]
    y_true_m = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1,-1,-1,-1]
    y_true_b = Vector{Bool}(y_true_p)
    y_true_pf = Vector{Float64}(y_true_p)
    y_true_mf = Vector{Float64}(y_true_m)
    targets = (y_true_p, y_true_m, y_true_b, y_true_pf, y_true_mf)
    y_hat_p  = [1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0]
    y_hat_roc = [.9, 1, 0, .4, .5, .4, .7, .1, .15, .95, .3, .6, .2, .9, .05, .8, .48]
    y_true_symb = convertlabel([:pos,:neg], y_true_p, LabelEnc.ZeroOne())
    y_hat_symb  = convertlabel([:pos,:neg], y_hat_p,  LabelEnc.ZeroOne())
    y_true_roc2 = [1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0]
    y_hat_roc2 = [20, 19, 18, 17, 16, 15, 14, 13, 11.5, 11.5, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1] ./ 20
    @testset "explicit number of thresholds" begin
        r = @inferred roc(y_true_symb, y_hat_roc, 10)
        @test length(r) == 10
    end
    @testset "constructor and show" begin
        r = @inferred roc(y_true_symb, y_hat_roc)
        @test r isa MLMetrics.ROCCurve
        @test r isa AbstractVector
        @test length(r) == 100
        @test_reference "references/ROCCurve1.txt" @io2str show(::IO, r)
        @test_reference "references/ROCCurve2.txt" @io2str show(::IO, MIME"text/plain"(), r)
        r = @inferred roc(y_true_roc2, y_hat_roc2, collect(r.thresholds))
        @test_reference "references/ROCCurve3.txt" @io2str show(::IO, MIME"text/plain"(), r)
    end
    @testset "getindex and setindex!" begin
        r = @inferred roc(y_true_symb, y_hat_roc)
        @test @inferred(r[1]) == (1.0, [1 9; 0 7])
        @test r[1][2] isa MLMetrics.BinaryConfusionMatrix
        @test precision_score(r) == precision_score.(r.confusions)
        # setindex
        r = @inferred roc(y_true_symb, y_hat_roc, collect(r.thresholds))
        r[1] = MLMetrics.BinaryConfusionMatrix([1 2; 3 4])
        @test r[1] == (1.0, [1 2; 3 4])
        r[1] = (1.1, MLMetrics.BinaryConfusionMatrix([5 6; 7 8]))
        @test r[1] == (1.1, [5 6; 7 8])
    end
    @testset "compare against pROC" begin
        # pROC says 0.5357
        r = @inferred roc(y_true_symb, y_hat_roc)
        @test @inferred(auc(r)) ≈ 0.5357142857142858
        # pROC says 0.825
        r = @inferred roc(y_true_roc2, y_hat_roc2)
        @test @inferred(auc(r)) ≈ 0.825
        @test @inferred(auc(y_true_roc2, y_hat_roc2)) ≈ 0.825
    end
    @testset "different array eltypes" begin
        r = @inferred roc(y_true_symb, y_hat_roc)
        for target in targets
            @test @inferred(roc(target, y_hat_roc)) == r
            @test @inferred(roc(target, y_hat_roc, LabelEnc.ZeroOne())) == r
            @test @inferred(roc(target, y_hat_roc, 100)) == r
            @test @inferred(roc(target, y_hat_roc, 100, LabelEnc.ZeroOne())) == r
        end
    end
    r = @inferred roc(y_true_roc2, y_hat_roc2)
    r2 = r + r
    @test r2[10][1] == r[10][1]
    @test r2[10][2] == r[10][2] + r[10][2]
    @test_throws ArgumentError precision_at_sensitivity(r, 1.1)
    @test @inferred(precision_at_sensitivity(r, 0)) == 1
    @test @inferred(precision_at_sensitivity(r, 1)) == 0.625
    @test @inferred(precision_at_sensitivity(r, .9)) ≈ 0.6923076923076923
    @test @inferred(specificity_at_sensitivity(r, 0)) == 1
    @test @inferred(specificity_at_sensitivity(r, 1)) == 0.4
    @test @inferred(accuracy_at_sensitivity(r, 0)) == 0.55
    @test @inferred(accuracy_at_sensitivity(r, 1.)) == 0.7
end
