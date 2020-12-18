module PkgMPC

# Write your package code here.
using Reexport
@reexport using Plots
@reexport using CSV
@reexport using JuMP
@reexport using Ipopt
@reexport using DataFrames
@reexport using DifferentialEquations
@reexport using PlotlyJS

include("Extra.jl")
include("main.jl")
include("NMPC.jl")
include("Plant.jl")


export F, Model_Par, Simulation_Data, Simulate_Plant
export Simulate_Plant, Plot_Plant, Save_Plant, Export_Plant

end
