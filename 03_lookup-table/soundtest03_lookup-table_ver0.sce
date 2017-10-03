/* generate squarewave by bandlimited lookup-table */
// initial parameters *********************************************************/
fs = 44100/* Hz */;         // sampling rate
f = 880/* Hz */;           // note frequency
mktable = 0;                // make or load table.dat flag(0:false, otherwise:true)
table_size = 2^10;          // size of table
band_limit = fs / f / 2;   // addition upper limit of fourier series
/******************************************************************************/

exec("..\sci\getPowerSpectrum.sci");
exec("..\sci\snr.sci");

// make or load wave lookup-tabel
if (dir("table.dat").name(1)=="table.dat") & (mktable ~= 0)
    disp("load table.dat");
    load("table.dat", "table");
else
    disp("make tabel00.dat");
    table = zeros(1,table_size);
    for i = 1:2:floor(band_limit)
        table = table + sin(2 * %pi * i * (0:length(table)-1) / table_size) / i;
    end
    table = 0.5 * table / max(table);
    save("table.dat", "table");
end

// generate wave data
t = 0:fs-1;
phase = pmodulo(table_size * f * t / fs, table_size);
wav = interp1(0:(table_size - 1), table, phase, "linear", 0);
// power spectrum
pow = abs(fft(wav) / length(wav))^2;

p = pow;
index = 0;
signal = zeros(1,14);
for i = 1:14;
    [signal(1, i), index] = max(p);
    p(i,index) = 0;
end

signal_power = sum(signal)
noise_power = sum(p);

// play wave data
playsnd(wav, fs);
wavwrite(wav,fs , "table.wav");



/* plot wave data and power spectrum */
// plot wave data
clf();
subplot(2,1,1);
plot2d(t ./ fs, wav, 2, rect=[0.0, -0.6, 4/f, 0.6]);
xgrid(color(128,128,128));
title("wave", 'fontsize',3)
xlabel("time [ms]]");
ylabel("wave");
// plot power spectrum
subplot(2,1,2);
plot2d(t - fs/2, 10 * log10(fftshift(pow)), 2, rect=[0.0,-100, fs/2,0.0]);
xgrid(color(128,128,128));
title("spectrum", 'fontsize',3)
xlabel("freqency [Hz]");
ylabel("power spectrum [dB]");
