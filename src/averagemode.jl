abstract type AverageMode end

module AvgMode
    import ..MLMetrics.AverageMode
    export None, Micro, Macro

    struct None <: AverageMode end
    struct Micro <: AverageMode end
    struct Macro <: AverageMode end
end

Base.convert(::Type{AverageMode}, avgmode) = throw(ArgumentError("Unknown way to specify a obsdim: $avgmode"))
Base.convert(::Type{AverageMode}, avgmode::AverageMode) = avgmode
Base.convert(::Type{AverageMode}, avgmode::String) = convert(AverageMode, Symbol(lowercase(avgmode)))
Base.convert(::Type{AverageMode}, ::Nothing) = AvgMode.None()

function Base.convert(::Type{AverageMode}, avgmode::Symbol)
    if avgmode == :micro
        AvgMode.Micro()
    elseif avgmode == :macro
        AvgMode.Macro()
    elseif avgmode == Symbol("nothing") || avgmode == :none || avgmode == :null || avgmode == :na || avgmode == :undefined
        AvgMode.None()
    else
        throw(ArgumentError("Unknown way to specify a \"avgmode\": $avgmode"))
    end
end
