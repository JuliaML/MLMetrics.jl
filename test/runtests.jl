using MLMetrics
using MLLabelUtils
using LossFunctions
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

