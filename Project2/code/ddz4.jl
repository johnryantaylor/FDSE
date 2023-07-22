function ddz4(z)
    # Compute fourth derivative matrix for independent variable vector z.

    # Check for equal spacing
    if abs(std(diff(z)) / mean(diff(z))) > 0.000001
        println("ddz4: values not evenly spaced!")
        d = NaN
        return
    end

    del = z[2] - z[1]
    N = length(z)

    d = zeros(N, N)
    for n in 3:N-2
        d[n, n-2] = 1.0
        d[n, n-1] = -4.0
        d[n, n] = 6.0
        d[n, n+1] = -4.0
        d[n, n+2] = 1.0
    end
    # Assume f(0)=f(N+1)=f''(0)=f''(N+1)=0 (1-sided BC's not needed)
    d[1, 1] = 5.0
    d[1, 2] = -4.0
    d[1, 3] = 1.0
    d[2, 1] = -4.0
    d[2, 2] = 6.0
    d[2, 3] = -4.0
    d[2, 4] = 1.0
    d[N-1, N] = -4.0
    d[N-1, N-1] = 6.0
    d[N-1, N-2] = -4.0
    d[N-1, N-3] = 1.0
    d[N, N] = 5.0
    d[N, N-1] = -4.0
    d[N, N-2] = 1.0
    d = d / del^4
    return d
end
