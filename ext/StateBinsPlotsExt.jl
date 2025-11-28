module StateBinsPlotsExt

using StateBins
using Plots
using DataFrames
using Colors
using ColorSchemes

"""
    statebins_plots(data::DataFrame; state_col="state", value_col="value", title="")

Simple Plots.jl-based statebins with minimal customization options.
Uses sensible defaults optimized for quick visualization.
"""
function StateBins.statebins_plots(data::DataFrame;
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
    p = Plots.scatter(cols, rows,
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
        # We need to access the internal helper function or duplicate logic
        # Since it's not exported, we can use StateBins.should_use_light_text
        # But it's not exported. Let's assume we can access it via module or duplicate.
        # Ideally, StateBins should export helpers or we use internals.
        # Let's use StateBins.should_use_light_text assuming it's available internally to the module
        # or we need to make it public/internal.
        # Actually, since we are in an extension of StateBins, we can access internals if we import them or use fully qualified names?
        # No, extensions are separate modules. We need to rely on what's available.
        # I'll check if I can access StateBins.should_use_light_text.
        # It's not exported. I should probably export it or make it public API if I want to use it here.
        # Or I can just duplicate the small logic or use `parentmodule(StateBins).should_use_light_text`?
        # The cleanest way is to use `StateBins.should_use_light_text` if it's defined in the parent module, 
        # but since it's not exported, I have to use `StateBins.should_use_light_text` explicitly.
        # However, since I am `using StateBins`, I can access exported symbols.
        # Non-exported symbols can be accessed via `StateBins.symbol`.
        
        label_color = StateBins.should_use_light_text(color_rgb) ? "white" : "black"
        Plots.annotate!(p, cols[i], rows[i],
            Plots.text(merged_data[i, :abbrev], font_size, :center, label_color))
    end

    return p
end

end # module
