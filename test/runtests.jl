#
# Correctness Tests
#

using Base.Test
using Metrics

my_tests = ["regression_metrics.jl",
            "classification_metrics.jl"]

println("Running tests:")

for my_test in my_tests
    try
        include(my_test)
        println("\t\033[1m\033[32mPASSED\033[0m: $(my_test)")
    catch e
        println("\t\033[1m\033[31mFAILED\033[0m: $(my_test)")
    end
end
