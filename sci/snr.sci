function ret = snr(power, f, n)
    s = zeros(1, n);
    for i = 1:length(s);
        s(1, i) = power(1, f * i + 1);
        power(1,f * i + 1) = 0;
    end
    ret = 10 * log10(sum(s) / sum(power));
endfunction
