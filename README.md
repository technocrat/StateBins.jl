# StateBins.jl

A Julia package for creating statebins (state binned choropleth maps) visualizations adapted from the R package statesbin (©2015 by Bob Rudis). StateBins provide an alternative to traditional geographic maps by representing each US state as an equally-sized square arranged in a grid that roughly approximates the geographic layout of the United States.

## Features

- **Two backend options**: Simple Plots.jl interface and full-featured Makie.jl interface
- **Automatic state detection**: Works with state names or abbreviations
- **Adaptive text coloring**: State labels automatically switch between light/dark for optimal contrast
- **Customizable styling**: Full control over colors, sizes, fonts, and layout (Makie backend)
- **Sensible defaults**: Works out-of-the-box with minimal configuration

## Installation

```julia
using Pkg
Pkg.add("StateBins")
```

## Quick Start

### Plots.jl Backend (Simple)

```julia
using StateBins, DataFrames, Plots

# Create sample data
data = DataFrame(
    state = ["California", "Texas", "Florida", "New York", "Pennsylvania"],
    population = [39.5, 29.7, 22.6, 19.3, 13.0]
)

# Create statebins plot
statebins_plots(data, 
    state_col="state", 
    value_col="population",
    title="State Population (millions)")
```

### Makie.jl Backend (Full-featured)

```julia
using StateBins, DataFrames, CairoMakie  # or GLMakie, WGLMakie

# Create sample data with state abbreviations
data = DataFrame(
    state = ["CA", "TX", "FL", "NY", "PA"],
    gdp = [3.6, 2.4, 1.1, 2.0, 0.9]
)

# Create customized statebins plot
statebins_makie(data,
    state_col="state",
    value_col="gdp", 
    title="State GDP (trillions USD)",
    colorscheme=:plasma,
    font_size=14,
    show_colorbar=true,
    colorbar_label="GDP ($ trillions)")
```

## API Reference

### `statebins_plots(data::DataFrame; kwargs...)`

Simple Plots.jl-based statebins with minimal customization options.

**Arguments:**
- `data::DataFrame`: Input data with state and value columns
- `state_col::String="state"`: Name of the state column (accepts state names or abbreviations)
- `value_col::String="value"`: Name of the value column  
- `title::String=""`: Plot title

### `statebins_makie(data::DataFrame; kwargs...)`

Flexible Makie-based statebins with extensive customization options.

**Arguments:**
- `data::DataFrame`: Input data with state and value columns
- `state_col::String="state"`: Name of the state column
- `value_col::String="value"`: Name of the value column
- `title::String=""`: Plot title
- `colorscheme=:viridis`: Color scheme for mapping values
- `font_size::Int=12`: Font size for state labels
- `marker_size::Real=35`: Size of state markers
- `margin_factor::Float64=0.3`: Margin around text as fraction of text size
- `auto_size::Bool=true`: Whether to automatically calculate marker size
- `show_labels::Bool=true`: Whether to show state abbreviations
- `show_colorbar::Bool=true`: Whether to show the colorbar
- `border_color="white"`: Color of marker borders
- `border_width::Real=2`: Width of marker borders
- `figure_size::Tuple=(800, 600)`: Figure dimensions
- `hide_decorations::Bool=true`: Whether to hide axis decorations
- `colorbar_label::String=""`: Label for the colorbar
- `text_color_threshold::Float64=0.179`: Luminance threshold for text color switching

### `STATE_COORDS`

A DataFrame containing the coordinate grid positions for all US states, DC, Puerto Rico, Virgin Islands, and New York City. Contains columns:
- `abbrev`: State abbreviations
- `state`: Full state names  
- `col`: Grid column position
- `row`: Grid row position

## Examples

### Election Results

```julia
using StateBins, DataFrames, CairoMakie

# 2020 Presidential election results (example data)
election_data = DataFrame(
    state = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA"],
    margin = [-25.8, -10.1, 0.3, -27.7, 29.2, 13.5, 20.1, 19.0, -3.4, 0.2]
)

statebins_makie(election_data,
    state_col="state",
    value_col="margin", 
    title="2020 Presidential Election Margins",
    colorscheme=:RdBu,
    colorbar_label="Democratic Margin (%)")
```

### Economic Data

```julia
# State unemployment rates
unemployment = DataFrame(
    state = ["California", "Texas", "Florida", "New York", "Illinois"],
    rate = [4.2, 3.8, 3.1, 4.1, 4.9]
)

statebins_plots(unemployment,
    value_col="rate",
    title="State Unemployment Rates (%)")
```

## Requirements

- Julia ≥ 1.9
- DataFrames.jl ≥ 1.6
- Colors.jl ≥ 0.12  
- ColorSchemes.jl ≥ 3.24
- Plots.jl (for `statebins_plots`)
- A Makie.jl backend (CairoMakie, GLMakie, or WGLMakie for `statebins_makie`)

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This package is available under the MIT License.

## Acknowledgments

Inspired by the original statebins concept and similar implementations in R and Python.

# StateBins.jl

A Julia package for creating statebins (state binned choropleth maps) visualizations adapted from the R package statesbin (©2015 by Bob Rudis). StateBins provide an alternative to traditional geographic maps by representing each US state as an equally-sized square arranged in a grid that roughly approximates the geographic layout of the United States.

## Features

- **Two backend options**: Simple Plots.jl interface and full-featured Makie.jl interface
- **Automatic state detection**: Works with state names or abbreviations
- **Adaptive text coloring**: State labels automatically switch between light/dark for optimal contrast
- **Customizable styling**: Full control over colors, sizes, fonts, and layout (Makie backend)
- **Sensible defaults**: Works out-of-the-box with minimal configuration

## Installation

```julia
using Pkg
Pkg.add("StateBins")
```

## Quick Start

### Plots.jl Backend (Simple)

```julia
using StateBins, DataFrames, Plots

# Create sample data
data = DataFrame(
    state = ["California", "Texas", "Florida", "New York", "Pennsylvania"],
    population = [39.5, 29.7, 22.6, 19.3, 13.0]
)

# Create statebins plot
statebins_plots(data, 
    state_col="state", 
    value_col="population",
    title="State Population (millions)")
```

### Makie.jl Backend (Full-featured)

```julia
using StateBins, DataFrames, CairoMakie  # or GLMakie, WGLMakie

# Create sample data with state abbreviations
data = DataFrame(
    state = ["CA", "TX", "FL", "NY", "PA"],
    gdp = [3.6, 2.4, 1.1, 2.0, 0.9]
)

# Create customized statebins plot
statebins_makie(data,
    state_col="state",
    value_col="gdp", 
    title="State GDP (trillions USD)",
    colorscheme=:plasma,
    font_size=14,
    show_colorbar=true,
    colorbar_label="GDP ($ trillions)")
```

## API Reference

### `statebins_plots(data::DataFrame; kwargs...)`

Simple Plots.jl-based statebins with minimal customization options.

**Arguments:**
- `data::DataFrame`: Input data with state and value columns
- `state_col::String="state"`: Name of the state column (accepts state names or abbreviations)
- `value_col::String="value"`: Name of the value column  
- `title::String=""`: Plot title

### `statebins_makie(data::DataFrame; kwargs...)`

Flexible Makie-based statebins with extensive customization options.

**Arguments:**
- `data::DataFrame`: Input data with state and value columns
- `state_col::String="state"`: Name of the state column
- `value_col::String="value"`: Name of the value column
- `title::String=""`: Plot title
- `colorscheme=:viridis`: Color scheme for mapping values
- `font_size::Int=12`: Font size for state labels
- `marker_size::Real=35`: Size of state markers
- `margin_factor::Float64=0.3`: Margin around text as fraction of text size
- `auto_size::Bool=true`: Whether to automatically calculate marker size
- `show_labels::Bool=true`: Whether to show state abbreviations
- `show_colorbar::Bool=true`: Whether to show the colorbar
- `border_color="white"`: Color of marker borders
- `border_width::Real=2`: Width of marker borders
- `figure_size::Tuple=(800, 600)`: Figure dimensions
- `hide_decorations::Bool=true`: Whether to hide axis decorations
- `colorbar_label::String=""`: Label for the colorbar
- `text_color_threshold::Float64=0.179`: Luminance threshold for text color switching

### `STATE_COORDS`

A DataFrame containing the coordinate grid positions for all US states, DC, Puerto Rico, Virgin Islands, and New York City. Contains columns:
- `abbrev`: State abbreviations
- `state`: Full state names  
- `col`: Grid column position
- `row`: Grid row position

## Examples

### Election Results

```julia
using StateBins, DataFrames, CairoMakie

# 2020 Presidential election results (example data)
election_data = DataFrame(
    state = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA"],
    margin = [-25.8, -10.1, 0.3, -27.7, 29.2, 13.5, 20.1, 19.0, -3.4, 0.2]
)

statebins_makie(election_data,
    state_col="state",
    value_col="margin", 
    title="2020 Presidential Election Margins",
    colorscheme=:RdBu,
    colorbar_label="Democratic Margin (%)")
```

### Economic Data

```julia
# State unemployment rates
unemployment = DataFrame(
    state = ["California", "Texas", "Florida", "New York", "Illinois"],
    rate = [4.2, 3.8, 3.1, 4.1, 4.9]
)

statebins_plots(unemployment,
    value_col="rate",
    title="State Unemployment Rates (%)")
```

## Requirements

- Julia ≥ 1.9
- DataFrames.jl ≥ 1.6
- Colors.jl ≥ 0.12  
- ColorSchemes.jl ≥ 3.24
- Plots.jl (for `statebins_plots`)
- A Makie.jl backend (CairoMakie, GLMakie, or WGLMakie for `statebins_makie`)

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This package is available under the MIT License.

## Acknowledgments

Inspired by the original statebins concept and similar implementations in R and Python.