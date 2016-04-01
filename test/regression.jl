using Base.Test
using MachineLearningMetrics

y_true = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
y_pred = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]

# absolute_error
@test absolute_error(y_true, y_pred) == [9, 7, 5, 3, 1, 1, 3, 5, 7, 9]

# percent_error
@test 1 == 1

# log_error
@test 1 == 1

# squared_error
@test squared_error(y_true, y_pred) == [81, 49, 25, 9, 1, 1, 9, 25, 49, 81]

# squared_log_error
@test 1 == 1

# absolute_percent_error
@test 1 == 1

# mean_error
@test mean_error(y_true, y_pred) == 0.0

# mean_absolute_error
@test mean_absolute_error(y_true, y_pred) == 5.0

# median_absolute_error
@test median_absolute_error(y_true, y_pred) == 5.0

# mean_percent_error
@test 1 == 1

# median_percent_error
@test 1 == 1

# mean_squared_error
@test mean_squared_error(y_true, y_pred) == 33.0

# median_squared_error
@test median_squared_error(y_true, y_pred) == 25.0

# sum_squared_error
@test sum_squared_error(y_true, y_pred) == 330

# mean_squared_log_error
@test 1 == 1

# mean_absolute_percent_error
@test 1 == 1

# median_absolute_percent_error
@test 1 == 1

# symmetric_mean_absolute_percent_error
@test 1 == 1

# symmetric_median_absolute_percent_error
@test 1 == 1

# mean_absolute_scaled_error
@test mean_absolute_scaled_error(y_true, y_pred) == 1.125

# total_variance_score
@test total_variance_score(y_true, y_pred) == 82.5

# explained_variance_score
@test explained_variance_score(y_true, y_pred) == 82.5

# unexplained_variance_score
@test unexplained_variance_score(y_true, y_pred) == 330

# r2_score
@test r2_score(y_true, y_pred) == 1.0
