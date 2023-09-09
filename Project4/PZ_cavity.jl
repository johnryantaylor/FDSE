# This script runs the phytoplankton-zooplankton (PZ) model in a 2D lid-driven cavity flow

using Oceananigans, OceanBioME
using Printf

include("PZ.jl")

# Set the diffusion coefficient
κₜ = 1e-4

# Set the velocity of the top boundary
vel_top = 1.0

# define the grid
grid = RectilinearGrid(topology = (Bounded, Flat, Bounded), size = (100, 100, ), extent = (1, 1, ))

# Set the boundary conditions
u_bcs = FieldBoundaryConditions(top = ValueBoundaryCondition(vel_top), bottom = ValueBoundaryCondition(0.0))
w_bcs = FieldBoundaryConditions(east = ValueBoundaryCondition(0.0), west = ValueBoundaryCondition(0.0))

λ = 0.1
w₀ = 0.05

w_sinking(x, y, z) = - w₀ * (tanh(z/λ) - tanh((-z - 1)/λ) - 1)

sinking_velocity = Oceananigans.Fields.FunctionField{Center, Center, Center}(w_sinking, grid)

# Construct the model using Oceananigans with the biogeochemistry handled by OceanBioME
model = NonhydrostaticModel(; grid,
                              advection = UpwindBiasedFifthOrder(),
                              biogeochemistry = PhytoplanktonZooplankton(; sinking_velocity),
                              closure = ScalarDiffusivity(ν = κₜ, κ = κₜ),
                              boundary_conditions = (u = u_bcs, w = w_bcs))

set!(model, P = 0.1, Z = 0.1)

# Set up the simulation with the timestep and stop time
simulation = Simulation(model, Δt = 0.005, stop_time = 50)

u, v, w = model.velocities # unpack velocity `Field`s
P = model.tracers.P
Z = model.tracers.Z

filename = "cavity_PZ"

# Create an 'output_writer' to save data periodically
simulation.output_writers[:xz_slices] =
    JLD2OutputWriter(model, (; u, w, P, Z),
                          filename = filename * ".jld2",
                          indices = (:, 1, :),
                         schedule = TimeInterval(0.25),
                            overwrite_existing = true)

# ### A progress messenger
# We add a callback that prints out a progress message while the simulation runs.
start_time = time_ns()  # Save the start time of the simulation

progress(sim) = @printf("i: % 6d, sim time: % 10s, wall time: % 10s \n",
                        sim.model.clock.iteration,
                        sim.model.clock.time,
                        prettytime(1e-9 * (time_ns() - start_time)))

simulation.callbacks[:progress] = Callback(progress, IterationInterval(200))

# Now, run the simulation
run!(simulation)

# Call a script to make an animation of the results (and save to PZ_cavity.mp4)
include("plot_PZ_cavity.jl")
