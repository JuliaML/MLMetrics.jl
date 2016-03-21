function total_population(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(length(y_true))
end

function true_positive(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(sum((y_true .== y_pred) & (y_true .== 1)))
end

function true_negative(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(sum((y_true .== y_pred) & (y_true .== 0)))
end

function false_positive(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(sum(!(y_true .== y_pred) & (y_true .== 1)))
end

function false_negative(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(sum(!(y_true .== y_pred) & (y_true .== 0)))
end

function condition_positive(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(sum(y_true .== 1))
end

function condition_negative(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(sum(y_true .== 0))
end

function predicted_condition_positive(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(sum(y_true .== 1))
end

function predicted_condition_negative(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(sum(y_pred .== 0))
end

function accuracy_score(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    correct = true_positive(y_true, y_pred) + true_negative(y_true, y_pred)
    return(correct / total_population(y_true, y_pred))
end

accuracy = accuracy_score

function prevalence(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(condition_positive(y_true, y_pred) / total_population(y_true, y_pred))
end

function positive_predictive_value(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(true_positive(y_true, y_pred) / predicted_condition_positive(y_true, y_pred))
end

precision = positive_predictive_value

function false_discovery_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(false_positive(y_true, y_pred) / predicted_condition_positive(y_true, y_pred))
end

function negative_predictive_value(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(true_negative(y_true, y_pred) / predicted_condition_negative(y_true, y_pred))
end

function false_omission_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(false_negative(y_true, y_pred) / predicted_condition_negative(y_true, y_pred))
end

function true_positive_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(true_positive(y_true, y_pred) / condition_positive(y_true, y_pred))
end

sensitivity = true_positive_rate
recall = true_positive_rate

function false_positive_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(false_positive(y_true, y_pred) / condition_negative(y_true, y_pred))
end

function false_negative_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(false_negative(y_true, y_pred) / condition_positive(y_true, y_pred))
end

function true_negative_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(true_negative(y_true, y_pred) / condition_negative(y_true, y_pred))
end

specificity = true_negative_rate

function positive_likelihood_ratio(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(true_positive_rate(y_true, y_pred) / false_positive_rate(y_true, y_pred))
end

function negative_likelihood_ratio(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(false_negative_rate(y_true, y_pred) / true_negative_rate(y_true, y_pred))
end

function diagnostic_odds_ratio(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    return(positive_likelihood_ratio(y_true, y_pred) / negative_likelihood_ratio(y_true, y_pred))
end

function f1_score(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    numerator = 2 * true_positive(y_true, y_pred)
    denominator = 2 * true_positive(y_true, y_pred) + false_positive(y_true, y_pred) + false_negative(y_true, y_pred)
    return(numerator / denominator)
end

function matthews_corrcoef(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    numerator_1 = true_positive(y_true, y_pred) * true_negative(y_true, y_pred)
    numerator_2 = false_positive(y_true, y_pred) * false_negative(y_true, y_pred)
    numerator = numerator_1 - numerator_2
    denominator_1 = true_positive(y_true, y_pred) + false_positive(y_true, y_pred)
    denominator_2 = true_positive(y_true, y_pred) + false_negative(y_true, y_pred)
    denominator_3 = true_negative(y_true, y_pred) + false_positive(y_true, y_pred)
    denominator_4 = true_negative(y_true, y_pred) + false_negative(y_true, y_pred)
    denominator = denominator_1 * denominator_2 * denominator_3 * denominator_4
    return(numerator / (denominator ^ 0.5))
end
