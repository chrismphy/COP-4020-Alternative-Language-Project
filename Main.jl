

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
using .CellModel: Cell

using CSV, DataFrames, Dates
# Assume using .CellModel is now unnecessary since we're in the same file/module context

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
 
for i in 1:min(length(cells),100)
     cell=cells[i]
     println()
#    println("OEM: ", cell.oem)
#    println("Model: ", cell.model)
#    println("launch_announced: ",cell.launch_announced,", type: ",typeof(cell.launch_announced)) #Returns only type Int64
#    println("launch_status: ", cell.launch_status, ", type: ", typeof(cell.launch_status)) #discontinued/cancelled is of type string
#    println("body_dimensions: ", cell.body_dimensions) 
#    println("body weight: ",cell.body_weight,", type: ", typeof(cell.body_weight)) #output float64
#    println("body sim: ", cell.body_sim) #yes/no passed as nothing
#    println("display_type: ", cell.display_type)
#    println("display_size: ", cell.display_size, ", type: ", typeof(cell.display_size)) #r"(\d+(\.\d+)?)\s*inches
#    println("display_resolution: ",cell.display_resolution) #no changes needed
#    println("features_sensors: ",cell.features_sensors) # occursin(r"^\d+(\.\d+)?$", sensor_str)
#     println("platform_os: ",cell.platform_os)
     println()
end

println("Starting test: ")
# Include and run tests
try
 
    include("test/runtests.jl")
catch e
    show(e)
end
