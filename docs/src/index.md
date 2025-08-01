# StateBins.jl

A Julia package for creating statebins (state binned choropleth maps) visualizations.

## Overview

StateBins provide an alternative to traditional geographic maps by representing each US state as an equally-sized square arranged in a grid that roughly approximates the geographic layout of the United States. This approach offers several advantages:

- **Equal visual weight**: Each state gets the same visual space regardless of geographic size
- **Clear comparison**: Values across states are easier to compare without geographic distortion
- **Compact layout**: Fits well in presentations and reports

## Quick Example

```julia
using StateBins, DataFrames, Plots

data = DataFrame(
    state = ["CA", "TX", "FL", "NY", "PA"],
    value = [39.5, 29.7, 22.6, 19.3, 13.0]
)

statebins_plots(data, title="State Population (millions)")
```

## Features

- Two backend options: Simple Plots.jl interface and full-featured Makie.jl interface
- Automatic state detection: Works with state names or abbreviations  
- Adaptive text coloring: State labels automatically adjust for optimal contrast
- Customizable styling: Full control over colors, sizes, fonts, and layout
- Sensible defaults: Works out-of-the-box with minimal configuration

See the [API Reference](api.md) for detailed documentation of all functions.