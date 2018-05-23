module MLMetrics

export

    CompareMode,
    AverageMode,

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
    r2_score,
    true_positives,
    true_negatives,
    false_positives,
    type_1_errors,
    false_negatives,
    type_2_errors,
    condition_positive,
    condition_negative,
    predicted_condition_positive,
    predicted_condition_negative,
    accuracy_score,
    accuracy,
    prevalence,
    positive_predictive_value,
    precision_score,
    false_discovery_rate,
    negative_predictive_value,
    false_omission_rate,
    true_positive_rate,
    sensitivity,
    recall,
    false_positive_rate,
    false_negative_rate,
    true_negative_rate,
    specificity,
    positive_likelihood_ratio,
    negative_likelihood_ratio,
    diagnostic_odds_ratio,
    f1_score,
    matthews_corrcoef,
    mutual_info_score,
    normalized_mutual_info_score,
    adjusted_mutual_info_score,
    homogeneity_score,
    completeness_score,
    v_measure_score

include("common.jl")
include("averagemode.jl")
include("classification/comparemode.jl")

#using MLMetrics.AverageMode
using MLMetrics.AverageMode.AvgMode

using MLMetrics.CompareMode
using MLMetrics.CompareMode: AbstractBinary, AbstractMultiClass, FuzzyMultiClass

include("classification/binary.jl")
include("classification/multiclass.jl")
include("regression.jl")
include("clustering.jl")

end # module MLMetrics
