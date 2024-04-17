

#=
JuliaProject/
│
├── src/
│   ├── CellModel.jl
└── test/
    └── runtests.jl
│
Main.jl
=#

#Julia requires the module name to match the filename for the automatic inclusion of modules.
# Main.jl

# Include CellModel.jl for cell structure and parsing logic
include("src/CellModel.jl")
using .CellModel: Cell, parse_launch_announced, parse_launch_status


using CSV, DataFrames, Statistics
 
# Function to check if the CSV file is not empty
function check_file_not_empty(filepath::String)
    if filesize(filepath) > 0
        println("The CSV file is not empty.")
    else
        error("The CSV file is empty.")
    end
end

# Function to load and process data from CSV
function load_and_process_data(filepath::String)
    df = CSV.read(filepath, DataFrame)
    cells = [Cell(row) for row in eachrow(df)]  # Cell comes from CellModel
    return cells
end

# Path to the uploaded CSV file
filepath = "cells.csv"

# Check if the file is not empty
check_file_not_empty(filepath)

# Load and process the data
cells = load_and_process_data(filepath)
#Unofficial test
#=
for i in 1:min(length(cells),100)
     cell=cells[i]
     println()
     println("OEM: ", cell.oem)
     println("Model: ", cell.model)
     println("launch_announced: ",cell.launch_announced,", type: ",typeof(cell.launch_announced)) #Returns only type Int64
     println("launch_status: ", cell.launch_status, ", type: ", typeof(cell.launch_status)) #discontinued/cancelled is of type string
     println("body_dimensions: ", cell.body_dimensions) 
     println("body weight: ",cell.body_weight,", type: ", typeof(cell.body_weight)) #output float64
     println("body sim: ", cell.body_sim) #yes/no passed as nothing
     println("display_type: ", cell.display_type)
     println("display_size: ", cell.display_size, ", type: ", typeof(cell.display_size)) #r"(\d+(\.\d+)?)\s*inches
     println("display_resolution: ",cell.display_resolution) #no changes needed
     println("features_sensors: ",cell.features_sensors) # occursin(r"^\d+(\.\d+)?$", sensor_str)
     println("platform_os: ",cell.platform_os)
     println()
#end
=#
println("Starting test: ")
# Include and run tests
try
 
    include("test/runtests.jl")
catch e
    show(e)
end

println()

function highest_average_weight(cells::Vector{Cell})
    weights = Dict{String, Vector{Float64}}()

    for cell in cells
        if isnothing(cell.oem) || isnothing(cell.body_weight)
            continue
        end

        if haskey(weights, cell.oem)
            push!(weights[cell.oem], cell.body_weight)
        else
            weights[cell.oem] = [cell.body_weight]
        end
    end

    averages = [(oem, mean(weights[oem])) for oem in keys(weights)]
    sort!(averages, by = x -> x[2], rev = true)
    
    return averages[1]
end

function count_single_feature_sensor(cells::Vector{Cell})
    count = 0

    for cell in cells
        if !isnothing(cell.features_sensors) && count_ones(cell.features_sensors) == 1
            count += 1
        end
    end

    return count
end

function count_ones(sensor_str::String)
    return length(split(sensor_str, ","))
end

function most_phones_launched_post_1999(cells::Vector{Cell})
    year_counts = Dict{Int, Int}()

    for cell in cells
        if isa(cell.launch_announced, Int) && cell.launch_announced > 1999
            year_counts[cell.launch_announced] = get(year_counts, cell.launch_announced, 0) + 1
        end
    end

    sorted_years = sort(collect(year_counts), by = x -> x[2], rev = true)
    return sorted_years[1]
end

function most_phones_launched_post_1999(cells::Vector{Cell})
    year_counts = Dict{Int, Int}()

    for cell in cells
        if isa(cell.launch_announced, Int) && cell.launch_announced > 1999
            year_counts[cell.launch_announced] = get(year_counts, cell.launch_announced, 0) + 1
        end
    end

    sorted_years = sort(collect(year_counts), by = x -> x[2], rev = true)
    return sorted_years[1]
end

function find_announced_released_year_difference(cells::Vector{Cell})
    for cell in cells
            announced_year = isa(cell.launch_announced, String) ? nothing : cell.launch_announced #string -> nothing or null
            released_year = isa(cell.launch_status, String) ? nothing : cell.launch_status

        if !isnothing(announced_year) && !isnothing(released_year) && announced_year != released_year
            println("OEM: ", cell.oem, ", Model: ", cell.model, ", Announced: ", announced_year, ", Released: ", released_year)
        end
    end
end
println()

println("What company (oem) has the highest average weight of the phone body?")
println(highest_average_weight(cells))

println("Was there any phones that were announced in one year and released in another? What are they? Give me the oem and models.")
find_announced_released_year_difference(cells)

println("How many phones have only one feature sensor?")
println(count_single_feature_sensor(cells))


println("What year had the most phones launched in any year later than 1999?")
println(most_phones_launched_post_1999(cells))