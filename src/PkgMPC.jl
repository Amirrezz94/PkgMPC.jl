module PkgMPC

# Write your package code here.
import Pkg
using Pkg; Pkg.add(Plots)

using Plots, CSV, JuMP, Ipopt, DataFrames, DifferentialEquations

include("Extra.jl")
include("main.jl")
include("NMPC.jl")
include("Plant.jl")


export F, Model_Par, Simulation_Data, Simulate_Plant
export Simulate_Plant, Plot_Plant, Save_Plant, Export_Plant

end
