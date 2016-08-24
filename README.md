# MLMetrics.jl

_Utility package for scoring models in data science and machine learning. This toolset is written in Julia for blazing fast performance._

| **Package Status** | **Package Evaluator** | **Build Status**  |
|:------------------:|:---------------------:|:-----------------:|
| [![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md) | [![MLMetrics](http://pkg.julialang.org/badges/MLMetrics_0.4.svg)](http://pkg.julialang.org/?pkg=MLMetrics&ver=0.4) [![MLMetrics](http://pkg.julialang.org/badges/MLMetrics_0.4.svg)](http://pkg.julialang.org/?pkg=MLMetrics&ver=0.5) | [![Build Status](https://travis-ci.org/JuliaML/MLMetrics.jl.svg?branch=master)](https://travis-ci.org/JuliaML/MLMetrics.jl) [![Build status](https://ci.appveyor.com/api/projects/status/1p7noblkootdqiqj?svg=true)](https://ci.appveyor.com/project/JuliaML/mlmetrics-jl) [![Coverage Status](https://coveralls.io/repos/JuliaML/MLMetrics.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaML/MLMetrics.jl?branch=master) |

## Introduction

This toolset's API follows that of Python's [sklearn.metrics](http://scikit-learn.org/stable/modules/classes.html#sklearn-metrics-metrics)
as closely as possible so one can easily switch back and forth
between Julia and Python without too much cognitive dissonance.
The following types of metrics are currently implemented in `MLMetrics`:

-   Regression metrics
-   Classification metrics

The following types of metrics are soon to be implemented in `MLMetrics`:

-   Multilabel ranking metrics
-   Clustering metrics
-   Biclustering metrics
-   Pairwise metrics

Installation
------------

This package is registered in `METADATA.jl` and can be installed as usual

``` julia
Pkg.add("MLMetrics")
using MLMetrics
```

If you encounter a clear bug, please file a minimal reproducible example on [Github](https://github.com/JuliaML/MLMetrics.jl/issues).

## Overview

``` julia
mean_squared_error([1.0, 2.0], [1.0, 1.0])
accuracy([1, 1, 1, 0], [1, 0, 1, 1])
```

## License

This code is free to use under the terms of the MIT license.

## Acknowledgements

The original author of `MLMetrics` is [@Paul Hendricks](<https://github.com/paulhendricks>). [![Gratipay](https://img.shields.io/gratipay/JSFiddle.svg)](https://gratipay.com/~paulhendricks/)


