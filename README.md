# MLMetrics.jl

_Utility package for scoring models in data science and machine learning. This toolset is written in Julia for blazing fast performance._

| **Package Status** | **Package Evaluator** | **Build Status**  |
|:------------------:|:---------------------:|:-----------------:|
| [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md) [![Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaML.github.io/MLMetrics.jl/latest) | [![MLMetrics](http://pkg.julialang.org/badges/MLMetrics_0.7.svg)](http://pkg.julialang.org/?pkg=MLMetrics&ver=0.7) | [![Build Status](https://travis-ci.org/JuliaML/MLMetrics.jl.svg?branch=master)](https://travis-ci.org/JuliaML/MLMetrics.jl) [![Build status](https://ci.appveyor.com/api/projects/status/1p7noblkootdqiqj?svg=true)](https://ci.appveyor.com/project/JuliaML/mlmetrics-jl) [![Coverage Status](https://coveralls.io/repos/JuliaML/MLMetrics.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaML/MLMetrics.jl?branch=master) |

## Introduction

## Example

``` julia
mean_squared_error([1.0, 2.0], [1.0, 1.0])
accuracy([1, 1, 1, 0], [1, 0, 1, 1])
```

## Documentation

For a much more detailed treatment check out the
[latest
documentation](https://JuliaML.github.io/MLMetrics.jl/stable)

Additionally, you can make use of Julia's native docsystem. The
following example shows how to get additional information on
`accuracy` within Julia's REPL:

```
?accuracy
```

## Installation

Not yet registered. WIP

## License

This code is free to use under the terms of the MIT license.

## Acknowledgements

The original author of `MLMetrics` was [@Paul Hendricks](<https://github.com/paulhendricks>).
Since then the package has been extensively refactored and is now
maintained by the JuliaML community.
