# Classification Metrics

## Counts

```@raw html
<div class="confusion">
```

|         -       |                              | actual | |
|-----------------|:----------------------------:|:-------------------------------------------:|:-------------------------------------------:|
|                 |                              | [`condition_positive`](@ref)                | [`condition_negative`](@ref)                |
| **predicted**   | [`predicted_positive`](@ref) | [`true_positives`](@ref)                    | [`false_positives`](@ref) (`type_1_errors`) |
|                 | [`predicted_negative`](@ref) | [`false_negatives`](@ref) (`type_2_errors`) | [`true_negatives`](@ref)                    |

```@raw html
</div>
```

[`correctly_classified`](@ref) vs [`incorrectly_classified`](@ref)

## Fractions

Name | Synonyms | Description
-----|:--------:|:--------------
[`prevalence`](@ref) | - | Fraction of truly positive outcomes in the data.
[`positive_predictive_value`](@ref) | `precision_score` | Fraction of positive predicted outcomes that are true positives.
[`negative_predictive_value`](@ref) | - | Fraction of negative predicted outcomes that are true negatives.
[`true_positive_rate`](@ref) | `recall`, `sensitivity` | Fraction of truly positive outcomes that were predicted as positive.
[`false_positive_rate`](@ref) | - | Fraction of truly negative outcomes that are (wrongly) predicted as positive (i.e. false positives).
[`true_negative_rate`](@ref) | `specificity` | Fraction of truly negative outcomes that were predicted as negative.
[`false_negative_rate`](@ref) | - | Fraction of truly positive outcomes that are (wrongly) predicted as negative (i.e. false negatives).
[`false_discovery_rate`](@ref) | - | Fraction of positive predicted outcomes that are false positives.
[`false_omission_rate`](@ref) | - | Fraction of negative predicted outcomes that are false negatives.
[`accuracy`](@ref) | - | Fraction of correctly classified observations.
[`f_score`](@ref) | - | Accuracy measure that considers recall and precision.
[`f1_score`](@ref) | - | Harmonic mean of recall and precision.
[`positive_likelihood_ratio`](@ref) | - | Fraction of true positive rate by false positive rate.
[`negative_likelihood_ratio`](@ref) | - | Fraction of false negative rate by true negative rate.
[`diagnostic_odds_ratio`](@ref) | - | Fraction of positive likelihood ratio by negative likelihood ratio.
