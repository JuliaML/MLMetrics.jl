using MLLabelUtils: LabelEnc.FuzzyBinary

@testset "FuzzyBinary matching" begin
    for (fun, mask) in ((true_positives,  (0,0,0,1)),
                        (true_negatives,  (1,0,0,0)),
                        (false_positives, (0,1,0,0)),
                        (false_negatives, (0,0,1,0)),
                        (condition_positive, (0,0,1,1)),
                        (condition_negative, (1,1,0,0)),
                        (predicted_condition_positive, (0,1,0,1)),
                        (predicted_condition_negative, (1,0,1,0)))
        @testset "$(fun): boolean parameters" begin
            @test @inferred(fun(false, false)) === mask[1]
            @test @inferred(fun(false, true )) === mask[2]
            @test @inferred(fun(true,  false)) === mask[3]
            @test @inferred(fun(true,  true )) === mask[4]
            @test @inferred(fun(false, false, FuzzyBinary())) === mask[1]
            @test @inferred(fun(false, true , FuzzyBinary())) === mask[2]
            @test @inferred(fun(true,  false, FuzzyBinary())) === mask[3]
            @test @inferred(fun(true,  true , FuzzyBinary())) === mask[4]
        end
        @testset "$(fun): numeric parameters" begin
            types = (Int32, Int64, Float32, Float64)
            for pos in (1, 2), neg in (0, -1, -2)
                for T1 in types, T2 in types
                    @testset "$T1 against $T2" begin
                        @test @inferred(fun(T1(neg), T2(neg), FuzzyBinary())) === mask[1]
                        @test @inferred(fun(T1(neg), T2(pos), FuzzyBinary())) === mask[2]
                        @test @inferred(fun(T1(pos), T2(neg), FuzzyBinary())) === mask[3]
                        @test @inferred(fun(T1(pos), T2(pos), FuzzyBinary())) === mask[4]
                    end
                end
            end
        end
        @testset "$(fun): mixed parameters" begin
            for pos in (1, true, 0.5, 1.), neg in (0, -1, -2, false, 0.)
                @testset "pos = $pos, neg = $neg" begin
                    @test @inferred(fun(neg, neg, FuzzyBinary())) === mask[1]
                    @test @inferred(fun(neg, pos, FuzzyBinary())) === mask[2]
                    @test @inferred(fun(pos, neg, FuzzyBinary())) === mask[3]
                    @test @inferred(fun(pos, pos, FuzzyBinary())) === mask[4]
                    if typeof(pos) <: Bool || typeof(neg) <: Bool
                        @test @inferred(fun(neg, pos)) === mask[2]
                        @test @inferred(fun(pos, neg)) === mask[3]
                    end
                end
            end
        end
    end
end

# symbols
# onevsrest
