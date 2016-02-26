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
    absolute_error,
    percent_error,
    log_error,
    squared_error,
    squared_log_error,
    absolute_percent_error,
    mean_error,
    mean_absolute_error,
    median_absolute_error,
    mean_percent_error,
    median_percent_error,
    mean_squared_error,
    median_squared_error,
    sum_squared_error,
    mean_squared_log_error,
    mean_absolute_percent_error,
    median_absolute_percent_error,
    symmetric_mean_absolute_percent_error,
    symmetric_median_absolute_percent_error,
    mean_absolute_scaled_error,
    total_variance_score,
    explained_variance_score,
    unexplained_variance_score,
    r2_score

##############################################################################
##
## Load files
##
##############################################################################

for filename in [
    "biclustering.jl",
    "classification.jl",
    "clustering.jl",
    "multilabel_ranking.jl",
    "pairwise.jl",
    "regression.jl"
    ]

    include(filename)
end

end # module Metrics
