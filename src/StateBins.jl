module StateBins

using DataFrames, Colors, ColorSchemes

# State coordinate data
const STATE_COORDS = DataFrame(
    abbrev=["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI",
        "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN",
        "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH",
        "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
        "WV", "WI", "WY", "PR", "VI", "NYC"],
    state=["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
        "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia",
        "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
        "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
        "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
        "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota",
        "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
        "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
        "Washington", "West Virginia", "Wisconsin", "Wyoming", "Puerto Rico",
        "Virgin Islands", "New York City"],
    col=[8, 1, 3, 6, 2, 4, 11, 10, 11, 10, 9, 1, 3, 7, 7, 6, 5, 7, 6, 12, 10, 11,
        8, 6, 7, 6, 4, 5, 3, 12, 10, 4, 10, 8, 5, 8, 5, 2, 9, 12, 9, 5, 7, 5, 3,
        11, 9, 2, 8, 7, 4, 12, 12, 12],
    row=[7, 7, 6, 6, 5, 5, 4, 6, 5, 8, 7, 8, 3, 3, 4, 4, 6, 5, 7, 1, 5, 3, 3, 3,
        7, 5, 3, 5, 4, 2, 4, 6, 3, 6, 3, 4, 7, 4, 4, 4, 6, 4, 6, 8, 5, 2, 5, 3,
        5, 2, 4, 8, 7, 3]
)

function calculate_marker_size(font_size::Int, margin_factor::Float64, backend::Symbol)
    if backend == :plots
        text_width = 2 * 0.6 * font_size
        text_height = font_size
        required_width = text_width * (1 + 2 * margin_factor)
        required_height = text_height * (1 + 2 * margin_factor)
        result = max(20, max(required_width, required_height))
    elseif backend == :makie
        text_width = 2 * 0.7 * font_size
        text_height = font_size
        required_width = text_width * (1 + 2 * margin_factor)
        required_height = text_height * (1 + 2 * margin_factor)
        result = max(30, max(required_width, required_height))
    else
        result = 25
    end

    return result
end

function should_use_light_text(color)
    try
        if isa(color, Colors.Colorant)
            rgb = convert(Colors.RGB, color)
            r, g, b = rgb.r, rgb.g, rgb.b
        else
            return false
        end

        # WCAG relative luminance
        srgb_to_linear = x -> x <= 0.03928 ? x / 12.92 : ((x + 0.055) / 1.055)^2.4
        r_lin = srgb_to_linear(r)
        g_lin = srgb_to_linear(g)
        b_lin = srgb_to_linear(b)
        luminance = 0.2126 * r_lin + 0.7152 * g_lin + 0.0722 * b_lin

        return luminance < 0.179
    catch
        return false
    end
end

"""
    statebins_plots(data::DataFrame; state_col="state", value_col="value", title="")

Simple Plots.jl-based statebins with minimal customization options.
Uses sensible defaults optimized for quick visualization.

# Arguments
- `data::DataFrame`: Input data with state and value columns
- `state_col::String="state"`: Name of the state column (accepts state names or abbreviations)
- `value_col::String="value"`: Name of the value column
- `title::String=""`: Plot title

# Example
```julia
using Plots
data = DataFrame(state=["California", "Texas", "Florida"], value=[100, 85, 70])
statebins_plots(data, title="Population (millions)")
```
"""
function statebins_plots(data::DataFrame;
    state_col::String="state",
    value_col::String="value",
    title::String="")
    
    # Validate required columns
    if !(state_col in names(data)) || !(value_col in names(data))
        error("Required columns '$state_col' and/or '$value_col' not found")
    end

    # Determine merge strategy based on column content
    max_length = maximum(length.(string.(data[!, state_col])))
    merge_col = max_length <= 3 ? "abbrev" : "state"

    # Merge with coordinates
    merged_data = innerjoin(STATE_COORDS, data, on=(merge_col => state_col))
    
    if nrow(merged_data) == 0
        error("No valid states found in data")
    end

    # Extract data
    values = merged_data[!, value_col]
    cols = merged_data[!, :col]
    rows = -merged_data[!, :row]  # Flip y-axis for proper orientation

    # Fixed parameters optimized for readability
    marker_size = 25
    font_size = 10
    colorscheme = :viridis

    # Create base plot
    p = Main.Plots.scatter(cols, rows,
        marker=:square,
        markersize=marker_size,
        markerstrokecolor="white",
        markerstrokewidth=2,
        marker_z=values,
        color=colorscheme,
        aspect_ratio=:equal,
        grid=false,
        showaxis=false,
        title=title)

    # Add state abbreviation labels with adaptive text color
    colormap = ColorSchemes.colorschemes[colorscheme]
    normalized_values = (values .- minimum(values)) ./ (maximum(values) - minimum(values))

    for i in 1:nrow(merged_data)
        color_rgb = get(colormap, normalized_values[i])
        label_color = should_use_light_text(color_rgb) ? "white" : "black"
        Main.Plots.annotate!(p, cols[i], rows[i],
            Main.Plots.text(merged_data[i, :abbrev], font_size, :center, label_color))
    end

    return p
end

"""
    statebins_makie(data::DataFrame; kwargs...)

Flexible Makie-based statebins with extensive customization options.
All visual parameters can be overridden while maintaining sensible defaults.

# Arguments
- `data::DataFrame`: Input data with state and value columns
- `state_col::String="state"`: Name of the state column
- `value_col::String="value"`: Name of the value column
- `title::String=""`: Plot title
- `colorscheme=:viridis`: Color scheme for mapping values
- `font_size::Int=12`: Font size for state labels
- `marker_size::Real=35`: Size of state markers (ignored if auto_size=true)
- `margin_factor::Float64=0.3`: Margin around text as fraction of text size (used with auto_size)
- `auto_size::Bool=true`: Whether to automatically calculate marker size based on font_size and margin_factor
- `show_labels::Bool=true`: Whether to show state abbreviations
- `show_colorbar::Bool=true`: Whether to show the colorbar
- `border_color="white"`: Color of marker borders
- `border_width::Real=2`: Width of marker borders
- `figure_size::Tuple=(800, 600)`: Figure dimensions
- `hide_decorations::Bool=true`: Whether to hide axis decorations
- `colorbar_label::String=""`: Label for the colorbar (defaults to value_col)
- `text_color_threshold::Float64=0.179`: Luminance threshold for text color switching

# Example
```julia
using CairoMakie  # or GLMakie, WGLMakie
data = DataFrame(state=["CA", "TX", "FL"], value=[100, 85, 70])
statebins_makie(data, 
    title="Population (millions)",
    colorscheme=:plasma,
    font_size=14,
    margin_factor=0.4)
```
"""
function statebins_makie(data::DataFrame;
    state_col::String="state",
    value_col::String="value",
    title::String="",
    colorscheme=:viridis,
    font_size::Int=12,
    marker_size::Real=35,
    margin_factor::Float64=0.3,
    auto_size::Bool=true,
    show_labels::Bool=true,
    show_colorbar::Bool=true,
    border_color="white",
    border_width::Real=2,
    figure_size::Tuple=(800, 600),
    hide_decorations::Bool=true,
    colorbar_label::String="",
    text_color_threshold::Float64=0.179,
    kwargs...)

    # Determine which Makie backend is loaded
    makie_module = if isdefined(Main, :GLMakie)
        Main.GLMakie
    elseif isdefined(Main, :CairoMakie)
        Main.CairoMakie
    elseif isdefined(Main, :WGLMakie)
        Main.WGLMakie
    else
        error("No Makie backend found. Load GLMakie, CairoMakie, or WGLMakie first.")
    end

    # Validate required columns
    if !(state_col in names(data)) || !(value_col in names(data))
        error("Required columns '$state_col' and/or '$value_col' not found")
    end

    # Determine merge strategy based on column content
    max_length = maximum(length.(string.(data[!, state_col])))
    merge_col = max_length <= 3 ? "abbrev" : "state"

    # Merge with coordinates
    merged_data = innerjoin(STATE_COORDS, data, on=(merge_col => state_col))
    
    if nrow(merged_data) == 0
        error("No valid states found in data")
    end
    
    # Extract plotting data
    values = merged_data[!, value_col]
    cols = merged_data[!, :col]
    rows = -merged_data[!, :row]  # Flip y-axis for proper orientation

    # Create figure and axis
    fig = makie_module.Figure(size=figure_size; kwargs...)
    ax = makie_module.Axis(fig[1, 1],
        title=title,
        aspect=makie_module.DataAspect())

    if hide_decorations
        makie_module.hidedecorations!(ax)
        makie_module.hidespines!(ax)
    end

    # Create scatter plot
    scatter_plot = makie_module.scatter!(ax, cols, rows,
        markersize=marker_size,
        marker=:rect,
        color=values,
        colormap=colorscheme,
        strokecolor=border_color,
        strokewidth=border_width)

    # Add colorbar if requested
    if show_colorbar
        cb_label = isempty(colorbar_label) ? value_col : colorbar_label
        makie_module.Colorbar(fig[1, 2], scatter_plot, label=cb_label)
    end

    # Add state labels with adaptive text color
    if show_labels
        colormap_obj = ColorSchemes.colorschemes[colorscheme]
        normalized_values = (values .- minimum(values)) ./ (maximum(values) - minimum(values))

        for i in 1:nrow(merged_data)
            color_rgb = get(colormap_obj, normalized_values[i])
            
            # Custom threshold for text color decision
            rgb = convert(Colors.RGB, color_rgb)
            r, g, b = rgb.r, rgb.g, rgb.b
            srgb_to_linear = x -> x <= 0.03928 ? x / 12.92 : ((x + 0.055) / 1.055)^2.4
            r_lin = srgb_to_linear(r)
            g_lin = srgb_to_linear(g)
            b_lin = srgb_to_linear(b)
            luminance = 0.2126 * r_lin + 0.7152 * g_lin + 0.0722 * b_lin
            
            label_color = luminance < text_color_threshold ? "white" : "black"
            
            makie_module.text!(ax, cols[i], rows[i],
                text=merged_data[i, :abbrev],
                align=(:center, :center),
                fontsize=font_size,
                color=label_color)
        end
    end

    return fig
end

export statebins_plots, statebins_makie, STATE_COORDS

end # module StateBins