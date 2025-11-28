module StateBinsMakieExt

using StateBins
using Makie
using DataFrames
using Colors
using ColorSchemes

"""
    statebins_makie(data::DataFrame; kwargs...)

Flexible Makie-based statebins with extensive customization options.
All visual parameters can be overridden while maintaining sensible defaults.
"""
function StateBins.statebins_makie(data::DataFrame;
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
    fig = Figure(size=figure_size; kwargs...)
    ax = Axis(fig[1, 1],
        title=title,
        aspect=DataAspect())

    if hide_decorations
        hidedecorations!(ax)
        hidespines!(ax)
    end

    # Create scatter plot
    scatter_plot = scatter!(ax, cols, rows,
        markersize=marker_size,
        marker=:rect,
        color=values,
        colormap=colorscheme,
        strokecolor=border_color,
        strokewidth=border_width)

    # Add colorbar if requested
    if show_colorbar
        cb_label = isempty(colorbar_label) ? value_col : colorbar_label
        Colorbar(fig[1, 2], scatter_plot, label=cb_label)
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
            
            text!(ax, cols[i], rows[i],
                text=merged_data[i, :abbrev],
                align=(:center, :center),
                fontsize=font_size,
                color=label_color)
        end
    end

    return fig
end

end # module
