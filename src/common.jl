function check_args(y_true::Vector, y_pred::Vector)
    @assert length(y_true) == length(y_pred)
    return(true)
end
