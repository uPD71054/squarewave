function ret = getPowerSpectrum(y)
    // normalized fft.
    Y = (sqrt(2)/length(y)) * fft(y);
    // return one-sided power spectrum.
    ret = abs(Y(1,1:floor(length(Y)/2) + 1) ) .^ 2;
endfunction
