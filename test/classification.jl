using Base.Test
using Metrics

y_true = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
y_pred = [1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1]

# total_population
@test total_population(y_true, y_pred) == 16

# true_positive
@test true_positive(y_true, y_pred) == 4

# true_negative
@test true_negative(y_true, y_pred) == 4

# false_positive
# false_negative
# condition_positive
# condition_negative
# predicted_condition_positive
# predicted_condition_negative
# accuracy_score
# accuracy
# prevalence
# positive_predictive_value
# precision
# false_discovery_rate
# negative_predictive_value
# false_omission_rate
# true_positive_rate
# sensitivity
# recall
# false_positive_rate
# false_negative_rate
# true_negative_rate
# specificity
# positive_likelihood_ratio
# negative_likelihood_ratio
# diagnostic_odds_ratio
# f1_score
# matthews_corrcoef
