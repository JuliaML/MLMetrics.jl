using MLMetrics
using MLMetrics.CompareMode

using Base.Test

tests = [
    "classification.jl",
    "regression.jl"
]

for test in tests
    @testset "$test" begin
        include(test)
    end
end

