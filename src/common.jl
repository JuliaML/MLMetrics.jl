# TODO: put this in LearnBase maybe? Losses use the same macro
macro _dimcheck(condition)
    :(($(esc(condition))) || throw(DimensionMismatch("Dimensions of the parameters don't match")))
end

