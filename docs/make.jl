using Documenter

# Add the parent directory to the load path to find StateBins
push!(LOAD_PATH, joinpath(@__DIR__, ".."))

using StateBins

makedocs(
    sitename = "StateBins.jl",
    format = Documenter.HTML(
        prettyurls = false,
        edit_link = nothing
    ),
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md"
    ],
    modules = [StateBins],
    clean = true,
    doctest = false,
    remotes = nothing
)