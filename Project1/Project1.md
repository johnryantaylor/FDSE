#Getting started
This project will introduce you to Oceananigans and explore the dynamics of gravity currents

To start, we need to install Oceananigans. To do this, open VS Code (if you don't already have it open).
From the menu bar, select "View" and "Command Palette". Enter "Julia: Start REPL" and press enter. This should bring up a window in VS Code with a Julia prompt.

Julia has a fantastic package manager for installing and updating add-on packages. To install Oceananigans, follow these steps:
1. To enter the package manager interface, press the "]" key. The "julia>" prompt should change to "pkg>".
2. Install Oceananigans by typing "add Oceananigans" and pressing enter (note that this may take a while since it downloads and installs all of the packages that Oceananigans depends on)
3. Next, install a plotting package by entering "add Plots". Julia has quite a few plotting packages to chose from, but this is the standard one and is good to start with.
4. Finally, install the JLD2 package by entering "add JLD2".  This installs a package called JLD2 which allows reading and writing in a native Julia HDF5-compatible file format.
5. After Oceananigans and JLD2 have downloaded and installed, exit the package manager by pressing the delete key

Now we're ready to run Oceananigans! 🙌 To do this:
1. In the Explorer window of VS Code, navigate into the Project1 directory. If you don't see the FDSE folder, you can open it from GitHub Desktop using the Repository menu and selecting "Open in Visual Studio Code"
2. Double click on gravitycurrent.jl
3. Run the script by clicking on the right-pointing triangle to the right above the gravitycurrent.jl window

The model will run for 20 time units and print messages so that you can keep track of the progress. You can stop the model running at any time by pressing CONTROL-C, but if it isn't too slow, let the run finish. At the end of the simulation, the script will call plot_gravitycurrent.jl which will create a movie of the output called "gravitycurrent.mp4". You should be able to open and view this movie in VS code, or you can open it with a movie player of your choice. A figure should also appear which shows the buoyancy evaluated at the bottom of the model domain as a function of distance in the x-direction and time.

Now that the code is running, we're ready to do some science! 🧪

#Introduction to Oceananigans
Although it was designed to simulate ocean physics, Oceananigans is a powerful general purpose computational fluid dyanmics (CFD) code. Here, we will use Oceananigans to explore the dynamics of gravity currents in the lock-release problem.

Oceananigans can solve equations in dimensional or non-dimensional form. In this project we will use it to solve the non-dimensional incompressible, Boussinesq equations, which can be written:
$$\frac{\partial \mathbf{u}^*}{\partial t^*}+\mathbf{u}^*\cdot \nabla_* \mathbf{u}^*=-\nabla_* p^*+\frac{1}{Re} \nabla_*^2\mathbf{u}^*+Ri \hspace{2pt} b^* \hat{g},$$
$$\frac{\partial b^*}{\partial t^*}+\mathbf{u}^*\cdot \nabla_* b^* = \frac{1}{Re Pr} \nabla_*^2 b^*,$$
$$\nabla_*\cdot \mathbf{u}^* = 0,$$
where $\mathbf{u}^*=(u^*,v^*)$ is the 2D velocity vector, $\nabla^*=(\partial/\partial x^*,\partial/\partial y^*)$, and $\hat{g}$ is a unit vector pointing in the direction of gravity. Here $*$ indicates non-dimensional quantities, which have been normalized using a length scale, $L$, velocity, $U_0$, and buoyancy, $B_0$. Note that the constant density, $\rho_0$, has been absorbed into the definition of the non-dimensional pressure, $p^*$. In this case, the non dimensional Reynolds, Richardson, and Prandtl numbers are:
\begin{equation}
Re\equiv \frac{U_0 L}{\nu}, \quad Ri\equiv \frac{B_0 L}{U_0^2}, \quad Pr\equiv \frac{\nu}{\kappa},
\end{equation}
and $\nu$ and $\kappa$ are the kinematic viscosity and molecular diffusivity, respectively. 







