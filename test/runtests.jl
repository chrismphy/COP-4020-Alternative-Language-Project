using Test
include("../src/CellModel.jl")
 

@testset "default_parser Tests" begin
    #Test for '-' or empty "" values
    @test CellModel.default_parser("Samsung") == "Samsung"
    @test isnothing(CellModel.default_parser("-"))
    @test isnothing(CellModel.default_parser(""))
    @test CellModel.default_parser("123") == "123"
    @test CellModel.default_parser("N/A") == "N/A"
end
 
@testset "parse_launch_announced Tests" begin

    @test CellModel.parse_launch_announced("2020") == 2020
    #Test a string with year inside string
    @test CellModel.parse_launch_announced("Announced in 1998") == 1998
    # Test a string without a year
    @test isnothing(CellModel.parse_launch_announced("No year"))
    # Test a clearly invalid year format
    @test isnothing(CellModel.parse_launch_announced("Year ninety-eight"))
    # Test a missing value
    @test isnothing(CellModel.parse_launch_announced(missing))
    @test isnothing(CellModel.parse_launch_announced(""))
    @test isnothing(CellModel.parse_launch_announced("-"))
end


@testset "parse_launch_status Tests" begin
    # Test higly expected keywords
    @test CellModel.parse_launch_status("Discontinued") == "Discontinued"
    @test CellModel.parse_launch_status("Cancelled") == "Cancelled"

    @test CellModel.parse_launch_status("2020") == 2020
    @test CellModel.parse_launch_status("Expected in 2022") == 2022
    @test CellModel.parse_launch_status("No date") == "No date"
    @test CellModel.parse_launch_status("Year ninety-eight") == "Year ninety-eight"
    # Test with a missing/empty/'-' value
    @test isnothing(CellModel.parse_launch_status(missing))
    @test isnothing(CellModel.parse_launch_status(""))
    @test isnothing(CellModel.parse_launch_status("-"))
end

@testset "parse_body_weight Tests" begin
    # Test valid weights
    @test CellModel.parse_body_weight("190 g") ≈ 190.0 atol=1e-5
    @test CellModel.parse_body_weight("123.45 g") ≈ 123.45 atol=1e-5
    @test CellModel.parse_body_weight("190 g additional text") ≈ 190.0 atol=1e-5
    # Test for a string with no unit
    @test isnothing(CellModel.parse_body_weight("123"))
    # Test for an empty/missing/'-' string
    @test isnothing(CellModel.parse_body_weight(""))
    @test isnothing(CellModel.parse_body_weight("-"))
    @test isnothing(CellModel.parse_body_weight("abc g"))
    @test isnothing(CellModel.parse_body_weight(missing))
end


@testset "parse_body_sim Tests" begin
    # Test for a valid SIM type value
    @test CellModel.parse_body_sim("Nano-SIM") == "Nano-SIM"
    # Test for the No or Yes SIM value which should return nothing
    @test isnothing(CellModel.parse_body_sim("No"))
    @test isnothing(CellModel.parse_body_sim("Yes"))
    # Test for an empty or missing string which should return nothing
    @test isnothing(CellModel.parse_body_sim(""))
    @test isnothing(CellModel.parse_body_sim(missing))
    
end

@testset "Display Size Column Tests" begin
    # Test for valid display size
    @test CellModel.parse_display_size("6.1 inches") ≈ 6.1 atol=1e-5
    @test CellModel.parse_display_size("5 inches") ≈ 5.0 atol=1e-5
    # Test for missing unit
    @test isnothing(CellModel.parse_display_size("12"))
    #Test for empty/missing values 
    @test isnothing(CellModel.parse_display_size(""))
    @test isnothing(CellModel.parse_display_size(missing))
    # Test for unexpected format
    @test isnothing(CellModel.parse_display_size("6.1"))
    @test isnothing(CellModel.parse_display_size("inches 6.1")) #Should output nothing
    @test isnothing(CellModel.parse_display_size("6.1inch"))
end

@testset "Features Sensors Column Tests" begin
    # Test for valid string
    @test CellModel.parse_features_sensors("Accelerometer V1") == "Accelerometer V1"
    @test CellModel.parse_features_sensors("V1") == "V1"
    # Test for only an int/float 
    @test isnothing(CellModel.parse_features_sensors("12345"))
    @test isnothing(CellModel.parse_features_sensors("20.1"))
    # Test for empty/mising/nothing string
    @test isnothing(CellModel.parse_features_sensors(""))
    @test isnothing(CellModel.parse_features_sensors(missing))
    @test isnothing(CellModel.parse_features_sensors(nothing))
end

@testset "Platform OS Column Tests" begin
    # Test for missing/empty string
    @test isnothing(CellModel.parse_platform_os(missing))
    @test isnothing(CellModel.parse_platform_os(""))
    # Test for string with only integer/float value
    @test isnothing(CellModel.parse_platform_os("12345"))
    @test isnothing(CellModel.parse_platform_os("123.45"))
    # Test for comma delineation
    @test CellModel.parse_platform_os("Android 9.0 (Pie), upgradable to Android 10") == "Android 9.0 (Pie)"
    @test CellModel.parse_platform_os("iOS 13") == "iOS 13"
    # Test for string that is only a number with comma delineation
    @test isnothing(CellModel.parse_platform_os("9.0, upgradable to 10"))
end
