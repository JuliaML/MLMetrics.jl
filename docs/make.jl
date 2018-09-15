using Documenter, MLMetrics

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
