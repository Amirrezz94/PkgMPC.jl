#This is the place tu put all the variables needed for the project
#All the variable will be sent from here to required places in the programme

##Parameters which are needed for setting up the plant and Differential Equations
function Model_Par(m1,m2,m3,m4,m5)
    myDict = Dict(
        :x2_f   => m1,
        :km     => m2,
        :k1     => m3,
        :Y      => m4,
        :μmax   => m5
    )
    return myDict
end

## Parameters which are needed to set up the simulation of the plant.

function Simulation_Data(Tfsim, TfMPC, Ncp, states, inputs)
    T0_sim  = 0.0;
    Tf_sim  = Tfsim;
    dt_sim  = 1;
    Tf_MPC  = TfMPC;
    dt_MPC  = 1;
    NCP     = Ncp;
    xk      = states;
    uk      = inputs;

    NFE_sim = convert(Int, (Tf_sim - T0_sim) / dt_sim);
    NFE_MPC = convert(Int, (Tf_MPC) / dt_MPC);
    xₛₚ     = hcat(1.5032 * ones(1, convert(Int, NFE_sim / 3)),     0.9951 * ones(1,convert(Int, NFE_sim / 3)),    0 * ones(1,convert(Int, NFE_sim / 3)), 0 * ones(1,convert(Int, NFE_MPC)));
    myDict = Dict(
        :T0_sim  => T0_sim,
        :Tf_sim  => Tf_sim,
        :dt_sim  => dt_sim,
        :Tf_MPC  => Tf_MPC,
        :dt_MPC  => dt_MPC,
        :NCP     => NCP,
        :NFE_sim => NFE_sim,
        :NFE_MPC => NFE_MPC,
        :xₛₚ     => xₛₚ,
        :xk      => xk,
        :uk      => uk
    )
    return myDict
end
