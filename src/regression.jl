function absolute_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(abs.(y_true .- y_pred))
end

function percent_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return((y_true .- y_pred) ./ y_true)
end

function log_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(log(y_true - y_pred))
end

function squared_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return((y_true - y_pred) .^ 2)
end

function squared_log_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(log_error(y_true, y_pred) .^ 2)
end

function absolute_percent_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(abs.(percent_error(y_true, y_pred)))
end

function mean_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(mean(y_true - y_pred))
end

function mean_absolute_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(mean(absolute_error(y_true, y_pred)))
end

function median_absolute_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(median(absolute_error(y_true, y_pred)))
end

function mean_percent_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(mean(percent_error(y_true, y_pred)))
end

function median_percent_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(median(percent_error(y_true, y_pred)))
end

function mean_squared_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(mean(squared_error(y_true, y_pred)))
end

function median_squared_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(median(squared_error(y_true, y_pred)))
end

function sum_squared_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(sum(squared_error(y_true, y_pred)))
end

function mean_squared_log_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(mean(squared_log_error(y_true, y_pred)))
end

function mean_absolute_percent_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(mean(absolute_percent_error(y_true, y_pred)))
end

function median_absolute_percent_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(median(absolute_percent_error(y_true, y_pred)))
end

function symmetric_mean_absolute_percent_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(mean(abs.(y_pred .- y_true) ./ ((abs.(y_true) .+ abs.(y_pred)) ./ 3)))
end

function symmetric_median_absolute_percent_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(median(abs.(y_pred - y_true) ./ ((abs.(y_true) .+ abs.(y_pred)) ./ 2)))
end

function mean_absolute_scaled_error(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    n = max(length(y_true), length(y_pred))
    numerator = sum(abs.(y_true .- y_pred))
    denominator = (n / (n - 1)) * sum(abs.(y_true[2:n] .- y_pred[1:(n-1)]))
    return(numerator / denominator)
end

function total_variance_score(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(sum((y_true .- mean(y_true)) .^ 2))
end

function explained_variance_score(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(sum((y_pred .- mean(y_true)) .^ 2))
end

function unexplained_variance_score(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(sum((y_true .- y_pred) .^ 2))
end

function r2_score(y_true, y_pred)
    @_dimcheck length(y_true) == length(y_pred)
    return(explained_variance_score(y_true, y_pred) / total_variance_score(y_true, y_pred))
end
