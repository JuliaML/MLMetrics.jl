Metrics.jl
======

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active)
[![Metrics](http://pkg.julialang.org/badges/Metrics_0.3.svg)](http://pkg.julialang.org/?pkg=Metrics&ver=0.3)
[![Metrics](http://pkg.julialang.org/badges/Metrics_0.4.svg)](http://pkg.julialang.org/?pkg=Metrics&ver=0.4)
[![Metrics](http://pkg.julialang.org/badges/Metrics_0.4.svg)](http://pkg.julialang.org/?pkg=Metrics&ver=0.5)
[![Coverage Status](https://coveralls.io/repos/paulhendricks/Metrics.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/paulhendricks/Metrics.jl?branch=master)
[![Build Status](https://travis-ci.org/paulhendricks/Metrics.jl.svg?branch=master)](https://travis-ci.org/paulhendricks/Metrics.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/56u32eosqom801ht?svg=true)](https://ci.appveyor.com/project/paulhendricks/metrics-jl)

`Metrics` is a set of tools for quickly scoring models in data science and machine learning. This toolset is written in Julia for blazing fast performance. This toolset's API follows that of Python's [sklearn.metrics](http://scikit-learn.org/stable/modules/classes.html#sklearn-metrics-metrics) as closely as possible so one can easily switch back and forth between Julia and Python without too much cognitive dissonance. The following types of metrics are currently implemented in `Metrics`:

-   Regression metrics (implemented in 0.1.0)
-   Classification metrics (implemented in 0.1.0)

The following types of metrics are soon to be implemented in `Metrics`:

-   Multilabel ranking metrics (to be implemented in 0.2.0)
-   Clustering metrics (to be implemented in 0.2.0)
-   Biclustering metrics (to be implemented in 0.2.0)
-   Pairwise metrics (to be implemented in 0.2.0)

Installation
------------

You can install:

-   the latest stable release version with

    ``` julia
    Pkg.add("Metrics")
    ```

-   the latest development version from Github with

    ``` julia
    Pkg.checkout("Metrics", "dev")
    ```

If you encounter a clear bug, please file a minimal reproducible example on [Github](https://github.com/paulhendricks/Metrics.jl/issues).

News
----

### Metrics 0.1.0

#### Improvements

-   Implemented functions for scoring regression models.

API
---

### Load package

``` julia
using Metrics
```

### Use metrics to score results from models

``` julia
mean_squared_error([1.0, 2.0], [1.0, 1.0])
```

People
------

-   The original author of `Metrics` is [@Paul Hendricks](<https://github.com/paulhendricks>). [![Gratipay](https://img.shields.io/gratipay/JSFiddle.svg)](https://gratipay.com/~paulhendricks/)

-   The lead maintainer of `Metrics` is [@Paul Hendricks](<https://github.com/paulhendricks>). [![Gratipay](https://img.shields.io/gratipay/JSFiddle.svg)](https://gratipay.com/~paulhendricks/)

License
-------

[![License](http://img.shields.io/:license-MIT-blue.svg)](https://github.com/paulhendricks/Metrics.jl/blob/master/LICENSE.md)
