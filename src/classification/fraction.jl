# --------------------------------------------------------------------
# LabelEncoding aggregate logic

aggregate_fraction(numerator, denominator, labels, avgmode) =
    throw(ArgumentError("$avgmode is not supported"))

aggregate_fraction(numerator, denominator, labels, ::AvgMode.None) =
    Dict(Pair.(labels, numerator ./ denominator))

aggregate_fraction(numerator, denominator, labels, ::AvgMode.Macro) =
    mean(numerator ./ denominator)

aggregate_fraction(numerator, denominator, labels, ::AvgMode.Micro) =
    sum(numerator) / sum(denominator)

# TODO: add weighted versions

# --------------------------------------------------------------------

"""
This will allow for readable function definition such as

    @reduce_fraction \"\"\"
    some documentation for the function
    \"\"\" ->
    precision := true_positives / predicted_condition_positive

with the added bonus of the functions being implemented in such
a way as to avoid memory allocation and being able to compute
their results in just one pass.
"""
macro reduce_fraction(all)
    @assert all.head == :->
    docstr = all.args[1]
    expr = all.args[2].args[2]
    @assert expr.head == :(:=)
    fun = expr.args[1]
    @assert expr.args[2].args[1] == :/
    numer_fun = expr.args[2].args[2]
    denom_fun = expr.args[2].args[3]
    esc(quote

        # explicit binary case
        ($fun)(targets, outputs, avgmode::AverageMode) =
            reduce_fraction($numer_fun, $denom_fun,
                            targets, outputs, avgmode)

        ($fun)(targets, outputs; avgmode=AvgMode.None()) =
            reduce_fraction($numer_fun, $denom_fun,
                            targets, outputs, avgmode)

        ($fun)(targets, outputs, encoding; avgmode=AvgMode.None()) =
            reduce_fraction($numer_fun, $denom_fun,
                            targets, outputs, encoding, avgmode)

        ($fun)(targets, outputs, encoding, avgmode) =
            reduce_fraction($numer_fun, $denom_fun,
                            targets, outputs, encoding, avgmode)

        # add documentation to function
        @doc """
            $($(string(fun)))(targets, outputs, [encoding], [avgmode])

        $($docstr)
        """ ($fun)
    end)
end

# --------------------------------------------------------------------
# explicit binary case
function reduce_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractVector,
        outputs::AbstractArray,
        encoding::BinaryLabelEncoding,
        avgmode::AverageMode)
    @_dimcheck length(targets) == length(outputs)
    numer = 0; denom = 0
    @inbounds for I in eachindex(targets, outputs)
        target = targets[I]
        output = outputs[I]
        numer += numer_fun(target, output, encoding)
        denom += denom_fun(target, output, encoding)
    end
    (numer / denom)::Float64
end

# multiclass case. The function aggregate_fraction dispatches on the mode
function reduce_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractVector,
        outputs::AbstractArray,
        encoding::LabelEncoding,
        avgmode::AverageMode)
    @_dimcheck length(targets) == length(outputs)
    labels = label(encoding)
    n = length(labels)
    numer = zeros(n); denom = zeros(n)
    ovr = [LabelEnc.OneVsRest(l) for l in labels]
    @inbounds for i = 1:length(targets)
        target = targets[i]
        output = outputs[i]
        for j = 1:n
            numer[j] += numer_fun(target, output, ovr[j])
            denom[j] += denom_fun(target, output, ovr[j])
        end
    end
    aggregate_fraction(numer, denom, labels, avgmode)
end

# fallback for native labels as plain vector
function reduce_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractVector,
        outputs::AbstractArray,
        encoding::AbstractVector,
        avgmode::AverageMode)
    reduce_fraction(numer_fun, denom_fun,
                    targets, outputs,
                    LabelEnc.NativeLabels(encoding),
                    convert(AverageMode, avgmode))
end

# fallbacks to try and choose compare mode automatically
function reduce_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractVector,
        outputs::AbstractArray,
        avgmode::AverageMode)
    reduce_fraction(numer_fun, denom_fun,
                    targets, outputs,
                    comparemode(targets, outputs),
                    avgmode)
end
