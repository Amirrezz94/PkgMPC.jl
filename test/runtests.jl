using PkgMPC
using Test




F(3,5)

##For Testing
Data_MPC   = Simulation_Data(60.0, 8.0, 3, [1.0; 1.0], 0.35)
Data_Plant = Model_Par(4.0, 0.12, 0.4545, 0.4, 0.4)
Results = Simulate_Plant(Data_MPC, Data_Plant)
Figure = Plot_Plant(Results, Data_MPC)
Save_Plant(Figure,"//home//amir//Documents//Package_Results//MPC_Results.svg")
Export_Plant(Results,Data_MPC, "//home//amir//Documents//Package_Results//MPC_Results.csv")
##for timing
Data_MPC   = @elapsed Simulation_Data(60.0, 8.0, 3, [1.0; 1.0], 0.35)
Data_Plant = @elapsed Model_Par(4.0, 0.12, 0.4545, 0.4, 0.4)
result = @elapsed Simulate_Plant(Data_MPC, Data_Plant)
Figure = @elapsed Plot_Plant(Results, Data_MPC)
time_save = @elapsed Save_Plant(Figure,"//home//amir//Documents//Package_Results//MPC_Results.svg")
time_export = @elapsed Export_Plant(Results,Data_MPC, "//home//amir//Documents//Package_Results//MPC_Results.csv")



@testset "PkgMPC.jl" begin
    # Write your tests here.
    @test F(2,3) == 13
    @test F(3,0) == 6
end
