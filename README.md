MachineLearningMetrics.jl
======

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active)
[![MachineLearningMetrics](http://pkg.julialang.org/badges/MachineLearningMetrics_0.3.svg)](http://pkg.julialang.org/?pkg=MachineLearningMetrics&ver=0.3)
[![MachineLearningMetrics](http://pkg.julialang.org/badges/MachineLearningMetrics_0.4.svg)](http://pkg.julialang.org/?pkg=MachineLearningMetrics&ver=0.4)
[![MachineLearningMetrics](http://pkg.julialang.org/badges/MachineLearningMetrics_0.4.svg)](http://pkg.julialang.org/?pkg=MachineLearningMetrics&ver=0.5)
[![Coverage Status](https://coveralls.io/repos/paulhendricks/MachineLearningMetrics.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/paulhendricks/MachineLearningMetrics.jl?branch=master)
[![Build Status](https://travis-ci.org/paulhendricks/MachineLearningMetrics.jl.svg?branch=master)](https://travis-ci.org/paulhendricks/MachineLearningMetrics.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/1p7noblkootdqiqj?svg=true)](https://ci.appveyor.com/project/paulhendricks/machinelearningmetrics-jl)

`MachineLearningMetrics` is a set of tools for quickly scoring models in data science and machine learning. This toolset is written in Julia for blazing fast performance. This toolset's API follows that of Python's [sklearn.metrics](http://scikit-learn.org/stable/modules/classes.html#sklearn-metrics-metrics) as closely as possible so one can easily switch back and forth between Julia and Python without too much cognitive dissonance. The following types of metrics are currently implemented in `MachineLearningMetrics`:

-   Regression metrics (implemented in 0.1.0)
-   Classification metrics (implemented in 0.1.0)

The following types of metrics are soon to be implemented in `MachineLearningMetrics`:

-   Multilabel ranking metrics (to be implemented in 0.2.0)
-   Clustering metrics (to be implemented in 0.2.0)
-   Biclustering metrics (to be implemented in 0.2.0)
-   Pairwise metrics (to be implemented in 0.2.0)

Installation
------------

You can install:

-   the latest stable release version with

    ``` julia
    Pkg.add("MachineLearningMetrics")
    ```

-   the latest development version from Github with

    ``` julia
    Pkg.checkout("MachineLearningMetrics", "dev")
    ```

If you encounter a clear bug, please file a minimal reproducible example on [Github](https://github.com/paulhendricks/MachineLearningMetrics.jl/issues).

News
----

### MachineLearningMetrics 0.1.0

#### Improvements

-   Implemented functions for scoring regression models.
-   Implemented functions for scoring classification models.

API
---

### Load package

``` julia
using MachineLearningMetrics
```

### Use metrics to score results from models

``` julia
mean_squared_error([1.0, 2.0], [1.0, 1.0])
accuracy([1, 1, 1, 0], [1, 0, 1, 1])
```

People
------

-   The original author of `MachineLearningMetrics` is [@Paul Hendricks](<https://github.com/paulhendricks>). [![Gratipay](https://img.shields.io/gratipay/JSFiddle.svg)](https://gratipay.com/~paulhendricks/)

-   The lead maintainer of `MachineLearningMetrics` is [@Paul Hendricks](<https://github.com/paulhendricks>). [![Gratipay](https://img.shields.io/gratipay/JSFiddle.svg)](https://gratipay.com/~paulhendricks/)

License
-------

[![License](http://img.shields.io/:license-MIT-blue.svg)](https://github.com/paulhendricks/MachineLearningMetrics.jl/blob/master/LICENSE.md)
