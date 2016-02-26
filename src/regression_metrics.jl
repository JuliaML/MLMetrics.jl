function absolute_error(y_true::Array, y_pred::Array)
    return(abs(y_true - y_pred))
end

function percent_error(y_true::Array, y_pred::Array)
    return((y_true - y_pred) / y_true)
end

function log_error(y_true::Array, y_pred::Array)
    return(log(y_true - y_pred))
end

function squared_error(y_true::Array, y_pred::Array)
    return((y_true - y_pred) .^ 2)
end

function squared_log_error(y_true::Array, y_pred::Array)
    return(log_error(y_true, y_pred) .^ 2)
end

function absolute_percent_error(y_true::Array, y_pred::Array)
    return(abs(percent_error(y_true, y_pred)))
end

function mean_error(y_true::Array, y_pred::Array)
    return(mean(y_true - y_pred))
end

function mean_absolute_error(y_true::Array, y_pred::Array)
    return(mean(absolute_error(y_true, y_pred)))
end

function median_absolute_error(y_true::Array, y_pred::Array)
    return(median(absolute_error(y_true, y_pred)))
end

function mean_percent_error(y_true::Array, y_pred::Array)
    return(mean(percent_error(y_true, y_pred)))
end

function median_percent_error(y_true::Array, y_pred::Array)
    return(median(percent_error(y_true, y_pred)))
end

function mean_squared_error(y_true::Array, y_pred::Array)
    return(mean(squared_error(y_true, y_pred)))
end

function median_squared_error(y_true::Array, y_pred::Array)
    return(median(squared_error(y_true, y_pred)))
end

function sum_squared_error(y_true::Array, y_pred::Array)
    return(sum(squared_error(y_true, y_pred)))
end

function mean_squared_log_error(y_true::Array, y_pred::Array)
    return(mean(squared_log_error(y_true, y_pred)))
end

function mean_absolute_percent_error(y_true::Array, y_pred::Array)
    return(mean(absolute_percent_error(y_true, y_pred)))
end

function median_absolute_percent_error(y_true::Array, y_pred::Array)
    return(median(absolute_percent_error(y_true, y_pred)))
end

function symmetric_mean_absolute_percent_error(y_true::Array, y_pred::Array)
    return(true)
end

function symmetric_median_absolute_percent_error(y_true::Array, y_pred::Array)
    return(true)
end

function mean_absolute_scaled_error(y_true::Array, y_pred::Array)
    return(true)
end

function total_variance_score(y_true::Array, y_pred::Array)
    return(true)
end

function explained_variance_score(y_true::Array, y_pred::Array)
    return(true)
end

function explained_variance_score(y_true::Array, y_pred::Array)
    return(true)
end

function r2_score(y_true::Array, y_pred::Array)
    return(true)
end
