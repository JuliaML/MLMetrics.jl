using Base.Test
using Metrics

@test mean_squared_error([1.0, 2.0],[1.0, 3.0]) == 0.5
@test mean_squared_error([1.0, 2.0, 3.0],[1.0, 2.0, 3.0]) == 0.0
@test mean_squared_error([1.0, 2.0, 3.0],[1.0, 2.0, 4.0])== 1.0 / 3
@test mean_squared_error([1.0, 2.0], [1.0, 6.0]) == 8.0
