using Documenter, MLMetrics

# Workaround for JuliaLang/julia/pull/28625
if Base.HOME_PROJECT[] !== nothing
    Base.HOME_PROJECT[] = abspath(Base.HOME_PROJECT[])
end

makedocs(
    modules = [MLMetrics],
    clean = false,
    format = :html,
    assets = [
        joinpath("assets", "favicon.ico"),
        joinpath("assets", "style.css"),
    ],
    sitename = "MLMetrics.jl",
    authors = "Christof Stocker",
    linkcheck = !("skiplinks" in ARGS),
    pages = Any[
        "Home" => "index.md",
        "gettingstarted.md",
        hide("classification.md", Any[
            joinpath.("counts", readdir(joinpath(@__DIR__, "src", "counts")))...,
            joinpath.("fractions", readdir(joinpath(@__DIR__, "src", "fractions")))...,
        ]),
        hide("Indices" => "indices.md"),
        "LICENSE.md",
    ],
    html_prettyurls = !("local" in ARGS),
)

deploydocs(
    repo = "github.com/JuliaML/MLMetrics.jl.git",
    target = "build",
    julia = "1.0",
    deps = nothing,
    make = nothing,
)
