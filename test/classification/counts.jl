@testset "test that synonyms work"  begin
    @test type_1_errors === false_positives
    @test type_2_errors === false_negatives
    @test misclassified === incorrectly_classified
end

# --------------------------------------------------------------------
# scalar

const fun_refs_scalar = [
    (true_positives,  (0,0,0,1)),
    (true_negatives,  (1,0,0,0)),
    (false_positives, (0,1,0,0)),
    (false_negatives, (0,0,1,0)),
    (condition_positive, (0,0,1,1)),
    (condition_negative, (1,1,0,0)),
    (predicted_condition_positive, (0,1,0,1)),
    (predicted_condition_negative, (1,0,1,0)),
    (correctly_classified,   (1,0,0,1)),
    (incorrectly_classified, (0,1,1,0)),
]

@testset "scalar fuzzy with/without encoding" begin
    # Test the simple non-array (i.e. scalar) methods that
    # expect scalar values (single observations).
    # The scalar methods require either an encoding or at least
    # one boolean parameter. The later results in FuzzyBinary.
    # Here we test all cases of scalar fuzzy matching.
    enc = LabelEnc.FuzzyBinary()
    for (fun, mask) in fun_refs_scalar
        @testset "$(fun): boolean parameters" begin
            @test @inferred(fun(false, false)) === mask[1]
            @test @inferred(fun(false, true )) === mask[2]
            @test @inferred(fun(true,  false)) === mask[3]
            @test @inferred(fun(true,  true )) === mask[4]
            @test @inferred(fun(false, false, enc)) === mask[1]
            @test @inferred(fun(false, true , enc)) === mask[2]
            @test @inferred(fun(true,  false, enc)) === mask[3]
            @test @inferred(fun(true,  true , enc)) === mask[4]
        end
        @testset "$(fun): numeric parameters" begin
            types = (Int32, Int64, Float32, Float64)
            for pos in (1, 2), neg in (0, -1, -2)
                for T1 in types, T2 in types
                    @testset "$T1 against $T2" begin
                        @test_throws ArgumentError fun(T1(neg), T2(pos))
                        @test @inferred(fun(T1(neg), T2(neg), enc)) === mask[1]
                        @test @inferred(fun(T1(neg), T2(pos), enc)) === mask[2]
                        @test @inferred(fun(T1(pos), T2(neg), enc)) === mask[3]
                        @test @inferred(fun(T1(pos), T2(pos), enc)) === mask[4]
                    end
                end
            end
        end
        @testset "$(fun): mixed parameters" begin
            for pos in (1, true, 0.5, 1.), neg in (0, -1, -2, false, 0.)
                @testset "pos = $pos, neg = $neg" begin
                    @test @inferred(fun(neg, neg, enc)) === mask[1]
                    @test @inferred(fun(neg, pos, enc)) === mask[2]
                    @test @inferred(fun(pos, neg, enc)) === mask[3]
                    @test @inferred(fun(pos, pos, enc)) === mask[4]
                    if typeof(pos) <: Bool || typeof(neg) <: Bool
                        @test @inferred(fun(neg, pos)) === mask[2]
                        @test @inferred(fun(pos, neg)) === mask[3]
                    end
                end
            end
        end
    end
end

@testset "scalar with encoding" begin
    for (fun, mask) in fun_refs_scalar
        @testset "$(fun): binary" begin
            enc = LabelEnc.ZeroOne()
            @test @inferred(fun(0,   0,   enc)) === mask[1]
            @test @inferred(fun(0,   0.2, enc)) === mask[1]
            @test @inferred(fun(0.0, 1.0, enc)) === mask[2]
            @test @inferred(fun(0.0, 0.6, enc)) === mask[2]
            @test @inferred(fun(1f0, 0,   enc)) === mask[3]
            @test @inferred(fun(0x1, 0x1, enc)) === mask[4]
            enc = LabelEnc.MarginBased()
            @test @inferred(fun(-1,    -1, enc)) === mask[1]
            @test @inferred(fun(-1,  -0.6, enc)) === mask[1]
            @test @inferred(fun(-1.0, 1.0, enc)) === mask[2]
            @test @inferred(fun(-1,   2.2, enc)) === mask[2]
            @test @inferred(fun(1f0,   -1, enc)) === mask[3]
            @test @inferred(fun(1,      5, enc)) === mask[4]
            enc = LabelEnc.TrueFalse()
            @test @inferred(fun(false, false, enc)) === mask[1]
            @test @inferred(fun(false, true , enc)) === mask[2]
            @test @inferred(fun(true,  false, enc)) === mask[3]
            @test @inferred(fun(true,  true , enc)) === mask[4]
            enc = LabelEnc.Indices(2)
            @test @inferred(fun(2, 2, enc)) === mask[1]
            @test @inferred(fun(2., 2, enc)) === mask[1]
            @test @inferred(fun(0x2, 2f0, enc)) === mask[1]
            @test @inferred(fun(2, 1, enc)) === mask[2]
            @test @inferred(fun(1, 2, enc)) === mask[3]
            @test @inferred(fun(1, 1, enc)) === mask[4]
            enc = LabelEnc.NativeLabels([:pos, :neg])
            @test_throws ArgumentError fun(:neg, :pos)
            @test @inferred(fun(:neg, :neg, enc)) === mask[1]
            @test @inferred(fun(:neg, :pos, enc)) === mask[2]
            @test @inferred(fun(:pos, :neg, enc)) === mask[3]
            @test @inferred(fun(:pos, :pos, enc)) === mask[4]
            @test fun(:neg, :neg, [:pos, :neg]) === mask[1]
            @test fun(:neg, :pos, [:pos, :neg]) === mask[2]
            @test fun(:pos, :neg, [:pos, :neg]) === mask[3]
            @test fun(:pos, :pos, [:pos, :neg]) === mask[4]
            enc = LabelEnc.OneVsRest("pos")
            @test_throws ArgumentError fun("neg", "pos")
            @test @inferred(fun("foo", "bar", enc)) === mask[1]
            @test @inferred(fun("baz", "pos", enc)) === mask[2]
            @test @inferred(fun("pos", "foo", enc)) === mask[3]
            @test @inferred(fun("pos", "pos", enc)) === mask[4]
            enc = LabelEnc.OneOfK(2)
            @test_throws ArgumentError fun([1,0], 1)
            @test_throws ArgumentError fun(1, [0,1])
            @test_throws ArgumentError fun(1, 1, enc)
            @test_throws ArgumentError fun(1, [0,1], enc)
            @test_throws ArgumentError fun([0,1], 1, enc)
            @test_throws ArgumentError fun([0,1], [0,1], enc)
            @test_throws ArgumentError fun([0 1], [0 1], enc)
        end
        @testset "$(fun): multiclass" begin
            enc = LabelEnc.Indices(3)
            @test @inferred(fun(1, 2, enc)) == Dict{Int,Int}(
                1 => mask[3],
                2 => mask[2],
                3 => mask[1],
            )
            @test @inferred(fun(2, 2, enc)) == Dict{Int,Int}(
                1 => mask[1],
                2 => mask[4],
                3 => mask[1],
            )
            @test @inferred(fun(3, 2, enc)) == Dict{Int,Int}(
                1 => mask[1],
                2 => mask[2],
                3 => mask[3],
            )
            enc = LabelEnc.NativeLabels([:a, :b, :c])
            @test @inferred(fun(:a, :b, enc)) == Dict{Symbol,Int}(
                :a => mask[3],
                :b => mask[2],
                :c => mask[1],
            )
            @test @inferred(fun(:b, :b, enc)) == Dict{Symbol,Int}(
                :a => mask[1],
                :b => mask[4],
                :c => mask[1],
            )
            @test @inferred(fun(:c, :b, enc)) == Dict{Symbol,Int}(
                :a => mask[1],
                :b => mask[2],
                :c => mask[3],
            )
            @test fun(:a, :b, [:a, :b, :c]) == Dict{Symbol,Int}(
                :a => mask[3],
                :b => mask[2],
                :c => mask[1],
            )
            @test fun(:b, :b, [:a, :b, :c]) == Dict{Symbol,Int}(
                :a => mask[1],
                :b => mask[4],
                :c => mask[1],
            )
            @test fun(:c, :b, [:a, :b, :c]) == Dict{Symbol,Int}(
                :a => mask[1],
                :b => mask[2],
                :c => mask[3],
            )
            enc = LabelEnc.OneOfK(3)
            @test_throws ArgumentError fun(1, 1, enc)
            @test_throws ArgumentError fun(1, [0,1], enc)
            @test_throws ArgumentError fun([0,1], 1, enc)
            @test_throws ArgumentError fun([0,1], [0,1], enc)
            @test_throws ArgumentError fun([0 1], [0 1], enc)
        end
    end
end

# --------------------------------------------------------------------
# arrays

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

const fun_refs_arrays = [
    (true_positives,  5),
    (true_negatives,  4),
    (false_positives, 3),
    (false_negatives, 5),
    (condition_positive, 10),
    (condition_negative, 7),
    (predicted_condition_positive, 8),
    (predicted_condition_negative, 9),
    (correctly_classified, 9),
    (incorrectly_classified, 8),
]

@testset "arrays fuzzy with/without encoding" begin
    targets = [y_true_p, y_true_m, y_true_b, y_true_pf, y_true_mf]
    outputs = [y_hat_p, y_hat_m, y_hat_b, y_hat_pf, y_hat_mf, y_hat_b']
    for (fun, ref) in fun_refs_arrays
        @testset "$fun: binary" begin
            for target in targets, output in outputs
                @testset "$(typeof(target)) against $(typeof(output))" begin
                    @test @inferred(fun(target, output, LabelEnc.FuzzyBinary())) === ref
                    if eltype(target) <: Bool || eltype(output) <: Bool
                        @test @inferred(fun(target, output)) === ref
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
    for (fun, ref) in fun_refs_arrays
        @testset "$fun: binary" begin
            for (target, output, enc) in binary_data
                @testset "$(eltype(target)) against $(eltype(output)) (enc: $(enc))" begin
                    @test @inferred(fun(target, output, enc)) === ref
                    if nlabel(target) == 2
                        @test fun(target, output) === ref
                    end
                end
            end
            # this is not type stable (number of labels not static)
            @test fun(y_true_sym, y_hat_sym, [:pos, :neg]) === ref
        end
        @testset "$fun: multiclass" begin
            for (target, output, enc) in multiclass_data
                @testset "$(eltype(target)) against $(eltype(output)) (enc: $(enc))" begin
                    res = Dict(map(label(enc)) do l
                        l => fun(target, output, LabelEnc.OneVsRest(l))
                    end)
                    @test @inferred(fun(target, output, enc)) == res
                    @test fun(target, output) == res
                end
            end
        end
    end
end
