# MLMetrics.jl's Documentation

## Where to begin?

If this is the first time you consider using MLMetrics for
your machine learning related experiments or packages, make sure
to check out the "Getting Started" section; specifically "How to
…?", which lists some of most common scenarios and links to the
appropriate places that should guide you on how to approach these
scenarios using the functionality provided by this or other
packages.

```@contents
Pages = ["gettingstarted.md"]
Depth = 2
```

## Classification Metrics

| predicted \ actual |     |     |
|--------------------------------|-------------------------------------|-------------------------------------|
|                                | `condition_positive`                | `condition_negative`                |
| `predicted_condition_positive` | `true_positives`                    | `false_positives` (`type_1_errors`) |
| `predicted_condition_negative` | `false_negatives` (`type_2_errors`) | `true_negatives`                    |

`correctly_classified`, `incorrectly_classified`

## Regression Metrics

## Index

```@contents
Pages = ["indices.md"]
```
