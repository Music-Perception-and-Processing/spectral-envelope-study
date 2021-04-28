function [erbfcc, erb_pow] = erbfcc(sig, fs)
% takes signal sig and computes spectral centroid based on long-term ERB binning

% still slower than necessary, because the ERB matrix is computed every
% time

f = linspace(0,fs/2-1, fs/2)'; % frequencies 
NFilt = 128; % number of auditory filters 
f_erb = round(audspace(0, fs/2, NFilt, 'erb'))'; % erb scale 
fbw = audfiltbw(f_erb);
ERB_mat = zeros(length(f_erb), fs/2);
for nBand = 1:length(f_erb)
    ERB_mat(nBand, :) = (f_erb(nBand) - fbw(nBand)/2 <= f) & ...
        (f < f_erb(nBand) + fbw(nBand)/2); 
end
S = fft(sig, fs); % take an fs-long FFT
SS = abs(S(1:end/2)); % positive magnitude spectrum
erb_pow = ERB_mat*(SS.^2); % ERB based power
erb_pow(erb_pow<0) = 0; % avoid negative entries (why?)
erbfcc = dct(log10(erb_pow));