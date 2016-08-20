# TODO: put this in LearnBase maybe? Losses use the same macro
macro _dimcheck(condition)
    :(($(esc(condition))) || throw(DimensionMismatch("Dimensions of the parameters don't match")))
end

const pos_examples = "Positive examples: `1`, `2.0`, `true`, `0.5`, `:2`."
const neg_examples = "Negative examples: `0`, `-1`, `0.0`, `-0.5`, `false`, `:0`."
