"""
PZ.jl
This function defines a Phytoplankon-Zooplankton (Predator-Prey or Lotka-Volterra) model 

Tracers
=======
* Phytoplankton (prey): P 
* Zooplankton (predator): Z 
"""

using OceanBioME: ContinuousFormBiogeochemistry

import Oceananigans.Biogeochemistry: required_biogeochemical_tracers,
                                     required_biogeochemical_auxiliary_fields,
                                     update_biogeochemical_state!,
                                     biogeochemical_drift_velocity,
                                     biogeochemical_auxiliary_fields

# The following struct defines the default values of the parameters (which can be overridden by the user)
@kwdef struct PhytoplanktonZooplankton{FT, LA, S, W, P} <:ContinuousFormBiogeochemistry{LA, S, P}
    phytoplankton_growth_rate :: FT = 1.0   
    grazing_rate :: FT = 1.0 
    grazing_efficiency :: FT = 0.5   
    zooplankton_mortality_rate :: FT = 0.25
    light_decay_length :: FT = 0.2
    light_amplitude :: FT = 1.0

    light_attenuation_model :: LA = nothing
    sediment_model :: S  = nothing
  sinking_velocity :: W  = 0.0
         particles :: P  = nothing
end   

# The following tells OceanBioME and Oceananigans which tracers are needed
required_biogeochemical_tracers(::PhytoplanktonZooplankton) = (:P, :Z)

function light(a,λ,z)
    a * exp(z/λ)    
end  

# The following function defines the forcing (RHS) for the phytoplankton (prey)
# Note that when running as a box model (PZ_box.jl), z = 0
@inline function (bgc::PhytoplanktonZooplankton)(::Val{:P}, x, y, z, t, P, Z)
    α = bgc.phytoplankton_growth_rate
    β = bgc.grazing_rate
    δ = bgc.grazing_efficiency
    γ = bgc.zooplankton_mortality_rate
    λ = bgc.light_decay_length
    a = bgc.light_amplitude
    return light(a,λ,z) * α * P - β * P * Z
end

# The following function defines the forcing (RHS) for the zooplankton (predator)
@inline function (bgc::PhytoplanktonZooplankton)(::Val{:Z}, x, y, z, t, P, Z)
    α = bgc.phytoplankton_growth_rate
    β = bgc.grazing_rate
    δ = bgc.grazing_efficiency
    γ = bgc.zooplankton_mortality_rate
    return β *δ * P * Z - γ * Z
end

using OceanBioME: BoxModel
import OceanBioME.BoxModels: update_boxmodel_state!



