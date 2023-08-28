
# This script reads in output from PZ_cavity.jl, makes a plot, and saves an animation

using Oceananigans, JLD2, Plots, Printf

# Set the filename (without the extension)
filename = "cavity_PZ"

# Read in the first iteration.  We do this to load the grid
# filename * ".jld2" concatenates the extension to the end of the filename
u_ic = FieldTimeSeries(filename * ".jld2", "u", iterations = 0)
w_ic = FieldTimeSeries(filename * ".jld2", "w", iterations = 0)
P_ic = FieldTimeSeries(filename * ".jld2", "P", iterations = 0)
Z_ic = FieldTimeSeries(filename * ".jld2", "Z", iterations = 0)

## Load in coordinate arrays
## We do this separately for each variable since Oceananigans uses a staggered grid
xu, yu, zu = nodes(u_ic)
xw, yw, zw = nodes(w_ic)
xP, yP, zP = nodes(P_ic)
xZ, yZ, zZ = nodes(Z_ic)

## Now, open the file with our data
file_xz = jldopen(filename * ".jld2")

## Extract a vector of iterations
iterations = parse.(Int, keys(file_xz["timeseries/t"]))

@info "Making an animation from saved data..."

t_save = zeros(length(iterations))

# Here, we loop over all iterations
anim = @animate for (i, iter) in enumerate(iterations)

    @info "Drawing frame $i from iteration $iter..."

    u_xz = file_xz["timeseries/u/$iter"][:, 1, :];
    w_xz = file_xz["timeseries/w/$iter"][:, 1, :];
    P_xz = file_xz["timeseries/P/$iter"][:, 1, :];
    Z_xz = file_xz["timeseries/Z/$iter"][:, 1, :];

# If you want an x-y slice, you can get it this way:
    # b_xy = file_xy["timeseries/b/$iter"][:, :, 1];

    t = file_xz["timeseries/t/$iter"];

    # Save some variables to plot at the end
    t_save[i] = t # save the time

        u_xz_plot = heatmap(xu, zu, u_xz'; color = :balance, xlabel = "x", ylabel = "z", aspect_ratio = :equal);  
        w_xz_plot = heatmap(xw, zw, w_xz'; color = :balance, xlabel = "x", ylabel = "z", aspect_ratio = :equal); 
        P_xz_plot = heatmap(xP, zP, log10.(abs.(P_xz')); color = :thermal, xlabel = "x", ylabel = "z", aspect_ratio = :equal, clims = (-2, 1)); 
        Z_xz_plot = heatmap(xZ, zZ, log10.(abs.(Z_xz')); color = :thermal, xlabel = "x", ylabel = "z", aspect_ratio = :equal, clims = (-2, 1)); 

    u_title = @sprintf("u, t = %s", round(t));
    w_title = @sprintf("w, t = %s", round(t));
    P_title = @sprintf("log10(P), t = %s", round(t));
    Z_title = @sprintf("log10(Z), t = %s", round(t));

# Combine the sub-plots into a single figure
    plot(u_xz_plot, w_xz_plot, P_xz_plot, Z_xz_plot, layout = (2, 2), size = (1200, 1200),
    title = [u_title w_title P_title Z_title], fontsize = 16)

    iter == iterations[end] && close(file_xz)
end

# Save the animation to a file
mp4(anim, "PZ_cavity.mp4", fps = 20) # hide