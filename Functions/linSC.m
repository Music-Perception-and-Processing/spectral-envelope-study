function [SC] = linSC(sig, fs, dyn_range, amp_exp)
% takes signal sig and computes spectral centroid based on long-term FFT

f = linspace(0,fs/2-1, fs/2)'; % frequencies 
S = fft(sig, fs); % take an fs-long FFT
S_abs = abs(S(1:end/2)); % distribution of spectral values
S_abs = S_abs./max(S_abs); 
S_abs(20*log10(S_abs) < -dyn_range) = 0; % dynamic range
S_abs = S_abs.^amp_exp; 
SC = sum(f.*S_abs)/sum(S_abs); % centroid