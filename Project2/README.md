## Project 2: Kelvin-Helmholtz instability

# Background
Although most natural flows are time-varying, and have complicated spatial structure, important insights can be gained by examining the stability of simple flows. For example, many identifiable features in the atmosphere and ocean, such as eddies and billow clouds (shown), are generated and derive their properties from fluid instabilities.

![KH-billows over Mt. Shasta]{"./images/kh-billows.jpg"}
Kelvin-Helmholtz billows developing in a cloud layer over Mount Shasta, California. Photo copyright 1999, Beverly Shannon.

# Introduction
Here, we will examine the basic stability properties of a stratified shear flow, and will then use Diablo to examine the nonlinear evolution of the unstable state.

Start by considering a stratified shear flow of the form:
$$
\mathbf{U}=S_0h \mbox{tanh}\left(\frac{y-LY/2}{h}\right)\hat{i},
$$
and
$$
B=N_0^2h \mbox{tanh}\left(\frac{y-LY/2}{h}\right),
$$
where $B=-g\rho/\rho_0$ is the buoyancy, $h$ is the height of the shear layer, and $S_0$ and $N_0$ are the shear and buoyancy frequency at the center of the shear layer. The Miles-Howard theorem states that a necessary but not sufficient condition for instability of a stratified, unidirectional, shear flow is that $Ri_g<1/4$ somewhere in the flow, where $Ri_g=N^2/S^2$ is the gradient Richardson number. For the basic state above, the minimum gradient Richardson number is $\mbox{min}(Ri_g)=N_0^2/S_0^2$.  

# Linear stability analysis
Consider the stability of small perturbations the base state defined above: $\mathbf{u}=\mathbf{U}+\epsilon\mathbf{u}'$, $b=B+\epsilon b'$. We can then look for normal mode solutions to the linearised equations of the form
$$
v'=\mbox{Re}\left[\hat{v}(y)\mbox{exp}(\sigma t+\imath (kx+lz))\right].
$$
The Julia script, `linstab.jl`, located inside this folder, solves the viscous linear stability problem for stratified shear flow, returning the vertical velocity and buoyancy eigenfunctions, $\hat{v}(y)$ and $\hat{b}(y)$, and the corresponding growth rates, $\sigma$. Specifically, the code solves the following equations for 2D perturbations ($l=0$):
$$
\sigma(\hat{v}_{yy}-k^2\hat{v})=-\imath k U(y) \hat{v}_{yy}+\imath k U_{yy}\hat{v} + \nu (d^2_y-k^2)^2 \hat{v}-k^2\hat{b},
$$
$$
\sigma \hat{b}=-B_y\hat{v}-\imath k U(y)\hat{b}+\kappa(d^2_y-k^2)\hat{b}.
$$
At the start of `linstab.jl`, you can specify several parameters associated with the basic state and discretization. Select some parameters that permit shear instability by the Miles-Howard theorem (with $Ri=N^2/S^2<1/4$ somewhere in the flow). For example, $LY=1$, $h=1/10$, $S_0=10$, and $N^2_0=10$ seem to work well.

Optionally, edit these parameters to match your choice of parameters (the suggested ones listed above are in place now.)\\

Run the script `linstab.jl` in Julia, which will then plot the growth rate of the most unstable mode as a function of the horizontal wavenumber. How does the most unstable mode vary with the shear layer width, and the viscosity?

# Nonlinear simulations

