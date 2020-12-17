include("Parameters.jl")
using DifferentialEquations



function Plant(xkold,ukold,dt, DataPlant)
    function Sgen(dx,x,p,t)
		model_par = DataPlant;
			x2_f  = model_par[:x2_f]
			km    = model_par[:km]
			k1    = model_par[:k1]
			Y     = model_par[:Y]
			μmax  = model_par[:μmax]
        μ = (μmax * x[2]) / (km + x[2] + k1 * x[2]^2);
        D = x[3];
        dx[1] = (μ - D) * x[1];
        dx[2] = (x2_f - x[2]) * D - (μ/Y) * x[1];
    end
    x0 = [xkold[1],xkold[2]]
    D0 = [ukold[1]]
    U0 = vcat(x0,D0)
    tspan = (0.0, dt)
    prob = ODEProblem(Sgen,U0,tspan)
    sol = DifferentialEquations.solve(prob, Tsit5())
    xf = sol.u[end][1:2];
return xf
end
