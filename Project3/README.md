# Project 3: Rossby waves

## Background
Rossby waves are important persistent features of flows in the ocean and atmosphere. In this project, you will explore Rossby waves and eddies and their ability to mix and transport tracers.

![Rossby waves](./images/rossby_fig.jpg)

ECMWF geopotential height map showing atmospheric Rossby waves (left) and ocean eddies visible in the phytoplankton concentration off the California coast (right)

Consider flow in a 2D plane, normal to the axis of rotation. In the next section, you will use Oceananigans to simulate flow in this plane. Consider small perturbations to a constant flow in the $x$-direction, $U$. Linearizing about the constant background flow, we have the following equations:
$$u'_t+Uu'_x - f(y) v' = -\frac{1}{\rho_0} p_x,$$
$$v'_t+Uv'_x + f(y) u' = -\frac{1}{\rho_0} p_y,$$
$$u'_x+v'_y=0.$$

Here, we will consider flow on the so-called '$\beta$-plane', where the Coriolis parameter is approximated as $f\simeq f_0+\beta y$. Since the flow is two-dimensional, it can be described by a streamfunction, $\psi'$, where $u'=-\psi'_y$, $v'=\psi'_x$. Taking the curl of the momentum equations to eliminate pressure gives
$$\nabla^2 \psi'_t+U\nabla^2 \psi'_x + \beta \psi'_x=0.$$

By looking for plane-wave solutions of the form:
$$\psi'=\psi_0 e^{i(kx+ly-\omega t)},$$
we can derive the Rossby wave dispersion relation:
$$\omega-kU=-\frac{k\beta}{k^2+l^2}.$$

## Simulations of Linear Rossby Waves
The script `rossbywave.jl` in this folder simulates Rossby waves in dimensional coordinates. Here, $x$ corresponds to the eastward direction, and $y$ points north. A 2D rectilinear grid is set up with 12000 kilometers in each direction (approximately 120 degrees in latitude and longitude respectively). We construct the $\beta$-plane channel by applying free-slip walls at the north and south boundaries and periodic boundary conditions in $x$. Since we want to simulate Rossby waves in dimentional coordinates, we approximate the Coriolis parameter using the BetaPlane function in Oceananigans, which takes the rotation rate and the radius of the Earth, as well as the latitude of the region we want to simulate. Here, we set the latitude to $21\degree N$ to match the bottom panel of Figure 2 in Chelton and Schlax (a PDF of this paper is in the project folder).

To initialize the flow, we choose the wavelengths of the Rossby waves to be about 3000 kilometers (approximately 30 degrees) and set the corresponding wavenumbers $k$ and $l$. We initialize the velocity field using 
$$u_i = U \sin(kx)\sin(ly),$$
$$v_i = \frac{Uk}{l}\cos(kx)\cos(ly),$$
where $U=0.1$ m/s. Note that $u_x+v_y=0$. Running the script produces a movie of $u$ and creates a Hovmoller diagram by plotting $u$ at $y=Ly/2$ as a function of $x$ and $t$. 

When you run the simulation, you should see the waves propagate. Which direction do they move? Estimate the phase speed of waves using the Hovmoller diagram. How does the phase speed compare to what you estimate from the dispersion relation, given above? Try varying the latitude in BetaPlane function and/or $k$ and $l$ and repeat the simulation and analysis. Note that the simulation results are different from the observations in Chelton and Schlax even though we are using the same sizes of the domain and latitude. This is because we are simulating barotropic Rossby waves, while their observations are of baroclinic ones. 

## Suggested Further Investigations

### Transport by linear and nonlinear Rossby waves
An important difference between linear Rossby waves and nonlinear eddies in the ocean and atmosphere is their ability to transport fluid properties. First, examine transport by linear Rossby waves by introducing a passive scalar in the calculation above. Try initializing the scalar with the same structure as the initial velocity, and then visualize both the scalar and the velocity. Do the water crests move relative to the scalar field, or do the waves carry the scalar with them as they propagate? Do the waves stir the fluid?

The Rossby number is defined as 
$$Ro=\frac{U}{Lf},$$
where $U$ and $L$ are characteristic velocity and length scales and $f$ is the Coriolis frequency. It represents the relative size of the nonlinear and Coriolis terms in the momentum equations. For our initial simulation, we have a small Rossby number so that the nonlinear term is small. Try changing the Rossby number by varying the value of $U$ in the setup. 

Make the Rossby number much larger and repeat the above calculation. Now the nonlinear term will be quite large - how does the tracer transport change? You may have a difficult time diagnosing the wave nature of the flow since the nonlinear terms are so large. Try an intermediate value of the Rossby number. Can you see a combination of wave and eddy-like characteristics?

### Rossby graveyard
Zhai (a PDF is in the project folder) proposed that a significant amount of energy is dissipated when nonlinear Rossby waves and westward propagating eddies 'break' at western boundaries. By adding free-slip or no-slip boundaries the x-direction, examine what happens when Rossby waves encounter a west/east boundary.
