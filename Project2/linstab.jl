# This script analyzes the linear stability of a viscous stratified shear flow
# using the SSF.jl solver written (in MATLAB) by William Smyth
using Plotly: plot as PlotlyPlot
using Plotly: attr, Layout
using Statistics # used in SSF.jl
using LinearAlgebra  # used in SSF.jl


include("./code/SSF.jl")  # We include SSF.jl which contains the function to do the calculation
# The following functions calculate discrete derivatives
include("./code/ddz.jl")
include("./code/ddz2.jl")
include("./code/ddz4.jl")

# ********** User input parameters **********
LZ = 1    # The z-domain size
LX = 10   # The x-domain size (sets the range of wavenumbers to search)
h = 0.025     # Shear layer width
NZ = 100  # The number of gridpoints
dz = LZ / NZ  # The grid spacing - must be evenly spaced
nu = 1 / 5000  # Kinematic viscosity (or 1/Re)
kappa = nu    # Diffusivity
S0 = 10       # Maximum shear
N0 = sqrt(10)       # Maximum buoyancy frequency
# ********** End user input parameters **********

# Create the y-coordinate
z = 0:dz:LZ

# Hyperbolic tangent velocity and buoyancy profiles
buoy=(N0^2 * h) .* tanh.( (z .- LZ/2) ./ h )
vel=(S0 * h) .* tanh.( (z .- LZ/2) ./ h)

dbdz = similar(z)
dudz = similar(z)

for i = 2:length(z)
    dbdz[i] = (buoy[i] - buoy[i - 1]) / (z[i] - z[i - 1])
    dudz[i] = (vel[i] - vel[i - 1]) / (z[i] - z[i - 1])
end
Rig = dbdz ./ (dudz .^ 2)

# Create an x-wavenumber vector to explore solutions
kx = LinRange(2 * pi / LX, 2 * pi * 200 / LX, 1000)

sigma = complex(zeros(2*(NZ+1), length(kx)))
lambda_w = complex(zeros(NZ+1, 2*(NZ+1), length(kx)))
lambda_b = complex(zeros(NZ+1, 2*(NZ+1), length(kx)))

for (k, k_val) in enumerate(kx)
    (sigma[:, k], lambda_w[:, :, k], lambda_b[:, :, k]) = SSF(z, vel, buoy, k_val, 0, nu, kappa, [0, 0], [0, 0], 0)
end

PlotlyPlot(kx, real.(sigma[1, :]), Layout(xaxis_title="kₓ",yaxis_title="growth rate",plot_bgcolor="white",yaxis=attr(gridcolor="lightgrey",zerolinecolor="black"),xaxis=attr(gridcolor="lightgrey",zerolinecolor="black")))

