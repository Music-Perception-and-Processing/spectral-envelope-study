function [SC, erb_pow] = erbSC(sig, fs, dyn_range, amp_exp, NFilt)
% takes signal sig and computes spectral centroid based on long-term ERB binning
% uses dynamic range, and amplitude compression using amp_exp

% still slower than necessary, because the ERB matrix ixcomputed every
% time

f = linspace(0,fs/2-1, fs/2)'; % frequencies 
%NFilt = 64; % number of auditory filters 
f_erb = round(audspace(0, fs/2, NFilt, 'erb'))'; % erb scale 
fbw = audfiltbw(f_erb);
ERB_mat = zeros(length(f_erb), fs/2);
for nBand = 1:length(f_erb)
    ERB_mat(nBand, :) = (f_erb(nBand) - fbw(nBand)/2 <= f) & ...
        (f < f_erb(nBand) + fbw(nBand)/2); 
end
ERB_mat = ERB_mat./repmat(sum(ERB_mat), NFilt, 1);% correct for overlapping filters 
S = fft(sig, fs); % take an fs-long FFT
S_abs = abs(S(1:end/2)); % positive magnitude spectrum
S_abs = S_abs./max(S_abs); 
S_abs(20*log10(S_abs) < -dyn_range) = 0; % dynamic range
erb_pow = ERB_mat*(S_abs.^amp_exp); % ERB magnitude/power
erb_pow = erb_pow/sum(erb_pow); % scale to sum to one 
SC = sum(f_erb.*erb_pow); % centroid