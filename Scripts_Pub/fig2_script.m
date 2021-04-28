% data
filenames = {...
    '/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/Cello/sus/pp/Cello_sus_pp_A3.wav', ...
    '/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/Cello/sus/ff/Cello_sus_ff_A3.wav', ...
    '/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/Violin/sus/pp/Violin_sus_pp_A3.wav', ...
    '/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/Violin/sus/ff/Violin_sus_ff_A3.wav', ...
    '/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/Cello/sus/pp/Cello_sus_pp_A5.wav', ...
    '/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/Cello/sus/ff/Cello_sus_ff_A5.wav', ...
    '/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/Violin/sus/pp/Violin_sus_pp_A5.wav', ...
    '/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/Violin/sus/ff/Violin_sus_ff_A5.wav'}; 

%cd('/Users/kaisiedenburg/ownCloud/Shared/VSL/Code/Data')
cd('/home/simon/ownCloud2/MusicProjects/Projects/VSL/Code/Data')
load('instr_data_new_v09.mat');

%% pitch grid 
clear dyn_lev; 
dyn_lev = 'mf'; 
F0s = [];
% get pitches
for nFam = 1:length(fieldnames(an.fam))-1 % family loop 
    fnames = fieldnames(an.fam);  % name of current family
    fname = fnames{nFam}; 
    artics = an.art.(fname); % get predefined articulation
    for nInstr = 1:length(an.fam.(fname)) % plot fit 
        iname = an.fam.(fname){nInstr}; % name of selected instrument
        F0s = [F0s; dat.(iname).(artics).(dyn_lev).x.F0];
    end
end
F0_grid = round(unique(F0s));


%% get settings
NFilt = 128;
dyn_range = 80;
amp_exp = 1;
fs = 44100;

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

%% plot it
cmap = colormap('lines'); 

figure;
pitches = {'A3', 'A3', 'A3', 'A3', 'A5', 'A5', 'A5', 'A5'}; 
for k = 1:length(filenames)
    subplot(4,4,(k))
    [sig, fs] = audioread(filenames{k}); 
    sig = sig(:,1); 
    %sig = randn(fs, 1); 

    S = fft(sig, fs); % take an fs-long FFT
    S_abs = abs(S(1:end/2)); % positive magnitude spectrum
    S_abs = S_abs./max(S_abs); 
    S_abs(20*log10(S_abs) < -dyn_range) = 0; % dynamic range
    erb_pow = ERB_mat*(S_abs.^amp_exp); % ERB magnitude/power
    erb_pow = erb_pow/sum(erb_pow); % scale to sum to one 
    SC = sum(f_erb.*erb_pow); % centroid
    efcc = dct(20*log10(erb_pow + 10^(-3)), [], 1); % erb FCC
    efcc(15:end) = 0; 
    s_shape = idct(efcc); % reconstruct 
    erb_plot = 20*log10(erb_pow/max(erb_pow));

    semilogx(f, 20*log10(S_abs), 'linewidth', 1, 'color', [.7 .7 .7]); hold on
    semilogx(f_erb, erb_plot, 'color', cmap(1,:)); hold on
    semilogx(f_erb, s_shape, '-', 'color', cmap(2,:).^2)
    semilogx([SC SC], [-100 0], '--', 'color', [.3 .3 .3], 'linewidth', 2); hold on

    xlim([80 16000])
    ylim([-80 0])
    %ylabel('Magnitude [dB]')
    set(gca, 'Box', 'Off')
    %title(plot_titles{k})
    %ylabel(pitches{k})
    text(4500, -5, strcat('F0= ', pitches{k}), 'FontSize', 18)
end
subplot(4,4,1)

% pitch-variant ERBs 
indd2 = [9:12];
dynn = [1 3 1 3];
dynamics = {'pp', 'mf', 'ff'}; 
inames = {'Cello', 'Cello', 'Violin', 'Violin'}; 
xticko = {num2str(F0_grid(25)), '', num2str(F0_grid(49)), '', num2str(F0_grid(73))}; 
for k = 1:length(inames)
    subplot(4,4,indd2(k))
    iname = inames{k}
    artics = 'det'; 
    % get ERB 
    dyn_lev = dynamics{dynn(k)}
    ERB_env_mean = dat.(iname).(artics).(dyn_lev).x.erb_magn(:,:);
    F0_ind_min = find(~(F0_grid - round(dat.(iname).(artics).(dyn_lev).x.F0(1)))); % smallest F0 of relevance
    F0_ind_max = F0_ind_min + size(dat.(iname).(artics).(dyn_lev).x.erb_magn, 1) - 1; % largest F0 of relevance
    mat_plot = zeros(length(F0_grid), 128); % prepare matrix that is independent of actual range but plots full range of all instruments
    mat_plot(F0_ind_min:F0_ind_max,:) = ERB_env_mean;
    imagesc(20*log10(abs((mat_plot')))); 
    %title(strcat(iname, 's'))
    x = F0_grid';   % get axis labels
    y = (f_erb); % get axis labels
    axis xy
    %set(gca, 'XTick', [16 40, 64])
    %set(gca, 'XTickLabel', {'C2', 'C4', 'C6'})
    set(gca, 'XTick', [25 37 49 61 73])
    set(gca, 'XTickLabel', xticko)
    %set(gca, 'YTick', (f_erb([20:20:120])/100)/10)
    set(gca, 'YTickLabel', num2str(round(f_erb([20:20:120])/100)/10))
end

% pitch-variant Cepstras 
indd2 = [13:16];
dynn = [1 3 1 3];
dynamics = {'pp', 'mf', 'ff'}; 
inames = {'Cello', 'Cello', 'Violin', 'Violin'}; 
dynrange = 10^(-3); 

for k = 1:length(inames)
    subplot(4,4,indd2(k))
    iname = inames{k}
    artics = 'det'; 
    % get ERB 
    dyn_lev = dynamics{dynn(k)};
    ERB_cepstra = abs(fft(log10(dat.(iname).(artics).(dyn_lev).x.erb_magn(:,:) + dynrange), [], 2));
    F0_ind_min = find(~(F0_grid - round(dat.(iname).(artics).(dyn_lev).x.F0(1)))); % smallest F0 of relevance
    F0_ind_max = F0_ind_min + size(dat.(iname).(artics).(dyn_lev).x.erb_magn, 1) - 1; % largest F0 of relevance
    mat_plot = zeros(length(F0_grid), 13); % prepare matrix that is independent of actual range but plots full range of all instruments
    mat_plot(F0_ind_min:F0_ind_max,:) = (ERB_cepstra(:,2:14));
    imagesc(20*log10(abs((mat_plot')))); 
    %title(strcat(iname, 's'))
    x = F0_grid';   % get axis labels
    y = (f_erb); % get axis labels
    axis xy
    set(gca, 'XTick', [25 37 49 61 73])
    set(gca, 'XTickLabel', xticko)
    %set(gca, 'YTick', [20:30:120])
    %set(gca, 'YTickLabel', round(f_erb([20:30:120])/100)/10)
end
subplot(4,4,1); 
ylabel('Level [dB]')
xlabel('Freq. [Hz]')     
title('Cello / pp')

subplot(4,4,2); 
title('Cello / ff')

subplot(4,4,3); 
title('Violin / pp')

subplot(4,4,4); 
title('Violin / ff')

subplot(4,4,5); 
ylabel('Level [dB]')
xlabel('Freq. [kHz]')
subplot(4,4,9); 
ylabel('Freq. [kHz]')
xlabel('F0 [Hz]')
subplot(4,4,13); 
ylabel('Coeff. No')
xlabel('F0 [Hz]')