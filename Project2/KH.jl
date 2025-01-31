# This script simulates Kelvin-Helmholtz instability in 2D using Oceananigans

# Load some standard libraries that we will need
using Printf
using Oceananigans

# First, we need to set some physical parameters for the simulation
# Set the domain size in non-dimensional coordinates
Lx = 8  # size in the x-direction
Lz = 1   # size in the vertical (z) direction 

# Set the grid size
Nx = 256  # number of gridpoints in the x-direction
Nz = 64   # number of gridpoints in the z-direction

# Some timestepping parameters
max_Δt = 0.02 # maximum allowable timestep 
duration = 20 # The non-dimensional duration of the simulation

# Set the Reynolds number (Re=Ul/ν)
Re = 5000
# Set the Prandtl number (Pr=ν/κ)
Pr = 1

# Parameters for the initial condition:
S₀=10 # maximum shear
N₀=sqrt(10) # maximum buoyancy frequency
h=0.1 # shear layer width

# Set the amplitude of the random perturbation (kick)
kick = 0.05

# construct a rectilinear grid using an inbuilt Oceananigans function
# Here, we use periodic (cyclic) boundary conditions in x
grid = RectilinearGrid(size = (Nx, Nz), x = (0, Lx), z = (0, Lz), topology = (Periodic, Flat, Bounded))

# No boundary conditions explicitly set - the BCs will default to free-slip and no-flux in z

# Now, define a 'model' where we specify the grid, advection scheme, bcs, and other settings
model = NonhydrostaticModel(; grid,
              advection = UpwindBiased(),  # Specify the advection scheme.  Another good choice is WENO() which is more accurate but slower
            timestepper = :RungeKutta3, # Set the timestepping scheme, here 3rd order Runge-Kutta
                tracers = (:b),  # Set the name(s) of any tracers, here b is buoyancy
               buoyancy = BuoyancyTracer(), # this tells the model that b will act as the buoyancy (and influence momentum) 
                closure = (ScalarDiffusivity(ν = 1 / Re, κ = 1 / Re)),  # set a constant kinematic viscosity and diffusivty, here just 1/Re since we are solving the non-dimensional equations 
                coriolis = nothing # this line tells the mdoel not to include system rotation (no Coriolis acceleration)
)

# Set initial conditions
# Here, we start with a tanh function for buoyancy and add a random perturbation to the velocity. 
uᵢ(x, z) = S₀ * h * tanh( (z - Lz/2) / h) + kick * randn()
vᵢ(x, z) = 0
wᵢ(x, z) = kick * randn()
bᵢ(x, z) = N₀^2 * h * tanh( (z - Lz/2) / h) + kick * randn()

# Send the initial conditions to the model to initialize the variables
set!(model, u = uᵢ, v = vᵢ, w = wᵢ, b = bᵢ)

# Now, we create a 'simulation' to run the model for a specified length of time
simulation = Simulation(model, Δt = max_Δt, stop_time = duration)

# ### The `TimeStepWizard`
wizard = TimeStepWizard(cfl = 0.85, max_change = 1.1, max_Δt = max_Δt)
simulation.callbacks[:wizard] = Callback(wizard, IterationInterval(10))

# ### A progress messenger
start_time = time_ns()
progress(sim) = @printf("i: % 6d, sim time: % 10s, wall time: % 10s, Δt: % 10s, CFL: %.2e\n",
                        sim.model.clock.iteration,
                        sim.model.clock.time,
                        prettytime(1e-9 * (time_ns() - start_time)),
                        sim.Δt,
                        AdvectiveCFL(sim.Δt)(sim.model))
simulation.callbacks[:progress] = Callback(progress, IterationInterval(10))

# ### Output
u, v, w = model.velocities # unpack velocity `Field`s
b = model.tracers.b # extract the buoyancy

# Now, calculate secondary quantities
# Oceananigans has functions to calculate derivatives on the model grid

ω = ∂z(u) - ∂x(w) # The spanwise vorticity
χ = (1 / (Re * Pr)) * (∂x(b)^2 + ∂z(b)^2) # The dissipation rate of buoyancy variance
ϵ = (1 / Re) * (∂x(u)^2 + ∂z(u)^2 + ∂x(v)^2 + ∂z(v)^2) # The dissipation rate of kinetic energy

# Set the name of the output file
filename = "KH"

simulation.output_writers[:xz_slices] =
    JLD2OutputWriter(model, (; u, v, w, b, ω, χ, ϵ),
                          filename = filename * ".jld2",
                          indices = (:, 1, :),
                          schedule = TimeInterval(0.2),
                          with_halos = false,
                          overwrite_existing = true)

nothing # hide

# Now, run the simulation
run!(simulation)

# After the simulation is different, plot the results and save a movie
include("plot_KH.jl")
