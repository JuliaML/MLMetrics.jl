module Metrics

##############################################################################
##
## Dependencies
##
##############################################################################



##############################################################################
##
## Exported methods and types (in addition to everything reexported above)
##
##############################################################################

export @~,
    squared_error,
    sum_squared_error,
    mean_squared_error

##############################################################################
##
## Load files
##
##############################################################################

for filename in [
        ("regression_metrics.jl"),
        ("classification_metrics.jl")
    ]

    include(filename)
end

end # module Metrics
