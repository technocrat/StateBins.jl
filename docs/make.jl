using Documenter
using MaterialDocs
using StateBins

makedocs(;
    sitename = "StateBins.jl",
    authors = "Richard Careaga <public@careaga.net>",
    modules = [StateBins],
    format = Material3(;
        theme = :ocean_depth,
        dark_mode = :toggle,
        edit_link = "main",
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://technocrat.github.io/StateBins.jl",
    ),
    repo = Remotes.GitHub("technocrat", "StateBins.jl"),
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md",
    ],
    checkdocs = :none,
)

deploydocs(;
    repo = "github.com/technocrat/StateBins.jl.git",
    devbranch = "main",
)
