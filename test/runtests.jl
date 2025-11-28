using Test
using StateBins
using DataFrames
using Aqua

@testset "StateBins.jl Tests" begin
    
    @testset "State Coordinates" begin
        @test STATE_COORDS isa DataFrame
        @test nrow(STATE_COORDS) == 54  # 50 states + DC + PR + VI + NYC
        @test "abbrev" in names(STATE_COORDS)
        @test "state" in names(STATE_COORDS)
        @test "col" in names(STATE_COORDS)
        @test "row" in names(STATE_COORDS)
        
        # Test specific states
        @test "CA" in STATE_COORDS.abbrev
        @test "California" in STATE_COORDS.state
        @test "TX" in STATE_COORDS.abbrev
        @test "Texas" in STATE_COORDS.state
    end
    
    @testset "Data Validation" begin
        # Test data with state names
        data_names = DataFrame(
            state = ["California", "Texas", "Florida"],
            value = [100, 85, 70]
        )
        
        # Test data with abbreviations  
        data_abbrev = DataFrame(
            state = ["CA", "TX", "FL"],
            value = [100, 85, 70]
        )
        
        # Test invalid data
        data_invalid = DataFrame(
            state = ["InvalidState1", "InvalidState2"],
            value = [1, 2]
        )
        
        @test nrow(data_names) == 3
        @test nrow(data_abbrev) == 3
        @test nrow(data_invalid) == 2
    end
    
    @testset "Helper Functions" begin
        @test StateBins.calculate_marker_size(12, 0.3, :makie) isa Number
        @test StateBins.calculate_marker_size(12, 0.3, :unknown) isa Number
        
        # Test text color detection with proper Color objects
        using Colors
        @test StateBins.should_use_light_text(RGB(0, 0, 0)) == true    # black
        @test StateBins.should_use_light_text(RGB(1, 1, 1)) == false   # white
        @test StateBins.should_use_light_text("invalid") == false      # invalid input
    end
    
    @testset "Function Interfaces" begin
        # Create test data
        test_data = DataFrame(
            state = ["CA", "TX", "FL"],
            population = [39.5, 29.7, 22.6]
        )
        
        # Test that functions exist and accept basic parameters
        @test hasmethod(statebins, (DataFrame,))
        
        # Test error handling for missing columns
        invalid_data = DataFrame(x = [1, 2, 3], y = [4, 5, 6])
        @test_throws ErrorException statebins(invalid_data)
        
        # Test error handling for no matching states
        no_match_data = DataFrame(
            state = ["InvalidState1", "InvalidState2"],
            value = [1, 2]
        )
        @test_throws ErrorException statebins(no_match_data)
    end
    
    @testset "Aqua Quality Tests" begin
        Aqua.test_ambiguities(StateBins)
        Aqua.test_unbound_args(StateBins)
        Aqua.test_undefined_exports(StateBins)
        Aqua.test_project_extras(StateBins)
        Aqua.test_stale_deps(StateBins)
        Aqua.test_deps_compat(StateBins)
    end
end
