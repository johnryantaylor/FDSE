# This script runs the phytoplankton-zooplankton (PZ) model as a 1-D column model using OceanBioME

using Oceananigans, OceanBioME
using Plots
using Printf

include("PZ.jl")

# Set the diffusion coefficient
κₜ = 0.0

# define the grid
grid = RectilinearGrid(topology = (Flat, Flat, Bounded), size = (100, ), extent = (1, ))

# Specify the biogeochemical model
biogeochemistry = PhytoplanktonZooplankton()
# To change the e-folding decay length for the light, replace with the following
#biogeochemistry = PhytoplanktonZooplankton(light_decay_length=0.1)

# Construct the model using Oceananigans with the biogeochemistry handled by OceanBioME
model = NonhydrostaticModel(; grid,
                              biogeochemistry,
                              closure = ScalarDiffusivity(ν = κₜ, κ = κₜ))

set!(model, P = 0.1, Z = 0.1)

# Set up the simulation with the timestep and stop time
simulation = Simulation(model, Δt = 0.01, stop_time = 500)

# Create an 'output_writer' to save data periodically
simulation.output_writers[:tracers] = JLD2OutputWriter(model, model.tracers,
                                                       filename = "column_pz.jld2",
                                                       schedule = TimeInterval(1),
                                                       overwrite_existing = true)

start_time = time_ns() # record the start time

# Build a progress message
progress(sim) = @printf("i: % 6d, sim time: % 4s, wall time: % 10s \n",
    sim.model.clock.iteration,
    sim.model.clock.time,
    prettytime(1e-9 * (time_ns() - start_time)))

# Display the progress message every 1000 timesteps
simulation.callbacks[:progress] = Callback(progress, IterationInterval(1000))

# Now, run the simulation
run!(simulation)

# Now, read the data and plot the results
P = FieldTimeSeries("column_pz.jld2", "P")
Z = FieldTimeSeries("column_pz.jld2", "Z")

# Get the gridpoints (all we need is zc)
xc, yc, zc = nodes(grid, Center(), Center(), Center())

# Extract an array of times when the data was saved
times = P.times

hmP = heatmap(times , zc, log10.(abs.(P[1, 1, 1:grid.Nz, 1:end])), xlabel = "time", ylabel = "z (m)", title="log10(Phytoplankton)")

hmZ = heatmap(times , zc, log10.(abs.(Z[1, 1, 1:grid.Nz, 1:end])), xlabel = "time", ylabel = "z (m)", title="log10(Zooplankton)")

plot(hmP, hmZ, layout=(2,1))