# code that is prototyped here, but should really be upstream.
# (like MLLabelUtils.jl or LossFunctions.jl)

# LossFunctions

Base.convert(::Type{AverageMode}, avgmode) = throw(ArgumentError("Unknown way to specify a obsdim: $avgmode"))
Base.convert(::Type{AverageMode}, avgmode::AverageMode) = avgmode
Base.convert(::Type{AverageMode}, avgmode::String) = convert(AverageMode, Symbol(lowercase(avgmode)))
Base.convert(::Type{AverageMode}, ::typeof(sum)) = AvgMode.Sum()
Base.convert(::Type{AverageMode}, ::typeof(mean)) = AvgMode.Mean()
Base.convert(::Type{AverageMode}, ::Nothing) = AvgMode.None()
function Base.convert(::Type{AverageMode}, avgmode::Symbol)
    if avgmode == :mean
        AvgMode.Mean()
    elseif avgmode == :micro
        AvgMode.Micro()
    elseif avgmode == :macro
        AvgMode.Macro()
    elseif avgmode == :sum
        AvgMode.Sum()
    elseif avgmode == Symbol("nothing") || avgmode == :none || avgmode == :null || avgmode == :na || avgmode == :undefined
        AvgMode.None()
    else
        throw(ArgumentError("Unknown way to specify a \"avgmode\": $avgmode"))
    end
end
