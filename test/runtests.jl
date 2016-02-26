#
# Correctness Tests
#

using Base.Test
using Metrics

my_tests = [
    "biclustering.jl",
    "classification.jl",
    "clustering.jl",
    "multilabel_ranking.jl",
    "pairwise.jl",
    "regression.jl"
  ]

println("Running tests:")

for my_test in my_tests
    try
        include(my_test)
        println("\tPASSED: $(my_test)")
    catch e
        println("\tFAILED: $(my_test)")
    end
end
