using Oceananigans
using Printf
using Oceananigans.Units

# Set the domain size in dimensional coordinates
Lx = 12000kilometers   # approximately 120 degrees (100 km per degree)
Ly = 12000kilometers

# Set the grid size
Nx = 128   # number of grid points in x-direction
Ny = 128   # number of grid points in y-direction

# Construct a rectilinear grid that is periodic in x-direction and bounded in y-direction
grid = RectilinearGrid(size = (Nx, Ny),
                       x = (0, Lx), y = (0, Ly),
                       topology = (Periodic, Bounded, Flat)
)

# Set up a model for Rossby waves
model = NonhydrostaticModel(; grid,
              advection = UpwindBiasedFifthOrder(),   # Specify the advection scheme.  Another good choice is WENO() which is more accurate but slower
            timestepper = :RungeKutta3,   # Set the timestepping scheme, here 3rd order Runge-Kutta
                closure = (ScalarDiffusivity(ν = 1e-6, κ = 1e-6)),   # set a constant kinematic viscosity and diffusivty, here we use the molecular values 
                tracers = :c,
                coriolis = BetaPlane(rotation_rate = 7.292115e-5, latitude = 21, radius = 6371e3)   # set Coriolis parameter using Beta-plane approximation at latitude 21N
)

# Set wavenumbers for Rossby waves
k = 2 * pi / 3000kilometers   # for a wavelength of approx 30 degrees
l = 2 * pi / 3000kilometers

# Set initial conditions
U = 0.1   # units: m/s
uᵢ(x, y, z) = U * sin(k * x) * sin(l * y)
vᵢ(x, y, z) = U * (k / l) * cos(k * x) * cos(l * y)
wᵢ(x, y, z) = 0
cᵢ(x, y, z) = sin(k * x) * sin(l * y)

# Send the initial conditions to the model to initialize the variables
set!(model, u = uᵢ, v = vᵢ, w = wᵢ, c = cᵢ)

# Create a 'simulation' to run the model for a specified length of time
simulation = Simulation(model, Δt = 1hour, stop_iteration = 1000)

# Add callback that prints progress message during simulation
progress(sim) = @info string("Iter: ", iteration(sim),
                             ", time: ", prettytime(sim))

simulation.callbacks[:progress] = Callback(progress, IterationInterval(10))

# Save output from the simulation
filename = "rossbywave"

u, v, w = model.velocities

simulation.output_writers[:jld2] = JLD2OutputWriter(model, (; u, v, w),
                                                    schedule = IterationInterval(10),
                                                    filename = filename * ".jld2",
                                                    overwrite_existing = true
)

# Run the simulation                                                  
run!(simulation)

# Make a plot of u at y=Ly/2 and save a movie
include("plot_rossbywave.jl")