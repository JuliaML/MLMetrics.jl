# --------------------------------------------------------------------
# LabelEncoding aggregate logic

aggregate_fraction(numerator, denominator, labels, avgmode) =
    throw(ArgumentError("$avgmode is not supported"))

aggregate_fraction(numerator, denominator, labels, ::AvgMode.None) =
    Dict(Pair.(labels, numerator ./ denominator))

aggregate_fraction(numerator, denominator, labels, ::AvgMode.Macro) =
    mean(Base.Broadcast.broadcasted(/, numerator, denominator))

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
                            targets, outputs,
                            convert(AverageMode, avgmode))

        ($fun)(targets, outputs, encoding; avgmode=AvgMode.None()) =
            reduce_fraction($numer_fun, $denom_fun,
                            targets, outputs, encoding,
                            convert(AverageMode, avgmode))

        ($fun)(targets, outputs, encoding, avgmode) =
            reduce_fraction($numer_fun, $denom_fun,
                            targets, outputs, encoding, avgmode)

        # for objects like BinaryMetricsCache
        ($fun)(object) = ($numer_fun)(object) / ($denom_fun)(object)

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
        targets::AbstractArray,
        outputs::AbstractArray,
        encoding::BinaryLabelEncoding,
        avgmode::AvgMode.None)
    @_dimcheck length(targets) == length(outputs)
    numer::Int = 0; denom::Int = 0
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
        targets::AbstractArray,
        outputs::AbstractArray,
        encoding::LabelEncoding,
        avgmode::AverageMode)
    @_dimcheck length(targets) == length(outputs)
    labels = label(encoding)
    n = length(labels)
    numer = zeros(n); denom = zeros(n)
    ovr = [LabelEnc.OneVsRest(l) for l in labels]
    @inbounds for I in eachindex(targets, outputs)
        target = targets[I]
        output = outputs[I]
        for j in 1:n
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
        targets::AbstractArray,
        outputs::AbstractArray,
        labels::AbstractVector,
        avgmode::AverageMode)
    reduce_fraction(numer_fun, denom_fun,
                    targets, outputs,
                    LabelEnc.NativeLabels(labels),
                    avgmode)
end

# fallbacks to try and choose compare mode automatically
function reduce_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractArray,
        outputs::AbstractArray,
        avgmode::AverageMode)
    reduce_fraction(numer_fun, denom_fun,
                    targets, outputs,
                    _labelenc(targets, outputs),
                    avgmode)
end

# --------------------------------------------------------------------

"""
This will allow for readable function definition such as

    @map_fraction \"\"\"
    some documentation for the function
    \"\"\" ->
    positive_likelihood_ratio := true_positive_rate / false_positive_rate

with the added bonus of the functions being implemented in such
a way as to avoid memory allocation and being able to compute
their results in just one pass.
"""
macro map_fraction(all)
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
            map_fraction($numer_fun, $denom_fun,
                         targets, outputs, avgmode)

        ($fun)(targets, outputs; avgmode=AvgMode.None()) =
            map_fraction($numer_fun, $denom_fun,
                         targets, outputs,
                         convert(AverageMode, avgmode))

        ($fun)(targets, outputs, encoding; avgmode=AvgMode.None()) =
            map_fraction($numer_fun, $denom_fun,
                         targets, outputs, encoding,
                         convert(AverageMode, avgmode))

        ($fun)(targets, outputs, encoding, avgmode) =
            map_fraction($numer_fun, $denom_fun,
                         targets, outputs, encoding, avgmode)

        # for objects like BinaryMetricsCache
        ($fun)(object) = ($numer_fun)(object) / ($denom_fun)(object)

        # add documentation to function
        @doc """
            $($(string(fun)))(targets, outputs, [encoding], [avgmode])

        $($docstr)
        """ ($fun)
    end)
end

# generic binary and multiclass case (except None). returns float
function map_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractArray,
        outputs::AbstractArray,
        encoding::LabelEncoding,
        avgmode::AverageMode)
    numer = numer_fun(targets, outputs, encoding, avgmode)
    denom = denom_fun(targets, outputs, encoding, avgmode)
    numer / denom
end

# binary case for AvgMode.None, because it also returns a float
function map_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractArray,
        outputs::AbstractArray,
        encoding::BinaryLabelEncoding,
        avgmode::AvgMode.None)
    numer = numer_fun(targets, outputs, encoding, avgmode)
    denom = denom_fun(targets, outputs, encoding, avgmode)
    numer / denom
end

# multiclass case for AvgMode.None should return a Dict again
function map_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractArray,
        outputs::AbstractArray,
        encoding::LabelEncoding,
        avgmode::AvgMode.None)
    numer = numer_fun(targets, outputs, encoding, avgmode)
    denom = denom_fun(targets, outputs, encoding, avgmode)
    Dict(label => numer[label] / denom[label] for label in keys(numer))
end

# fallback for native labels as plain vector
function map_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractArray,
        outputs::AbstractArray,
        labels::AbstractVector,
        avgmode::AverageMode)
    map_fraction(numer_fun, denom_fun,
                 targets, outputs,
                 LabelEnc.NativeLabels(labels),
                 avgmode)
end

# fallbacks to try and choose compare mode automatically
function map_fraction(
        numer_fun::Function,
        denom_fun::Function,
        targets::AbstractArray,
        outputs::AbstractArray,
        avgmode::AverageMode)
    map_fraction(numer_fun, denom_fun,
                 targets, outputs,
                 _labelenc(targets, outputs),
                 avgmode)
end
