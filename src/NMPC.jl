using Ipopt, JuMP

include("CollMat.jl")


function Solve_MPC(x0, u0, x_sp, NFE, NCP, DataMPC)

m1 = Model(Ipopt.Optimizer)
Nx  = size(x0, 1);
Nu  = size(u0, 1);
dx0 = 0*copy(x0)
q0  = 0;
dq0 = 0;

model_par = DataMPC
    sf  = model_par[:x2_f]
    km    = model_par[:km]
    k1    = model_par[:k1]
    Y     = model_par[:Y]
    μmax = model_par[:μmax]

M = Collocation_Matrix(NCP)

##Defining the variables for the whole NFE_MPC horizon
@variable(m1, x[1:Nx, 1:NFE, 1:NCP+1]);
@variable(m1, dx[1:Nx, 1:NFE, 1:NCP]);
@variable(m1,  q[   1,       1:NFE, 1:NCP])
@variable(m1, dq[   1,       1:NFE, 1:NCP])
@variable(m1, u[1:Nu, 1:NFE])
##Setting up the bounds for variables (in case of need)
for nx in 1:Nx, nu in 1:Nu, nfe in 1:NFE, ncp in 1:NCP
    set_lower_bound(x[nx, nfe, ncp], 0)
    set_upper_bound(x[1 , nfe, ncp], 4.5)
    #set_lower_bound(dx[nx, nfe, ncp], 0)
    #set_upper_bound(dx[nx, nfe, ncp], 999)
    set_lower_bound(u[nu, nfe], 0)
    set_upper_bound(u[nu, nfe], 1)
end
##Setting up the starting points for variables
for nx in 1:Nx, nu in 1:Nu, nfe in 1:NFE, ncp in 1:NCP
    set_start_value(x[nx, nfe, ncp],    x0[nx])
    set_start_value(dx[nx, nfe, ncp],dx0[nx])
    set_start_value(u[nu, nfe],         u0[nu])
    set_start_value(q[1, nfe, ncp],     q0)
    set_start_value(dq[1, nfe, ncp],    dq0)
end
##Rename some of the variables to write the equations easier
@NLexpressions(m1, begin
    x1[nfe in 1:NFE, ncp in 1:NCP],           x[1, nfe, ncp]
    x2[nfe in 1:NFE, ncp in 1:NCP],           x[2, nfe, ncp]
    D[nfe in 1:NFE],                          u[1, nfe]
end)
##Constraints defining region!


#Here is where you should defining the model ODEs in each line
@NLconstraints(m1, begin
Constr_ODE1[nfe in 1:NFE, ncp in 1:NCP], dx[1, nfe, ncp]      == (((μmax * x2[nfe, ncp]) / (km + x2[nfe, ncp] + k1 * x2[nfe, ncp]^2)) - D[nfe]) * x1[nfe, ncp];
Constr_ODE2[nfe in 1:NFE, ncp in 1:NCP], dx[2, nfe, ncp]      == (sf - x2[nfe, ncp]) * D[nfe] - (((μmax * x2[nfe, ncp]) / (km + x2[nfe, ncp] + k1 * x2[nfe, ncp]^2))/Y) * x1[nfe, ncp];
#For more ODEs:
# Constr_ODEi[nfe in 1:NFE, ncp in 1:NCP], dx[i, nfe, ncp] = Equation!
end)


#Defining the Quadrature Equations
@NLconstraints(m1, begin
      Constr_dq0[nfe = 1    , ncp in 1:NCP], dq[1, nfe, ncp]  == (x1[nfe,ncp] - x_sp[nfe])^2 + 0.5*(D[nfe]  - u0[1]    )^2
      Constr_dq[nfe in 2:NFE, ncp in 1:NCP], dq[1, nfe, ncp]  == (x1[nfe,ncp] - x_sp[nfe])^2 + 0.5*(D[nfe] - D[nfe-1])^2
end)


#Constraints on input usage (To avoid big jumps on input usage)
@NLconstraints(m1, begin
      #Defining Inequality Constraints in each line
      Constr_Ineq1[nfe in 1:1   ],   -0.08 <=   D[nfe] - u0[1]       <=  0.08
      Constr_Ineq2[nfe in 2:NFE-3],   -0.08 <=   D[nfe] - D[nfe-1]    <=  0.08
      Constr_Ineq3[nfe in NFE-2:NFE ],     D[nfe] - D[nfe-1]    == 0.0
end)


#Collocation Equations for states and quadratures as Constraints
@NLconstraints(m1, begin
        Coll_Eq_Diff[nx in 1:Nx,  nfe = 1:NFE, ncp in 1:NCP],     x[nx, nfe, ncp+1] == x[nx, nfe, 1] + sum(M[ncp, i] * dx[nx, nfe, i] for i in 1:NCP)
        Cont_Eq_First[nx in 1:Nx],                                x[nx, 1, 1] == x0[nx]
        Cont_Eq_rest[nx in 1:Nx,  nfe = 2:NFE],                   x[nx, nfe, 1] == x[nx, nfe-1, end]
        Coll_Eq_Quad0[             nfe = 1, ncp in 1:NCP],        q[1, nfe, ncp] == q0  + sum(M[ncp, i] * dq[1, nfe, i] for i in 1:NCP)
        Coll_Eq_Quad[       nfe in 2:NFE, ncp in 1:NCP],          q[1, nfe, ncp] == q[1, nfe-1, NCP]  + sum(M[ncp, i] * dq[1, nfe, i] for i in 1:NCP)
        end)
##And finally Defining the Objective Function!
@NLobjective(m1, Min,  sum( (x1[nfe,NCP] - x_sp[nfe])^2   for nfe in 1:NFE )  + 0.05*(D[1] - u0[1])^2 + sum( 0.05*(D[nfe] - D[nfe-1])^2 for nfe in 2:NFE)  )



## Calling the optimizer to optimize the whole prediction horizon
optimize!(m1)
JuMP.termination_status(m1)
JuMP.solve_time(m1::Model)
## Extarcting the results and reshape them into julia form

star_x = JuMP.value.(x[:, :, NCP])
star_x = cat(x0, star_x, dims = 2)
star_u = JuMP.value.(u)
star_x1 = JuMP.value.(x1[:, NCP])
star_x2 = JuMP.value.(x2[:, NCP])
star_x1 = cat(x0[1], star_x1, dims = 1)
star_x2 = cat(x0[2], star_x2, dims = 1)
star_D = JuMP.value.(D)
star_MPC = star_u[:,1]
##The output of the Function!
#Export the first input among NFE_MPC inputs as the output to be fed into the plant
return star_MPC

end
