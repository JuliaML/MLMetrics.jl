module AverageMode

export
    None,
    Macro,
    Micro,
    Weighted

abstract AvgMode

immutable None <: AvgMode end
immutable Macro <: AvgMode end
immutable Micro <: AvgMode end
immutable Weighted <: AvgMode end

end

