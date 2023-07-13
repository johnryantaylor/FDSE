This project will introduce you to Oceananigans and explore the dynamics of gravity currents

To start, we need to install Oceananigans. To do this, open VS Code (if you don't already have it open).
From the menu bar, select "View" and "Command Palette"
Enter "Julia: Start REPL" and press enter. This should bring up a window in VS Code with a Julia prompt.

Julia has a fantastic package manager for installing and updating add-on packages. To install Oceananigans, follow these steps:
1. To enter the package manager interface, press the "]" key. The "julia>" prompt should change to "pkg>".
2. Install Oceananigans by typing "add Oceananigans" and pressing enter (note that this may take a while since it downloads and installs all of the packages that Oceananigans depends on)
3. Next, install a plotting package by entering "add Plots". Julia has quite a few plotting packages to chose from, but this is the standard one and is good to start with.
4. Finally, install the JLD2 package by entering "add JLD2".  This installs a package called JLD2 which allows reading and writing in a native Julia HDF5-compatible file format.
5. After Oceananigans and JLD2 have downloaded and installed, exit the package manager by pressing the delete key

Now we're ready to run Oceananigans! To do this:
1. In the Explorer window of VS Code, navigate into the Project1 directory. If you don't see the FDSE folder, you can open it from GitHub Desktop using the Repository menu and selecting "Open in Visual Studio Code"
2. Double click on gravitycurrent.jl
3. Run the script by clicking on the right-pointing triangle to the right above the gravitycurrent.jl window






