module MLMetrics_Test
using MLLabelUtils
using Test, ReferenceTests

# check for ambiguities
refambs = detect_ambiguities(Base, Core)
using MLMetrics
ambs = detect_ambiguities(MLMetrics, Base, Core)
@test Set(setdiff(ambs, refambs)) == Set{Tuple{Method,Method}}()

classification_tests = [
    "counts.jl",
#   "roc.jl",
#   "fractions.jl",
]

@testset "classification" begin
    for test in classification_tests
        @testset "$test" begin
            include(joinpath("classification", test))
        end
    end
end

regression_tests = [
    "regression.jl"
]

@testset "regression" begin
    for test in regression_tests
        @testset "$test" begin
            include(joinpath("regression", test))
        end
    end
end
end
