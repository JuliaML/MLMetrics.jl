using Base.Test
using Metrics

# absolute_error

# percent_error
# log_error
# squared_error
# squared_log_error
# absolute_percent_error
# mean_error
# mean_absolute_error
# median_absolute_error
# mean_percent_error
# median_percent_error

# mean_squared_error
@test mean_squared_error([1.0, 2.0],[1.0, 3.0]) == 0.5
@test mean_squared_error([1.0, 2.0, 3.0],[1.0, 2.0, 3.0]) == 0.0
@test mean_squared_error([1.0, 2.0, 3.0],[1.0, 2.0, 4.0])== 1.0 / 3
@test mean_squared_error([1.0, 2.0], [1.0, 6.0]) == 8.0

# median_squared_error
# sum_squared_error
# mean_squared_log_error
# mean_absolute_percent_error
# median_absolute_percent_error
# symmetric_mean_absolute_percent_error
# symmetric_median_absolute_percent_error
# mean_absolute_scaled_error
# total_variance_score
# explained_variance_score
# unexplained_variance_score
# r2_score
