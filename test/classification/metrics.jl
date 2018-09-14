@testset "test that synonyms work" begin
    @test precision_score === positive_predictive_value
    @test sensitivity === true_positive_rate
    @test recall === true_positive_rate
    @test specificity === true_negative_rate
end

# --------------------------------------------------------------------

y_true_p = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0]
y_true_m = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1,-1,-1,-1]
y_true_i = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2]
y_true_b = Vector{Bool}(y_true_p)
y_true_pf = Vector{Float64}(y_true_p)
y_true_mf = Vector{Float64}(y_true_m)
y_true_sym = convertlabel([:pos,:neg], y_true_p, LabelEnc.ZeroOne())
y_true_sym2 = [:a, :a, :a, :a, :a, :a, :a, :a, :a, :a, :b, :b, :b, :b, :c, :c, :c]
y_true_c = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3]

y_hat_p  = [1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0]
y_hat_m  = [1, 1,-1,-1, 1,-1, 1,-1,-1, 1,-1, 1,-1, 1,-1, 1,-1]
y_hat_i  = [1, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 2, 1, 2]
y_hat_b  = Vector{Bool}(y_hat_p)
y_hat_pf = Vector{Float64}(y_hat_p)
y_hat_mf = Vector{Float64}(y_hat_m)
y_hat_sym  = convertlabel([:pos,:neg], y_hat_p,  LabelEnc.ZeroOne())
y_hat_sym2  = [:a, :a, :b, :c, :a, :b, :a, :c, :c, :a, :c, :a, :c, :a, :b, :a, :c]
y_hat_c  = [1, 1, 2, 3, 1, 2, 1, 3, 3, 1, 3, 1, 3, 1, 2, 1, 3]
# f1 macro: 0.25925925925925924
# f1 micro: 0.35294117647058826
# f1 none: array([0.55555556, 0., 0.22222222])

_accuracy_nonorm(args...) = accuracy(args...; normalize=false)
# (fun, binary, micro, macro)
const fun_refs = [
    (prevalence, 10/17, nothing, nothing),
    (f_score, 0.5555555555555556, 0.35294117647058826, 0.25925925925925924),
    (f1_score, 0.5555555555555556, 0.35294117647058826, 0.25925925925925924),
    (accuracy, 9/17, nothing, nothing),
    (_accuracy_nonorm, 9., nothing, nothing),
    (positive_predictive_value, 5/8, 0.35294117647058826, 0.2638888888888889),
    (false_discovery_rate, 3/8, nothing, nothing),
    (negative_predictive_value, 4/9, nothing, nothing),
    (false_omission_rate, 5/9, nothing, nothing),
    (true_positive_rate, 5/10, 0.35294117647058826, 0.27777777777777773),
    (false_positive_rate, 3/7, nothing, nothing),
    (false_negative_rate, 5/10, nothing, nothing),
    (true_negative_rate, 4/7, nothing, nothing),
    (positive_likelihood_ratio, 5/10 * 7/3, nothing, nothing),
    (negative_likelihood_ratio, 5/10 * 7/4, nothing, nothing),
    (diagnostic_odds_ratio, (5/10 * 7/3) / (5/10 * 7/4), nothing, nothing)
]

@testset "fuzzy with/without encoding" begin
    targets = [y_true_p, y_true_m, y_true_b, y_true_pf, y_true_mf]
    outputs = [y_hat_p, y_hat_m, y_hat_b, y_hat_pf, y_hat_mf, y_hat_b']
    for (fun, ref_binary, ref_micro, ref_macro) in fun_refs
        @testset "$fun: binary" begin
            for target in targets, output in outputs
                @testset "$(typeof(target)) against $(typeof(output))" begin
                    @test @inferred(fun(target, output, LabelEnc.FuzzyBinary())) === ref_binary
                    if eltype(target) <: Bool || eltype(output) <: Bool
                        @test @inferred(fun(target, output)) === ref_binary
                    end
                end
            end
        end
    end
end

@testset "arrays with/without encoding" begin
    binary_data = [
        (y_true_p,    y_hat_p,    LabelEnc.ZeroOne()),
        (y_true_p,    y_hat_pf,   LabelEnc.ZeroOne()),
        (y_true_pf,   y_hat_p,    LabelEnc.ZeroOne()),
        (y_true_pf,   y_hat_pf,   LabelEnc.ZeroOne()),
        (y_true_m,    y_hat_m,    LabelEnc.MarginBased()),
        (y_true_m,    y_hat_mf,   LabelEnc.MarginBased()),
        (y_true_mf,   y_hat_m,    LabelEnc.MarginBased()),
        (y_true_mf,   y_hat_mf,   LabelEnc.MarginBased()),
        (y_true_i,    y_hat_i,    LabelEnc.Indices(2)),
        (y_true_b,    y_hat_b,    LabelEnc.TrueFalse()),
        (y_true_sym,  y_hat_sym,  LabelEnc.NativeLabels([:pos,:neg])),
        (y_true_sym,  y_hat_sym,  LabelEnc.OneVsRest(:pos)),
        (y_true_sym2, y_hat_sym2, LabelEnc.OneVsRest(:a)),
    ]
    multiclass_data = [
        (y_true_sym2,    y_hat_sym2,  LabelEnc.NativeLabels([:a,:b,:c])),
        (y_true_c,          y_hat_c,  LabelEnc.Indices(3)),
        (Int32.(y_true_c),  y_hat_c,  LabelEnc.Indices(3)),
        (y_true_c, Float32.(y_hat_c), LabelEnc.Indices(3)),
    ]
    for (fun, ref_binary, ref_micro, ref_macro) in fun_refs
        @testset "$fun: binary" begin
            for (target, output, enc) in binary_data
                @testset "$(eltype(target)) against $(eltype(output)) (enc: $(typeof(enc)))" begin
                    @test @inferred(fun(target, output, enc)) === ref_binary
                    if nlabel(target) == 2
                        @test fun(target, output) === ref_binary
                    end
                end
            end
            # this is not type stable (number of labels not static)
            @test fun(y_true_sym, y_hat_sym, [:pos, :neg]) === ref_binary
        end
        @testset "$fun: multiclass" begin
            for (target, output, enc) in multiclass_data
                @testset "$(eltype(target)) against $(eltype(output)) (enc: $(typeof(enc)))" begin
                    if fun == _accuracy_nonorm
                        @test @inferred(fun(target, output, enc)) == 6
                        @test fun(target, output, label(enc)) == 6
                        @test fun(target, output) == 6
                    elseif fun == accuracy
                        @test @inferred(fun(target, output, enc)) == 6/17
                        @test fun(target, output, label(enc)) == 6/17
                        @test fun(target, output) == 6/17
                        @test fun(target, output, normalize=true) == 6/17
                    else
                        res = Dict(map(label(enc)) do l
                            l => fun(target, output, LabelEnc.OneVsRest(l))
                        end)
                        @test @inferred(fun(target, output, enc)) == res
                        @test @inferred(fun(target, output, enc, AvgMode.None())) == res
                        @test fun(target, output, enc, avgmode=:none) == res
                        @test fun(target, output) == res
                        @test fun(target, output, avgmode=:none) == res
                        if ref_micro != nothing
                            @test @inferred(fun(target, output, enc, AvgMode.Micro())) ≈ ref_micro
                            @test fun(target, output, label(enc), AvgMode.Micro()) ≈ ref_micro
                            @test fun(target, output, AvgMode.Micro()) ≈ ref_micro
                            @test fun(target, output, enc, avgmode=:micro) ≈ ref_micro
                            @test fun(target, output, label(enc), avgmode=:micro) ≈ ref_micro
                            @test fun(target, output, avgmode=:micro) ≈ ref_micro
                        end
                        if ref_macro != nothing
                            @test @inferred(fun(target, output, enc, AvgMode.Macro())) ≈ ref_macro
                            @test fun(target, output, label(enc), AvgMode.Macro()) ≈ ref_macro
                            @test fun(target, output, AvgMode.Macro()) ≈ ref_macro
                            @test fun(target, output, enc, avgmode=:macro) ≈ ref_macro
                            @test fun(target, output, label(enc), avgmode=:macro) ≈ ref_macro
                            @test fun(target, output, avgmode=:macro) ≈ ref_macro
                        end
                    end
                end
            end
        end
    end
end

@testset "f_score: extra tests for beta" begin
    y_true = [0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2]
    y_hat  = [0, 1, 0, 1, 0, 1, 0, 1, 2, 2, 1]
    @test f_score(y_true, y_hat) == Dict{Int, Float64}(0 => 0.5714285714285715, 1 => 0.6, 2=>0.8)
    @test f_score(y_true, y_hat, 2.0) == Dict(0 => 0.35714285714285715, 2 => 0.5, 1 => 0.375)
    @test f_score(y_true, y_hat, unique(y_true), 2.0) == Dict(0 => 0.35714285714285715, 2 => 0.5, 1 => 0.375)
    @test f_score(y_true, y_hat, beta=2.0) == Dict(0 => 0.35714285714285715, 2 => 0.5, 1 => 0.375)
    @test f_score(y_true, y_hat, avgmode=:none, beta=2.0) == Dict(0 => 0.35714285714285715, 2 => 0.5, 1 => 0.375)
    @test f_score(y_true, y_hat, LabelEnc.NativeLabels(unique(y_true))) == Dict{Int, Float64}(0 => 0.5714285714285715, 1 => 0.6, 2=>0.8)
    @test f_score(y_true, y_hat, LabelEnc.NativeLabels(unique(y_true)), 1) == Dict{Int, Float64}(0 => 0.5714285714285715, 1 => 0.6, 2=>0.8)
    @test f_score(y_true, y_hat, AvgMode.Macro()) ≈ 0.6571428571428571
    @test f_score(y_true, y_hat, AvgMode.Macro(), 1) ≈ 0.6571428571428571
    @test f_score(y_true, y_hat, AvgMode.Micro()) ≈ 0.6363636363636364
    @test f_score(y_true, y_hat, avgmode=:micro) ≈ 0.6363636363636364
    @test f_score(y_true, y_hat, avgmode=:micro, beta=1) ≈ 0.6363636363636364
    @test f_score(y_true, y_hat, LabelEnc.NativeLabels(unique(y_true)), AvgMode.Micro()) ≈ 0.6363636363636364
    @test f_score(y_true, y_hat, LabelEnc.NativeLabels(unique(y_true)), AvgMode.Micro(), 1) ≈ 0.6363636363636364
    @test f_score(y_true, y_hat, LabelEnc.NativeLabels(unique(y_true)); avgmode=:micro, beta=1) ≈ 0.6363636363636364
    @test f_score(y_true, y_hat, unique(y_true); avgmode=:micro, beta=1) ≈ 0.6363636363636364
    @test sort(collect(keys(f_score(y_true, y_hat, [0, 1, 2])))) == [0, 1, 2]
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
#=
# matthews_corrcoef
@test matthews_corrcoef(y_true, y_hat) == 0.0
=#
