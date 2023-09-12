# Project 3: Rossby waves

## Background
Rossby waves are important features of the large-scale flow in the ocean and atmosphere. They arise due to a restoring force associated with latitudinal (north/south) variations in the Coriolis parameter. In this project, we will explore Rossby waves and eddies and their ability to mix and transport tracers.

![Rossby waves](./images/rossby_fig.jpg)
ECMWF geopotential height map showing atmospheric Rossby waves (left) and ocean eddies visible in the phytoplankton concentration off the California coast (right)

Consider flow in a 2D plane, normal to the axis of rotation. In the next section, you will use Oceananigans to simulate flow in this plane. Consider small perturbations to a constant flow in the $x$-direction, $U$. Linearizing about the constant background flow, we have the following equations:
$$u'_t+Uu'_x - f(y) v' = -\frac{1}{\rho_0} p_x,$$
$$v'_t+Uv'_x + f(y) u' = -\frac{1}{\rho_0} p_y,$$
$$u'_x+v'_y=0.$$

Here, we will consider flow on the so-called $\beta$-plane, where the Coriolis parameter is approximated as $f\simeq f_0+\beta y$ (retaining the first two terms in a Taylor series expansion of $f(y)$ ). Since the flow is two-dimensional, it can be described by a streamfunction, $\psi'$, where $u'=-\psi'_y$, $v'=\psi'_x$. Taking the curl of the momentum equations to eliminate pressure gives
$$\nabla^2 \psi'_t+U\nabla^2 \psi'_x + \beta \psi'_x=0.$$

By looking for plane-wave solutions of the form:
$$\psi'=\psi_0 e^{i(kx+ly-\omega t)},$$
and inserting this in the equation for $\psi'$ above results in the dispersion equation for Rossby waves:
$$\omega-kU=-\frac{k\beta}{k^2+l^2}.$$

## Simulations of Linear Rossby Waves
The script `rossbywave.jl` in this folder simulates Rossby waves in dimensional coordinates. Here, $x$ corresponds to the eastward direction, and $y$ points north. A 2D rectilinear grid is set up with a domain size of 1000 kilometers in the $x$ and $y$ directions (approximately 10 degrees in latitude and longitude, respectively). We construct the $\beta$-plane channel by applying free-slip walls at the north and south boundaries and periodic boundary conditions in $x$. Since we want to simulate Rossby waves in dimentional coordinates, we approximate the Coriolis parameter using the BetaPlane function in Oceananigans, which constructs $f(y)$ using the beta-plane approximation using the rotation rate and the radius of the Earth and the latitude of the region we want to simulate. Here, we set the latitude to $45\degree N$.

To initialize the flow, we choose the wavelengths of the Rossby waves to be 200 kilometers (which is a typical size for mesoscale eddies in the ocean and roughly the size of the ocean eddies in the image above) and set the corresponding wavenumbers $k$ and $l$. We initialize the velocity field using a periodic array of eddies of the form: 
$$u = u_0 \sin(kx)\sin(ly),$$
$$v = \frac{u_0 k}{l}\cos(kx)\cos(ly).$$
where we will start with $u_0=0.001$ m/s so that the dynamics are quasi-linear. Note that $u_x+v_y=0$. Running the script produces a movie of $u$ and creates a Hovmoller diagram by plotting $u$ at $y=Ly/2$ as a function of $x$ and $t$.

After running `rossbywave.jl`, watch the movie `rossbywave.mp4`. You should see the waves propagate. Does the direction of propagation match your expecations? You will notice some boundary effects at the north/south ends of the domain where the boundary condition of $v=0$ causes waves to reflect from the boundary.

Estimate the phase speed of waves using the Hovmoller diagram. How does the phase speed compare to what you estimate from the dispersion relation, given above? Try varying the latitude parameter in the BetaPlane function in `rossbywave.jl`, and/or $k$ and $l$ and repeat the simulation and analysis.

## Tracer transport by linear and nonlinear Rossby waves
An important difference between linear (small amplitude) Rossby waves and nonlinear eddies in the ocean and atmosphere is their ability to transport tracers (e.g. temperature, salinity, phytoplankoton, pollutants, etc.) `rossbywave.jl` includes a passive scalar which is proportional to the streamfunction associated with the initial velocity field. Try increasing the amplitude of the initial velocity perturbation. Can you idenfity a transition to nonlinear eddy-like behavior where the eddies trap and transport tracer? For intermediate amplitudes do you see any evidence for a combination of wave and eddy-like characteristcs? 

To gain further insight, add code to `rossbywave.jl` to calculate and save the absolute vorticity, $\omega + f$, where $\omega$ is the relative vorticity, i.e. the curl of the 2D velocity vector. Plot contours of the absolute vorticity for the wave and eddy regimes. What can you conclude about the velocity amplitude where the flow transitions from wave-like to eddy-like?

## Suggested Further Investigations

### Rossby waves on a zonal mean flow
Try adding a non-zero zonal (east/west) mean flow to your initial conditions (in other words add a function $g(y)$ to $u_i$.) How does this modify the phase speed of the waves? Explore various configurations for the mean flow and the wave perturbations. For example, what happens if the wave perturbations are isolated to a region with zero or non-zero mean flow? How do the waves interact with the mean flow and how does this vary with the amplitude of the waves and the mean flow?

### Rossby graveyard
[Zhai et al.](./papers/Zhai.pdf) proposed that a significant amount of energy is dissipated when nonlinear Rossby waves and westward propagating eddies 'break' at western boundaries. Change the topology of the grid to `bounded` in the x-direction. What happens when the Rossby waves encounter the boundary on the western side of the domain? How do the results change when you vary the amplitude of the initial velocity perturbation?

### Zonal jets
When the amplitude of the initial perturbation is large, the resulting flow will be highly nonlinear. In 2D (or quasi-geostrophic) turbulence, energy is transferred on average to large scales. On a $\beta$-plane, this eventually manifests in the spontaneous formation of zonal jets, e.g. east/west flow that is also coherent in the east/west direction. This was discussed in a classic paper by [Rhines](./papers/Rhines75.pdf) who proposed that the jets form with a horizontal lengthscale set by $(U/\beta)^{1/2}$. This process is thought to be important in forming the zonal jets (and banded cloud patterns) on Jupiter and the other gas giants. Explore the formation and dynamics of zonal jets by varying the parameters in `rossbywaves.jl`. For a velocity perturbation with a fixed amplitude, how does the number of jets that form depend on $\beta$? Are the jets stationary, or do they meander?

