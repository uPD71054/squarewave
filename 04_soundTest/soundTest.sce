clear;
clf;
// initial parameters *********************************************************/
fs = 44100/* Hz */;           // sampling rate
f0 = 2000.000/* Hz */;            // note frequency
mktable = 0;                  // make or load table.dat flag(0:false, otherwise:true)
table_size = 2^10;            // size of table
band_limit = fs / (f0) / 2;   // addition upper limit of fourier series
col = [5,3,2];                // glaph color
/******************************************************************************/

exec("..\sci\genWave02.sci");
exec("..\sci\genWave03.sci");
exec("..\sci\getPowerSpectrum.sci");
exec("..\sci\snr.sci");

// generate wave data
t = 0.0:1/fs:1.0-1/fs;
wav = zeros(3,length(t));
wav(1,:) = 0.5*squarewave(2*%pi*f0*t);
wav(2,:) = genWave02(f0,t,4,fs/2,1/sqrt(2))
wav(3,:) = genWave03(f0,t,0,table_size,band_limit);

wavwrite(wav(1,:), fs, "sq.wav");
wavwrite(wav(2,:), fs, "oversampling.wav");
wavwrite(wav(3,:), fs, "table.wav");

// calc fourire spectrum
for i = 1:3
    pow(i,:) = getPowerSpectrum(wav(i,:));
    sn(i) = floor(snr(pow(i,:),f0,fs/f0/2));
end


// show result
subplot(2,1,1);
for i = 1:3;
    plot2d(t, wav(i,:), col(i), rect=[0.0, -0.6, 4/f0, 0.6]);
end
xgrid(color(128,128,128));
title("wave (frequency = " + string(f0) + "[Hz])", 'fontsize',3);
xlabel("time [ms]]");
ylabel("wave");
legend("squarewave","over_sampling","lookup-table");
subplot(2,1,2);
for i = 1:3;
    plot2d(fs * t(1:length(pow(i,:))), 10 * log10(pow(i,:)),col(i) ,rect=[0.0, -100, fs/2, 0]);
end
xgrid(color(128,128,128));
title("spectrum", 'fontsize',3)
xlabel("freqency [Hz]");
ylabel("power spectrum [dB]");
disp(sn);
