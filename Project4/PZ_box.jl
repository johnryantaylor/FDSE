# This script runs the phytoplankton-zooplankton (PZ) model as a 0-D box model using OceanBioME

# Import some required modules
using Oceananigans
using OceanBioME
using OceanBioME: BoxModel
using JLD2
using Plots

include("PZ.jl") # Include the functions defined in PZ.jl

# Define a function form for the photosynthetically available radiation (PAR), which modulates the growth rate
@inline PAR(t) = 1  # or sin(t), etc.

# This tells OceanBioME to use the PhytoplanktonZooplankton model that is defined in PZ.jl with the default parameters
biogeochemistry = PhytoplanktonZooplankton()
# To override any of the default parameters, do something like this:
#biogeochemistry = PhytoplanktonZooplankton(phytoplankton_growth_rate = 0.5)

model = BoxModel(; biogeochemistry)

# Set the initial conditions
set!(model, P = 0.1, Z = 0.1)

simulation = Simulation(model; Δt = 0.05, stop_time = 50)

simulation.output_writers[:fields] = JLD2Writer(model, model.fields; filename = "box_pz.jld2", schedule = IterationInterval(1), overwrite_existing = true)

prog(sim) = @info "$(prettytime(time(sim))) in $(prettytime(simulation.run_wall_time))"

simulation.callbacks[:progress] = Callback(prog, IterationInterval(1000))

# ## Run the model and save the output every save_interval timesteps (should only take a few seconds)
@info "Running the simulation..."
run!(simulation)

# Now, read the saved output and plot the results

# Now, read the data and plot the results. This is saved as a Field with metadata
P_field = FieldTimeSeries("box_pz.jld2", "P")
Z_field = FieldTimeSeries("box_pz.jld2", "Z")

# Extract the data at the single grid point corresponding to the box model
P=P_field.data[1,1,1,:]
Z=Z_field.data[1,1,1,:]

# Extract the time from one of the variables
t=P_field.times

# Make an animated plot of the evolution of the PZ model
anim = @animate for i=1:5:length(P_field.times)
  plt1 = plot(t[1:i], P[1:i], linewidth = 2, xlabel = "time", ylabel = "P, Z", legend = :outertopleft, label = "P", linecolor = :blue);
  scatter!(plt1, [t[i]], [P[i]], markercolor = :blue, label = :none)
  plot!(plt1, t[1:i], Z[1:i], linewidth = 2, label="Z", linecolor = :red, xlimits = (0, maximum(P_field.times)), ylimits = (0, max(maximum(P),maximum(Z))));
  scatter!(plt1, [t[i]], [Z[i]], markercolor = :red, label = :none)
  plt2 = plot(P[1:i], Z[1:i], linewidth = 2, xlabel="P", ylabel="Z", xlimits = (0, maximum(P)), ylimits = (0,maximum(Z)), linecolor = :black, legend = :none);
  scatter!(plt2, [P[i]], [Z[i]], markercolor = :black, label = :none)
  plot(plt1, plt2, layout = (1,2))
end

mp4(anim, "PZ_box.mp4", fps = 20) # hide

plt1 = plot(t, P, linewidth = 2, xlabel = "time", ylabel = "P, Z", legend = :outertopleft, label = "P");
plot!(plt1, t, Z, linewidth = 2, label="Z");
plt2 = plot(P, Z, linewidth = 2, xlabel="P", ylabel="Z", linecolor = :black, legend = :none);
plot(plt1, plt2, layout = (1,2))
