# This script runs the phytoplankton-zooplankton (PZ) model as a 0-D box model using OceanBioME

# Import some required modules
using OceanBioME
using OceanBioME: BoxModel
import OceanBioME.BoxModels: update_boxmodel_state!
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
model.Δt = 0.05
model.stop_time = 50

# Set the initial conditions
set!(model, P = 0.1, Z = 0.1)

# ## Run the model and save the output every save_interval timesteps (should only take a few seconds)
@info "Running the model..."
run!(model, save_interval = 1, feedback_interval = Inf, save = SaveBoxModel("box_pz.jld2"))

# Now, read the saved output and plot the results

vars = (:P, :Z)
file = jldopen("box_pz.jld2")
times = parse.(Float64, keys(file["values"]))

timeseries = NamedTuple{vars}(ntuple(t -> zeros(length(times)), length(vars)))

for (idx, time) in enumerate(times)
    values = file["values/$time"]
    for tracer in vars
        getproperty(timeseries, tracer)[idx] = values[tracer]
    end
end

close(file)

anim = @animate for i=1:5:length(times)
  plt1 = plot(times[1:i], timeseries.P[1:i], linewidth = 2, xlabel = "time", ylabel = "P, Z", legend = :outertopleft, label = "P", linecolor = :blue);
  scatter!(plt1, [times[i]], [timeseries.P[i]], markercolor = :blue, label = :none)
  plot!(plt1, times[1:i], timeseries.Z[1:i], linewidth = 2, label="Z", linecolor = :red, xlimits = (0, maximum(times)), ylimits = (0, max(maximum(timeseries.P),maximum(timeseries.Z))));
  scatter!(plt1, [times[i]], [timeseries.Z[i]], markercolor = :red, label = :none)
  plt2 = plot(timeseries.P[1:i], timeseries.Z[1:i], linewidth = 2, xlabel="P", ylabel="Z", xlimits = (0, maximum(timeseries.P)), ylimits = (0,maximum(timeseries.Z)), linecolor = :black, legend = :none);
  scatter!(plt2, [timeseries.P[i]], [timeseries.Z[i]], markercolor = :black, label = :none)
  plot(plt1, plt2, layout = (1,2))
end

mp4(anim, "PZ_box.mp4", fps = 20) # hide

plt1 = plot(times, timeseries.P, linewidth = 2, xlabel = "time", ylabel = "P, Z", legend = :outertopleft, label = "P");
plot!(plt1, times,timeseries.Z, linewidth = 2, label="Z");
plt2 = plot(timeseries.P, timeseries.Z, linewidth = 2, xlabel="P", ylabel="Z", linecolor = :black, legend = :none);
plot(plt1, plt2, layout = (1,2))