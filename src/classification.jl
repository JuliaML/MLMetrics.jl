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
    tp = true_positive(y_true, y_pred)
    tn = true_negative(y_true, y_pred)
    tot_pop = total_population(y_true, y_pred)
    return((tp + tn) / tot_pop)
end

accuracy = accuracy_score

function prevalence(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    cp = condition_positive(y_true, y_pred)
    tot_pop = total_population(y_true, y_pred)
    return(cp / tot_pop)
end

function positive_predictive_value(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    tp = true_positive(y_true, y_pred)
    pcp = predicted_condition_positive(y_true, y_pred)
    return(tp / pcp)
end

precision = positive_predictive_value

function false_discovery_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    fp = false_positive(y_true, y_pred)
    pcp = predicted_condition_positive(y_true, y_pred)
    return(fp / pcp)
end

function negative_predictive_value(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    tn = true_negative(y_true, y_pred)
    pcn = predicted_condition_negative(y_true, y_pred)
    return(tn / pcn)
end

function false_omission_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    fn = false_negative(y_true, y_pred)
    pcn = predicted_condition_negative(y_true, y_pred)
    return(fn / pcn)
end

function true_positive_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    tp = true_positive(y_true, y_pred)
    cp = condition_positive(y_true, y_pred)
    return(tp / cp)
end

sensitivity = true_positive_rate
recall = true_positive_rate

function false_positive_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    fp = false_positive(y_true, y_pred)
    cn = condition_negative(y_true, y_pred)
    return(fp / cn)
end

function false_negative_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    fn = false_negative(y_true, y_pred)
    cp = condition_positive(y_true, y_pred)
    return(fn / cp)
end

function true_negative_rate(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    tn = true_negative(y_true, y_pred)
    cn = condition_negative(y_true, y_pred)
    return(tn / cn)
end

specificity = true_negative_rate

function positive_likelihood_ratio(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    tpr = true_positive_rate(y_true, y_pred)
    fpr = false_positive_rate(y_true, y_pred)
    return(tpr / fpr)
end

function negative_likelihood_ratio(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    fnr = false_negative_rate(y_true, y_pred)
    tnr = true_negative_rate(y_true, y_pred)
    return(fnr / tnr)
end

function diagnostic_odds_ratio(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    plr = positive_likelihood_ratio(y_true, y_pred)
    nlr = negative_likelihood_ratio(y_true, y_pred)
    return(plr / nlr)
end

function f1_score(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    tp = true_positive(y_true, y_pred)
    fp = false_positive(y_true, y_pred)
    fn = false_negative(y_true, y_pred)
    return((2 * tp) / (2 * tp + fp + fn))
end

function matthews_corrcoef(y_true::Vector, y_pred::Vector)
    check_args(y_true, y_pred)
    tp = true_positive(y_true, y_pred)
    tn = true_negative(y_true, y_pred)
    fp = false_positive(y_true, y_pred)
    fn = false_negative(y_true, y_pred)
    numerator = (tp * tn) - (fp * fn)
    denominator = (tp + fp) * (tp + fn) * (tn + fp) * (tn + fn)
    return(numerator / (denominator ^ 0.5))
end
