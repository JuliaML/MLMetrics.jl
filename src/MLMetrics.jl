__precompile__()
module MLMetrics

using LearnBase
using MLLabelUtils
using MLLabelUtils: LabelEncoding, BinaryLabelEncoding
using LossFunctions
using LossFunctions: AverageMode, @_dimcheck
using UnicodePlots

export

    AvgMode,
    LabelEnc,

    # binary only
    true_positives,
    true_negatives,
    false_positives, type_1_errors,
    false_negatives, type_2_errors,
    condition_positive,
    prevalence,
    condition_negative,
    predicted_condition_positive,
    predicted_condition_negative,

    # multiclass support
    positive_predictive_value, precision_score,
    negative_predictive_value,
    false_discovery_rate,
    false_omission_rate,
    true_positive_rate, sensitivity, recall,
    false_positive_rate,
    false_negative_rate,
    true_negative_rate, specificity,
    accuracy,
    f_score, f1_score,

    # roc
    confusions,
    confusions_at_sensitivity,
    roc,
    specificity_at_sensitivity,
    precision_at_sensitivity,
    accuracy_at_sensitivity,
    auc, auc_from_rates,

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
    positive_likelihood_ratio,
    negative_likelihood_ratio,
    diagnostic_odds_ratio,
    matthews_corrcoef,
    mutual_info_score,
    normalized_mutual_info_score,
    adjusted_mutual_info_score,
    adjusted_rand_score,
    homogeneity_score,
    completeness_score,
    v_measure_score

include("upstream.jl")
include("classification/utils.jl")
include("classification/binary.jl")
include("classification/fraction.jl")
include("classification/multiclass.jl")
include("classification/roc.jl")
include("regression.jl")
include("clustering.jl")

end # module MLMetrics
