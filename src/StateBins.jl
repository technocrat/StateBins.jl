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
    statebins_plots(data::DataFrame; kwargs...)

Create a statebins plot using the Plots.jl backend.
Requires `using Plots` to be loaded.
"""
function statebins_plots(args...; kwargs...)
    error("The Plots backend is not loaded. Please run `using Plots` to enable this functionality.")
end

"""
    statebins_makie(data::DataFrame; kwargs...)

Create a statebins plot using a Makie.jl backend.
Requires a Makie backend (e.g., `using CairoMakie`) to be loaded.
"""
function statebins_makie(args...; kwargs...)
    error("The Makie backend is not loaded. Please run `using CairoMakie` (or GLMakie/WGLMakie) to enable this functionality.")
end

export statebins_plots, statebins_makie, STATE_COORDS

end # module StateBins