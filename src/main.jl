
include("Plant.jl")
include("NMPC.jl")
include("Parameters.jl")
using Plots

## Defining Simulation Parameters



## Options for plotting, saving the figure and Eporting the data
#Plotting    = false;
#Fig_Save    = false;
#Export_Vars = false;

## Simulation of the plant
function Simulate_Plant(Data_MPC, Data_Plant)

    #sim_par = Data_MPC;
        T0_sim  = Data_MPC[:T0_sim]
        Tf_sim  = Data_MPC[:Tf_sim]
        dt_sim  = Data_MPC[:dt_sim]
        Tf_MPC  = Data_MPC[:Tf_MPC]
        dt_MPC  = Data_MPC[:dt_MPC]
        NCP     = Data_MPC[:NCP]
        NFE_sim = Data_MPC[:NFE_sim]
        NFE_MPC = Data_MPC[:NFE_MPC]
        uk      = Data_MPC[:uk]
        xₛₚ     = Data_MPC[:xₛₚ]
        xk      = Data_MPC[:xk]
        U_Plot = [];
        X1_Plot = [];
        X2_Plot = [];

        # push the starting point into the final vectors
        push!(U_Plot, uk[1])
        push!(X1_Plot, xk[1])
        push!(X2_Plot, xk[2])
        global dt_sim, uk, xk


    println("Start Simulation!")
    for k in 1:NFE_sim
        global xk, uk, dt_sim
        xₛₚ_MPC = xₛₚ[k:k - 1 + NFE_MPC]
        uk = Solve_MPC(xk, uk, xₛₚ_MPC,NFE_MPC, NCP, Data_Plant)
        xk = Plant(xk, uk, dt_sim, Data_Plant);
        push!(U_Plot, uk[1])
        push!(X1_Plot, xk[1])
        push!(X2_Plot, xk[2])
    end
    println("The objective function is satisfied successfully!")
    myDict = Dict(
        :X1_Plot   => X1_Plot,
        :X2_Plot     => X2_Plot,
        :U_Plot     => U_Plot
    )
    return myDict
end

## Plotting with the option to show/not show the figure. Also different backends can be choose!
function Plot_Plant(MPC_Results, Data_MPC)
    T0_sim  = Data_MPC[:T0_sim];
    dt_sim  = Data_MPC[:dt_sim];
    Tf_sim  = Data_MPC[:Tf_sim];
    NFE_sim = Data_MPC[:NFE_sim];
    xₛₚ     = Data_MPC[:xₛₚ];
    X1_Plot = MPC_Results[:X1_Plot];
    X2_Plot = MPC_Results[:X2_Plot];
    U_Plot  = MPC_Results[:U_Plot];
    t_plot = collect(T0_sim:dt_sim:Tf_sim)
    p11 = plot( t_plot,[X1_Plot[nIter]  for nIter in 1:NFE_sim+1],label="x1")
    p11 = plot!(t_plot,[X2_Plot[nIter]  for nIter in 1:NFE_sim+1],label="x2")
    p11 = plot!(t_plot, xₛₚ[1:NFE_sim + 1],                       label="y_sp", linetype=:steppost, linestyle=:dash)
    p12 = plot(t_plot[1:end], [U_Plot[nIter]  for nIter in 1:NFE_sim+1],    label="u",              linetype=:steppost)
    fig1 = plot(p11, p12, layout=(2, 1));
    plotlyjs()
    #gr()
    println("Start Plotting!")
    display(fig1)
    println("Finish Plotting!")
    return fig1
end

##Checking the Option for saving
function Save_Plant(fig1, Address)
    savefig(fig1, Address)
end
## Exporting Data


function Export_Plant(MPC_Results, Data_MPC, Address)
    X1_Plot = MPC_Results[:X1_Plot];
    X2_Plot = MPC_Results[:X2_Plot];
    U_Plot  = MPC_Results[:U_Plot];
    xₛₚ     = Data_MPC[:xₛₚ];
    NFE_sim = Data_MPC[:NFE_sim];
    T0_sim  = Data_MPC[:T0_sim];
    dt_sim  = Data_MPC[:dt_sim];
    Tf_sim  = Data_MPC[:Tf_sim];
    t_plot  = collect(T0_sim:dt_sim:Tf_sim);
    println("Start Exporting Data!")
    #using CSV
    #using DataFrames
    df = DataFrame(Name = ["x1","x2","U","SetPoint","Time"],
                   Value = [X1_Plot, X2_Plot, U_Plot, xₛₚ[1:NFE_sim+1], t_plot]
                   )
    CSV.write(Address, df)
    println("Finish Exporting Data!")
end
