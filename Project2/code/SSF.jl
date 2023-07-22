function SSF(z, U, B, k, l, nu, kappa, iBC1=[1, 0], iBCN=iBC1, imode=1)
    # USAGE: [sig, w, b] = SSF(z, U, B, k, l, nu, kappa, iBC1, iBCN, imode)
    #
    # Stability analysis for a viscous, diffusive, stratified, parallel shear flow
    # INPUTS:
    # z = vertical coordinate vector (evenly spaced)
    # U = velocity profile
    # B = buoyancy profile (Bz=squared BV frequency)
    # k, l = wave vector
    # nu, kappa = viscosity, diffusivity
    # iBC1 = boundary conditions at z=z[1]
    #    (1) velocity: 1=rigid (default), 0=frictionless
    #    (2) buoyancy: 1=insulating, 0=fixed-buoyancy (default)
    # iBCN = boundary conditions at z=z[end].
    #        Definitions as for iBC1. Default: iBCN=iBC1.
    # imode = mode choice (default imode=1)
    #         imode=0: output all modes, sorted by growth rate
    #
    # OUTPUTS:
    # sig = growth rate of FGM
    # w = vertical velocity eigenfunction
    # b = buoyancy eigenfunction
    #
    # CALLS:
    # ddz, ddz2, ddz4
    #
    # MATLAB version by W. Smyth, OSU, Nov04
    # Julia version by John Taylor with help from Chat-GTP

    ########################################
    # Stage 1: Preliminaries
    #

    # Check for equal spacing
    if abs(std(diff(z)) / mean(diff(z))) > 0.000001
        println("SSF: values not evenly spaced!")
        sig = NaN
        return
    end

    # Defaults
    if isempty(iBC1)
        iBC1 = [1, 0]
    end
    if isempty(iBCN)
        iBCN = iBC1
    end
    if isempty(imode)
        imode = 1
    end

    # Define constants
    ii = im
    del = mean(diff(z))
    N = length(z)
    kt = sqrt(k^2 + l^2)

    ########################################
    # Stage 2: Derivative matrices and BCs
    #
    D1 = ddz(z)  # 1st derivative matrix with 1-sided boundary terms
    Bz = D1 * B

    D2 = ddz2(z)  # 2nd derivative matrix with 1-sided boundary terms
    Uzz = D2 * U

    # Impermeable boundary
    D2[1, :] .= 0
    D2[1, 1] = -2 / del^2
    D2[1, 2] = 1 / del^2
    D2[end, :] .= 0
    D2[end, end] = -2 / del^2
    D2[end, end-1] = 1 / del^2

    # Fourth derivative
    D4 = ddz4(z)

    # Rigid or frictionless BCs for 4th derivative
    D4[1, :] .= 0
    D4[1, 1] = (5 + 2 * iBC1[1]) / del^4
    D4[1, 2] = -4 / del^4
    D4[1, 3] = 1 / del^4
    D4[2, :] .= 0
    D4[2, 1] = -4 / del^4
    D4[2, 2] = 6 / del^4
    D4[2, 3] = -4 / del^4
    D4[2, 4] = 1 / del^4
    D4[end, :] .= 0
    D4[end, end] = (5 + 2 * iBCN[1]) / del^4
    D4[end, end-1] = -4 / del^4
    D4[end, end-2] = 1 / del^4
    D4[end-1, :] .= 0
    D4[end-1, end] = -4 / del^4
    D4[end-1, end-1] = 6 / del^4
    D4[end-1, end-2] = -4 / del^4
    D4[end-1, end-3] = 1 / del^4

    # Derivative matrix for buoyancy
    D2b = ddz2(z)  # 2nd derivative matrix with 1-sided boundary terms
    # Fixed-buoyancy boundary
    D2b[1, :] .= 0
    D2b[1, 1] = -2 / del^2
    D2b[1, 2] = 1 / del^2
    D2b[end, :] .= 0
    D2b[end, end] = -2 / del^2
    D2b[end, end-1] = 1 / del^2
    # Insulating boundaries
    if iBC1[2] == 1
        D2b[1, :] .= 0
        D2b[1, 1] = -2 / (3 * del^2)
        D2b[1, 2] = 2 / (3 * del^2)
    end
    if iBCN[2] == 1
        D2b[end, :] .= 0
        D2b[end, end] = -2 / (3 * del^2)
        D2b[end, end-1] = 2 / (3 * del^2)
    end

    ########################################
    # Stage 3: Assemble stability matrices
    #
    # Laplacian and squared Laplacian matrices
    Id = I(N)
    L = D2 - kt^2 * Id
    Lb = D2b - kt^2 * Id
    LL = D4 - 2 * kt^2 * D2 + kt^4 * Id

    N2 = 2 * N
    NP = N + 1
    A = zeros(Complex{Float64}, N2, N2)
    B = zeros(Complex{Float64}, N2, N2)

    # Assemble matrix A
    A[1:N, 1:N] .= L
    A[1:N, NP:N2] .= Id * 0
    A[NP:N2, 1:N] .= Id * 0
    A[NP:N2, NP:N2] .= Id

    # Compute submatrices of B using Julia syntax
    b11 = -im * k * Diagonal(U) * L + im * k * Diagonal(Uzz) + nu * LL
    b21 = -Diagonal(Bz)
    b12 = -kt^2 * Id
    b22 = -im * k * Diagonal(U) + kappa * Lb

    # Assemble matrix B
    B[1:N, 1:N] .= b11
    B[1:N, NP:N2] .= b12
    B[NP:N2, 1:N] .= b21
    B[NP:N2, NP:N2] .= b22

    ########################################
    # Stage 4: Solve eigenvalue problem and extract results
    #
    # Solve generalized eigenvalue problem
    F = eigen(B, A)
    e = F.values
    v = F.vectors

    sigma = real.(e)

    # Sort eigvals
    sr = sort(sigma, rev=true)
    ind = sortperm(sigma, rev=true)
    sigma = sr[:]
    v = v[:, ind]

    # Extract the selected mode(s)
    if imode == 0
        return sigma, v[1:N, :], v[NP:N2, :]
    elseif imode > 0
        return sigma[imode], v[1:N, imode], v[NP:N2, imode]
    end
end
