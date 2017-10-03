/* generate squarewave by over sampling */
// initial parameters *********************************************************/
fs = 44100/* Hz */;         // sampling rate
f = 880/* Hz */;           // frequecncy
multiple = 0:3;       // 44.1kHz * multiple oversampling
fc = fs / 2;        // cut off frequency
q = 1/sqrt(2);            // q-value
col = [1,5,3,2]; 
/******************************************************************************/

exec("..\sci\genWave02.sci");
exec("..\sci\getPowerSpectrum.sci");
exec("..\sci\snr.sci");

t = 0.0:1/fs:1.0-1/fs;
wav = zeros(length(multiple),length(t));
for i = multiple
    wav(i + 1,:) = genWave02(f, t, 2^i, fs/2, 1/sqrt(2))
    pow(i + 1,:) = getPowerSpectrum(wav(i + 1,:));
    sn(i + 1) = snr(pow(i + 1,:), f, (fs/2) / f);
    wavwrite(wav(i + 1,:), fs, "x" + string(2^multiple(i+1)) + "oversampling.wav");
end


/* plot wave data and power spectrum */
// plot wave data
for i = 1:length(multiple)
    clf();
    subplot(2,1,1);
    plot2d(t, wav(i,:), 2, rect=[0.0, -0.6, 4/f, 0.6]);
    xgrid(color(128,128,128));
    title("x" + string(2^multiple(i)) + "oversampling", 'fontsize',3)
    xlabel("time [ms]]");
    ylabel("wave");
    // plot power spectrum
    subplot(2,1,2);
    plot2d(fs * t(1:length(pow(i,:))), 10 * log10(pow(i,:)),2 ,rect=[0.0, -100, fs/2, 0]);
    xgrid(color(128,128,128));
    title("spectrum", 'fontsize',3)
    xlabel("freqency [Hz]");
    ylabel("power spectrum [dB]");
    xs2png(0, "x" + string(2^multiple(i)) + "oversampling.png")
end
