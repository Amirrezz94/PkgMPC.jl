module PkgMPC

# Write your package code here.
import Plots
import CSV
import JuMP
import Ipopt
import DataFrames
import DifferentialEquations
import PlotlyJS

#=
using Reexport

@reexport using Plots
@reexport using CSV
@reexport using JuMP
@reexport using Ipopt
@reexport using DataFrames
@reexport using DifferentialEquations
@reexport using PlotlyJS
=#

#using Plots, CSV, JuMP, Ipopt, DataFrames, DifferentialEquations, PlotlyJS

include("Extra.jl")
include("main.jl")
include("NMPC.jl")
include("Plant.jl")


export F, Model_Par, Simulation_Data, Simulate_Plant
export Simulate_Plant, Plot_Plant, Save_Plant, Export_Plant

end
