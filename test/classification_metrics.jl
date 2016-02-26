using Base.Test
using Metrics

@test area_under_curve([1.0, 2.0],[1.0, 3.0]) == true
@test area_under_curve([1.0, 2.0, 3.0],[1.0, 2.0, 3.0]) == true
@test area_under_curve([1.0, 2.0, 3.0],[1.0, 2.0, 4.0])== true
@test area_under_curve([1.0, 2.0], [1.0, 6.0]) == true
