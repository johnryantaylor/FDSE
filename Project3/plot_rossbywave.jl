
# This script reads in output from rossbywave.jl, makes a plot, and saves an animation

using Oceananigans, JLD2, Plots, Printf

# Set the filename (without the extension)
filename = "rossbywave"

# Read in the first iteration.  We do this to load the grid
# filename * ".jld2" concatenates the extension to the end of the filename
u_ic = FieldTimeSeries(filename * ".jld2", "u", iterations = 0)
v_ic = FieldTimeSeries(filename * ".jld2", "v", iterations = 0)
w_ic = FieldTimeSeries(filename * ".jld2", "w", iterations = 0)
c_ic = FieldTimeSeries(filename * ".jld2", "c", iterations = 0)

## Load in coordinate arrays
## We do this separately for each variable since Oceananigans uses a staggered grid
xu, yu, zu = nodes(u_ic)
xv, yv, zv = nodes(v_ic)
xw, yw, zw = nodes(w_ic)
xc, yc, zc = nodes(c_ic)

## Now, open the file with our data
file_xy = jldopen(filename * ".jld2")

## Extract a vector of iterations
iterations = parse.(Int, keys(file_xy["timeseries/t"]))

@info "Making an animation from saved data..."

t_save = zeros(length(iterations))
u_mid = zeros(length(u_ic[:, 1, 1]), length(iterations))

# Here, we loop over all iterations
anim = @animate for (i, iter) in enumerate(iterations)

    @info "Drawing frame $i from iteration $iter..."

    u_xy = file_xy["timeseries/u/$iter"][:, :, 1];
    v_xy = file_xy["timeseries/v/$iter"][:, :, 1];
    w_xy = file_xy["timeseries/w/$iter"][:, :, 1];
    c_xy = file_xy["timeseries/c/$iter"][:, :, 1];
    
    t = file_xy["timeseries/t/$iter"];

    # Save some variables to plot at the end
    u_mid[: , i] = u_xy[:, 64, 1]
    t_save[i] = t # save the time

    u_title = @sprintf("u (m/s), t = %s days", round(t/1day));
    v_title = @sprintf("v (m/s), t = %s days", round(t/1day));
    w_title = @sprintf("w (m/s), t = %s days", round(t/1day));
    c_title = @sprintf("c, t = %s days", round(t/1day));

    u_xy_plot = Plots.heatmap(xu/1e3, yu/1e3, u_xy'; color = :balance, xlabel = "x (km)", ylabel = "y (km)", aspect_ratio = :equal, title=u_title, fontsize=14);  
    v_xy_plot = Plots.heatmap(xu/1e3, yu/1e3, u_xy'; color = :balance, xlabel = "x (km)", ylabel = "y (km)", aspect_ratio = :equal, title=v_title, fontsize=14);  
    w_xy_plot = Plots.heatmap(xu/1e3, yu/1e3, u_xy'; color = :balance, xlabel = "x (km)", ylabel = "y (km)", aspect_ratio = :equal, title=w_title, fontsize=14);  
    c_xy_plot = Plots.heatmap(xc/1e3, yc/1e3, c_xy'; color = :balance, xlabel = "x (km)", ylabel = "y (km)", aspect_ratio = :equal, title=c_title, fontsize=14);  

    plot(u_xy_plot, c_xy_plot, layout = (1, 2), size = (1300, 600))
    
    iter == iterations[end] && close(file_xy)
end

# Save the animation to a file
mp4(anim, "rossbywave.mp4", fps = 20) # hide

# Now, make a plot of our saved variables
Plots.heatmap(xu / 1kilometer, t_save / 1day, u_mid', xlabel="x (km)", ylabel="t (days)", title="u at y=Ly/2")
