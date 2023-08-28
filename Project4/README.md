# Ocean ecosystem dynamics

Microscopic algae called phytoplankton form the foundation of the ocean's food web and are responsible for about half of the primary production (photosynthesis) on the earth.
As demonstrated in the figures below, when conditions are favorable, phytoplankton often appear in rapid growth events called blooms, but they can also die out quickly when their growth is limited by nutrients or grazing by predators called zooplankton.

![phytoplankton](./images/phytoplankton.jpg)

Fluid dynamics has a very strong influence on phytoplankton (and hence the global carbon cycle). Sunlight needed for photosynthesis illuminates a relatively thin layer of the upper ocean. When phytoplankton are advected into the dark ocean interior for extended periods of time, they will become dormant or die. Different populations of phytoplankton, the nutrients that they rely on, and their predators are co-mingled and mixed by ocean currents.

This project will use [OceanBioME.jl](https://github.com/OceanBioME/OceanBioME.jl)) (Ocean Biogeochemical Modelling Environment), a Julia package developed in the DAMTP Ocean Dynamics group at Cambridge to provide biogeochemical models for Oceananigans. OceanBioME has powerful features including state-of-the-art biogeochemical models, models for the air-sea gas exchange, sediment models, and biologically-active particles. Here, we will use OceanBioME to provide a model of the predator-prey dynamics of a population of phytoplankton and zooplankton. We will then use Oceananigans to explore how advection and diffusion modifies the intrinsic ecosystem dynamics.




