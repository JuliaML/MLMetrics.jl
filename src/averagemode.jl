module AverageMode

export
    None,
    Macro,
    Micro,
    Weighted

abstract type AvgMode end

struct None <: AvgMode end
struct Macro <: AvgMode end
struct Micro <: AvgMode end
struct Weighted <: AvgMode end

end

