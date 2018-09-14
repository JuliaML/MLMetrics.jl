module MLMetrics_Test
using MLLabelUtils
using Test, ReferenceTests

# check for ambiguities
refambs = detect_ambiguities(Base, Core)
using MLMetrics
ambs = detect_ambiguities(MLMetrics, Base, Core)
@test Set(setdiff(ambs, refambs)) == Set{Tuple{Method,Method}}()

classification_tests = joinpath.("classification", [
    "counts.jl",
    "metrics.jl",
    "roc.jl",
])

for test in classification_tests
    @testset "$test" begin
        include(test)
    end
end

regression_tests = joinpath.("regression", [
    "regression.jl"
])

for test in regression_tests
    @testset "$test" begin
        include(test)
    end
end
end
