module MLMetrics_Test
using MLLabelUtils
using LossFunctions
using MLMetrics
using Test, ReferenceTests

tests = [
    "classification.jl",
    "regression.jl"
]

for test in tests
    @testset "$test" begin
        include(test)
    end
end
end
