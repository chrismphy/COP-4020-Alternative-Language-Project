using Test
include("../src/CellModel.jl")

# Test for "oem" column

#@testset "OEM Column Tests" begin
#    @test isnothing(CellModel.oem("-")) # Test for handling missing OEM values
#    @test CellModel.oem("Samsung") == "Samsung" # Test for valid OEM values
#end

# Test for "model" column
#@testset "Model Column Tests" begin
#    @test isnothing(CellModel.model("-")) # Test for handling missing model values
#    @test CellModel.model("Galaxy S10") == "Galaxy S10" # Test for valid model values
#end

# Test for "launch_announced" column
@testset "Launch Announced Column Tests" begin
    @test CellModel.parse_launch_announced("2020") == 2020 # Test for valid year
    @test isnothing(CellModel.parse_launch_announced("V1")) # Test for invalid year format
end

# Test for "launch_status" column
@testset "Launch Status Column Tests" begin
    @test CellModel.parse_launch_status("Available") == "Available" # Test for valid status
    @test isnothing(CellModel.parse_launch_status("Unknown")) # Test for handling unknown status
end

# Test for "body_weight" column
@testset "Body Weight Column Tests" begin
    @test CellModel.parse_body_weight("190 g") ≈ 190.0 atol=1e-5 # Test for valid weight in grams
    @test isnothing(CellModel.parse_body_weight("0.85 kg")) # Test for weight not in grams
end

# Test for "body_sim" column
@testset "Body SIM Column Tests" begin
    @test isnothing(CellModel.parse_body_sim("No")) # Test for 'No' SIM value
    @test CellModel.parse_body_sim("Nano-SIM") == "Nano-SIM" # Test for valid SIM type
end

# Test for "display_size" column
@testset "Display Size Column Tests" begin
    @test CellModel.parse_display_size("6.1 inches") ≈ 6.1 atol=1e-5 # Test for valid display size
    @test isnothing(CellModel.parse_display_size("12")) # Test for missing unit in display size
end

# Test for "platform_os" column
@testset "Platform OS Column Tests" begin
    @test CellModel.parse_platform_os("Android 9.0 (Pie), upgradable to Android 10") == "Android 9.0 (Pie)" # Test for extracting OS up to first comma
    @test CellModel.parse_platform_os("iOS 13") == "iOS 13" # Test for full string when no comma present
end

# Test for "features_sensors" column
@testset "Features Sensors Column Tests" begin
    @test CellModel.parse_features_sensors("Accelerometer, gyro") == "Accelerometer, gyro" # Test for valid sensor features
    @test isnothing(CellModel.parse_features_sensors("12")) # Test for number-only sensor string
end

# Note: Since these tests rely on parsing functions within the CellModel module, ensure those functions
# (e.g., `oem`, `model`, `parse_launch_announced`) are correctly defined and exported.
