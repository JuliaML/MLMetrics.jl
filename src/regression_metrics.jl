function squared_error(y_true::Array, y_pred::Array)
    return((y_true - y_pred) .^ 2)
end

function sum_squared_error(y_true::Array, y_pred::Array)
    return(sum(squared_error(y_true, y_pred)))
end