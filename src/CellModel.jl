module CellModel
using DataFrames
export Cell

mutable struct Cell
    
    oem::Union{String, Nothing} #oem variable can be either type string or nothing
    model::Union{String, Nothing}
    launch_announced::Union{Int, String, Nothing} 
    launch_status::Union{Int,String, Nothing}
    body_dimensions::Union{String, Nothing}
    body_weight::Union{Float64, Nothing}
    body_sim::Union{String, Nothing}
    display_type::Union{String, Nothing}
    display_size::Union{Float64, Nothing}
    display_resolution::Union{String, Nothing}
    features_sensors::Union{String, Nothing}
    platform_os::Union{String, Nothing}
    # Cell Structure checks and replaces missing or '-' with nothing 
    function Cell(row::DataFrameRow)
        new(
            default_parser(get(row, :oem, nothing)), #retrieve value from row oem, default/ missing values are set to nothing 
            default_parser(get(row, :model, nothing)),
            parse_launch_announced(default_parser(get(row, :launch_announced, nothing))),
            parse_launch_status(default_parser(get(row, :launch_status, nothing))),
            default_parser(get(row, :body_dimensions, nothing)),
            parse_body_weight(default_parser(get(row, :body_weight, nothing))),
            parse_body_sim(default_parser(get(row, :body_sim, nothing))),
            default_parser(get(row, :display_type, nothing)),
            parse_display_size(default_parser(get(row, :display_size, nothing))),
            default_parser(get(row, :display_resolution, nothing)),
            parse_features_sensors(default_parser(get(row, :features_sensors, nothing))),
            parse_platform_os(default_parser(get(row, :platform_os, nothing)))
        )
    end
end

function default_parser(value::Union{AbstractString, Missing})
    if ismissing(value) || value == "-" || value == ""
        return nothing
    else
        return value
    end
end

function parse_launch_announced(launch_str::Union{String, Missing, Nothing})
    if ismissing(launch_str) || isnothing(launch_str)
        return nothing
    else 
        match_result = match(r"\b(\d{4})\b", launch_str)
        return isnothing(match_result) ? nothing : parse(Int, match_result.match) #return as int
    end
end

function parse_launch_status(status_str::Union{String, Missing, Nothing})
    if ismissing(status_str) || isnothing(status_str) || status_str == "" || status_str == "-"
        return nothing
    elseif status_str == "Discontinued" || status_str == "Cancelled"
        return status_str
    # If the status contains a year, return the year as string
    else
        match_result = match(r"\b(\d{4})\b", status_str)
        return isnothing(match_result) ? status_str : parse(Int, match_result.match)
    end
end

function parse_body_weight(weight_str::Union{String, Missing, Nothing})
    if ismissing(weight_str) || isnothing(weight_str)
        return nothing
    end
    match_result = match(r"(\d+(\.\d+)?)\s*g", weight_str)
    return isnothing(match_result) ? nothing : parse(Float64, match_result.captures[1])
end

function parse_body_sim(sim_str::Union{String, Missing, Nothing})
    if ismissing(sim_str)  || sim_str == ""
        println("Missing value encountered for body_sim")
        return nothing
    elseif isnothing(sim_str) || sim_str == "No" || sim_str == "Yes"
        return nothing
    else
        return sim_str
    end
end

function parse_display_size(size_str::Union{String, Missing, Nothing})
    if ismissing(size_str) || isnothing(size_str) || size_str == ""
        return nothing
    end

    match_result = match(r"(\d+(\.\d+)?)\s*inches", size_str) #match only float or inch with inches after value
    return isnothing(match_result) ? nothing : parse(Float64, match_result.captures[1])
end

function parse_features_sensors(sensor_str::Union{String, Missing, Nothing})
    if ismissing(sensor_str) || isnothing(sensor_str) || sensor_str == ""
        return nothing
    end

    # Check if the string contains only numbers (integer or decimal)
    is_numeric_only = occursin(r"^\d+(\.\d+)?$", sensor_str) #^ indicates beginning, $ indicates end

    return is_numeric_only ? nothing : sensor_str
end

function parse_platform_os(os_str::Union{String, Missing, Nothing})
    # Check if the input is missing, nothing, or empty
    if ismissing(os_str) || isnothing(os_str) || os_str == ""
        return nothing
    end

    # Check if the string looks like a version number followed by anything else
    is_version_like = occursin(r"^\d+(\.\d+)?,.*$", os_str)
    if is_version_like
        return nothing
    end
    if occursin(r"^\d+(\.\d+)?$", os_str)
        return nothing
    end
    # Extract everything up to the first comma if present
    comma_index = findfirst(',', os_str)
    return isnothing(comma_index) ? os_str : strip(os_str[1:comma_index - 1])
end




end 

