# Just run all the projects to check they're working

@info "Running project 1"
include("../Project1/gravitycurrent.jl")

@info "Running project 2"
include("../Project2/KH.jl")

@info "Running project 3"
include("../Project3/rossbywave.jl")

@info "Running project 4"
include("../Project4/PZ_box.jl")
include("../Project4/PZ_column.jl")
include("../Project4/PZ_cavity.jl")
