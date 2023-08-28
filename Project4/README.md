# Ocean ecosystem dynamics

Microscopic algae called phytoplankton form the foundation of the ocean's food web and are responsible for about half of the primary production (photosynthesis) on the earth.
When conditions are favorable, phytoplankton often appear in rapid growth events called blooms, but they can also die out quickly when their growth is limited by nutrients or grazing by predators called zooplankton.
This is illustrated in the figure below which shows two quasi true-color satellite images of the New Zealand coastline, separated by about two weeks. In the second image, a dramatic phytoplankton bloom has changed the color of the water and revealing swirling ocean eddies.

![phytoplankton](./images/phytoplankton.jpg)

Fluid dynamics has a very strong influence on phytoplankton (and hence the global carbon cycle). Sunlight needed for photosynthesis illuminates a relatively thin layer of the upper ocean. When phytoplankton are advected into the dark ocean interior for extended periods of time, they will become dormant or die. Different populations of phytoplankton, the nutrients that they rely on, and their predators are co-mingled and mixed by ocean currents.

This project will use [OceanBioME.jl](https://github.com/OceanBioME/OceanBioME.jl)) (Ocean Biogeochemical Modelling Environment), a Julia package developed in the DAMTP Ocean Dynamics group at Cambridge to provide biogeochemical models for Oceananigans. OceanBioME has powerful features including state-of-the-art biogeochemical models, models for the air-sea gas exchange, sediment models, and biologically-active particles. Here, we will use OceanBioME to provide a model of the predator-prey dynamics of a population of phytoplankton and zooplankton. We will then use Oceananigans to explore how advection and diffusion modifies the intrinsic ecosystem dynamics.

# 0-dimensional 'box' model
Although OceanBioME is primarily intended to be coupled with Oceananigans, it can be used on its own to integrate the equations describing the dynamics of the ocean ecosystem. This is useful for developing an understanding of the intrinsic ecosystem dynamics, before adding the complications of fluid dynamics, and for debugging new models. 

The evolving populations of phytoplankton and zooplankton can be modeled as a predator-prey system. A classic formulation of this is known as the Lotka-Volterra equations, which can be written

$$ \frac{dP}{dt} = \alpha P - \beta P Z $$,

$$ \frac{dZ}{dt} = \delta \beta P Z - \gamma Z$$,

where $P$ and $Z$ are the concentrations of phytoplankton and zooplankton, respectively. The constants in the model are the phytoplankton growth rate, $\alpha$, the grazing rate, $\beta$, the grazing efficiency, $\delta$, and the zooplankton mortality rate, $\gamma$. These equations are implemented in `PZ.jl`. You shouldn't need to edit this file unless you want to change the form of the equations that are being considered. Default values of the parameters are set in this file, but you can also set these parameters when you run the model. Note also that the phytoplankoton growth rate is modified by a depth-dependent function to mimic the level of light exposure. This will be used in the following sections and has no impact on the box model (where the depth is z=0 by default).








