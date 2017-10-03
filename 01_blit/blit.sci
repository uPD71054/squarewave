function ret = blit(p, m, x)
    D = sin(%pi * x / p);
    N = sin(%pi * x * m / p);
    
    if abs(D) <= 1 * 10^(-6) 
        ret = cos(%pi * x * m / p) / (cos(%pi * x / p));
    else
        ret = N / (D * p);
    end
endfunction
