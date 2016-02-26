#
# Optional time-consuming Benchmarks
#

using Metrics
using Benchmark

benchmarks = [
  "regression.jl",
  "classification.jl"
  ]

# TODO: Print summary to stdout_stream, while printing results
#       to file with appends.
#println("Running benchmarks:")

for benchmark in benchmarks
#    println(" * $(benchmark)")
    include(benchmark)
end
