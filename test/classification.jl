using Base.Test
using MachineLearningMetrics

y_true = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
y_pred = [1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1]

# total_population
@test total_population(y_true, y_pred) == 16

# true_positive
@test true_positive(y_true, y_pred) == 4

# true_negative
@test true_negative(y_true, y_pred) == 4

# false_positive
@test false_positive(y_true, y_pred) == 4

# false_negative
@test false_negative(y_true, y_pred) == 4

# condition_positive
@test condition_positive(y_true, y_pred) == 8

# condition_negative
@test condition_negative(y_true, y_pred) == 8

# predicted_condition_positive
@test predicted_condition_positive(y_true, y_pred) == 8

# predicted_condition_negative
@test predicted_condition_negative(y_true, y_pred) == 8

# accuracy_score
# accuracy
@test accuracy_score(y_true, y_pred) == accuracy(y_true, y_pred) == 0.5

# prevalence
@test accuracy(y_true, y_pred) == 0.5

# positive_predictive_value
# precision
@test positive_predictive_value(y_true, y_pred) == precision(y_true, y_pred) == 0.5

# false_discovery_rate
@test false_discovery_rate(y_true, y_pred) == 0.5

# negative_predictive_value
@test negative_predictive_value(y_true, y_pred) == 0.5

# false_omission_rate
@test false_omission_rate(y_true, y_pred) == 0.5

# true_positive_rate
# sensitivity
# recall
@test positive_predictive_value(y_true, y_pred) == precision(y_true, y_pred) == 0.5

# false_positive_rate
@test false_positive_rate(y_true, y_pred) == 0.5

# false_negative_rate
@test false_negative_rate(y_true, y_pred) == 0.5

# true_negative_rate
# specificity
@test true_negative_rate(y_true, y_pred) == specificity(y_true, y_pred) == 0.5

# positive_likelihood_ratio
@test positive_likelihood_ratio(y_true, y_pred) == 1.0

# negative_likelihood_ratio
@test negative_likelihood_ratio(y_true, y_pred) == 1.0

# diagnostic_odds_ratio
@test diagnostic_odds_ratio(y_true, y_pred) == 1.0

# f1_score
@test f1_score(y_true, y_pred) == 0.5

# matthews_corrcoef
@test matthews_corrcoef(y_true, y_pred) == 0.0
