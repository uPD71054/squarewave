// Band-Limited Impluse Train
// initial parameters *********************************************************/
fs = 44100/* Hz */;     // sampling rate
f = 440/* Hz */;     // frequecncy
/******************************************************************************/
exec("blit.sci");
exec("getPowerSpectrum.sci")

// The formular for a BLIT is as follows:
//      BLIT(x) = (m/p) * (sin(PI*x*m/p)/(m*sin(PI*x/p))
// p is the exact numbers of samples per period (floating point value)
p = fs / f;   // sampleRate/frequency
// m numbers of samples of a period (must be an odd integer value)
m = 2 * floor(p / 2) + 1;

// Generate wave
t = 0 : 1/fs : 1 - 1/fs;
wav = zeros(1, length(t));
wav(1, 1) = 0.5
for i = 1:length(t) - 1
    wav(1, i + 1) = wav(1, i) + blit(p, m, i) - blit(p, m, i + int(m / 2))
end

// power spectrum
pow = getPowerSpectrum(wav);

playsnd(wav, fs);
wavwrite(wav,fs , "blit.wav");


clf();
subplot(2,1,1);
plot2d(t , wav, 2, rect=[0.0, -0.6, 4/f, 0.6]);
xgrid(color(128,128,128));
title("wave", 'fontsize',3)
xlabel("time [ms]]");
ylabel("wave");
// plot power spectrum
subplot(2,1,2);
plot2d(0:length(pow)-1, 10 * log10(pow), 2, rect=[0.0,-100, fs/2,0.0]);
xgrid(color(128,128,128));
title("spectrum", 'fontsize',3)
xlabel("freqency [Hz]");
ylabel("power spectrum [dB]");


/* 参考****** ******************************************************************
BLITのお話 | g200kg Music & Software
    URL:http://www.g200kg.com/archives/2012/10/blit.html
Bandlimited waveforms synopsis
    URL:http://www.musicdsp.org/files/waveforms.txt
*******************************************************************************/
