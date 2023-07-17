function ddz(z)
    # First derivative matrix for independent variable z.
    # 2nd order centered differences.
    # Use one-sided derivatives at boundaries.
    # z is assumed to be evenly spaced.

    # Check for equal spacing
    if abs(std(diff(z)) / mean(diff(z))) > 0.000001
        println("ddz: values not evenly spaced!")
        d = NaN
        return
    end

    del = z[2] - z[1]
    N = length(z)

    d = zeros(N, N)
    for n in 2:N-1
        d[n, n-1] = -1.0
        d[n, n+1] = 1.0
    end
    d[1, 1] = -3.0
    d[1, 2] = 4.0
    d[1, 3] = -1.0
    d[N, N] = 3.0
    d[N, N-1] = -4.0
    d[N, N-2] = 1.0
    d = d / (2 * del)
    return d
end
