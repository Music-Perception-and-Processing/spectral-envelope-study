
% get data and settings
clear all
hdir = '/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/';
cd(hdir)
ddd = dir; 
instr = {ddd(:).name};
instr = setdiff(instr, {'.DS_Store', '..', '.', 'instr_data_new_v_01.mat'});
dynamics = {'pp', 'mf', 'ff'}; 
fs = 44100;

%% define analysis scope
clear an
% instrument families
an.fam.Vocals = fliplr({'VocalBass', 'VocalBaritone', 'VocalTenor', 'VocalAlto', 'VocalMSoprano', 'VocalSoprano', 'VocalCSoprano'}); 
an.fam.Strings = fliplr({'Bass', 'Cello', 'Viola', 'Violin'});
an.fam.Flutes = fliplr({'FluteBass', 'FluteAlto', 'Flute', 'FlutePiccolo'});
an.fam.Recorders = fliplr({'RecorderBass', 'RecorderTenor', 'RecorderAlto', 'RecorderSoprano'}); 
an.fam.Clarinets = fliplr({'ClarinetContrabass', 'ClarinetBass', 'ClarinetBassethorn', 'ClarinetBb', 'ClarinetEb'});
an.fam.Saxophones = fliplr({'SaxophoneBass', 'SaxophoneBaritone', 'SaxophoneTenor', 'SaxophoneAlto', 'SaxophoneSoprano'});
an.fam.Oboes = fliplr({'Heckelphone', 'OboeEnglishHorn', 'OboeFrench'}); 
an.fam.Bassoons = fliplr({'BassoonContra', 'Bassoon'}); 
an.fam.Trumpets = fliplr({'TrumpetBass', 'Cornet', 'TrumpetC', 'TrumpetPiccolo'}); 
an.fam.Trombones = fliplr({'TromboneContrabass', 'Cimbasso', 'TromboneBass', 'TromboneTenor', 'TromboneAlto'}); 
an.fam.Horns = ({'HornViennese', 'Horn'}); 
an.fam.Tubas = ({'Flugelhorn', 'Wagnertuba', 'Euphonium', 'Tuba', 'TubaContrabass'});
an.fam.Test = {'Test1', 'Test2'}; 

an.fam.Keys = fliplr({'Bosendorfer', 'Cembalo', 'OrganManualklavFlutes', 'OrganManualklavPlenum'}); 
an.fam.Pluckedstring = fliplr({'GuitarConcert', 'Harp'}); % this can be extended for study 2 with impulsive sounds
an.fam.Harmonicperc = fliplr({'VibraphoneMotorOff', 'Marimbaphone', 'Xylophone', 'Celesta', 'Glockenspiel'}); 
an.fam.Inharmonicperc = fliplr({'PercussionTubularBells', 'PercussionPlateBells', 'PercussionGongs'}); 

% get all the names straight
an.names.Vocals = fliplr({'Bass', 'Barit', 'Tenor', 'Alto', 'MSopr', 'Sopr', 'CSopr'}); 
an.names.Strings = fliplr({'Bass', 'Cello', 'Viola', 'Violin'});
an.names.Flutes = fliplr({'Bass', 'Alto', 'CFlute', 'Piccolo'});
an.names.Recorders = fliplr({'Bass', 'Tenor', 'Alto', 'Soprano'}); 
an.names.Clarinets = fliplr({'Contrab', 'Bass', 'Basseth', 'Bb', 'Eb'});
an.names.Saxophones = fliplr({'Bass', 'Baritone', 'Tenor', 'Alto', 'Soprano'});
an.names.Oboes = fliplr({'Heckelphone', 'EnglishHorn', 'FrenchOboe'}); 
an.names.Bassoons = fliplr({'ContraBassoon', 'Bassoon'}); 
an.names.Trumpets = fliplr({'Bass', 'Cornet', 'C', 'Piccolo'}); 
an.names.Trombones = fliplr({'Contrabass', 'Cimbasso', 'Bass', 'Tenor', 'Alto'}); 
an.names.Horns = ({'VienneseH', 'FrenchHorn'}); 
an.names.Tubas = ({'Flugelhorn', 'Wagnertuba', 'Euphonium', 'Tuba', 'ContrbTuba'});
an.names.Test = {'Test1', 'Test2', 'Impulse'}; 

an.names.Keys = fliplr({'Bosendorfer', 'Cembalo', 'OrganFlutes', 'OrganPlenum'}); 
an.names.Pluckedstrings = fliplr({'ConcertGuitar', 'Harp'}); % this can be extended for study 2 with impulsive sounds
an.names.Harmonicperc = fliplr({'Vibraphone', 'Marimbaphone', 'Xylophone', 'Celesta', 'Glockenspiel'}); 
an.names.Inharmonicperc = fliplr({'TubularBells', 'PlateBells', 'Gongs'}); 

% articulations
an.art.Strings = 'det';
an.art.Vocals = 'susAA'; 
an.art.Flutes = 'sus';
an.art.Recorders = 'sus'; 
an.art.Clarinets = 'sus'; 
an.art.Saxophones = 'susVib';
an.art.Oboes = 'sus'; 
an.art.Bassoons = 'sus';
an.art.Trumpets = 'sus'; 
an.art.Trombones = 'sus'; 
an.art.Horns = 'sus';
an.art.Tubas = 'sus';
an.art.Keys = 'tones'; 
an.art.Pluckedstring = 'sus'; 
an.art.Harmonicperc = 'tones'; 
an.art.Inharmonicperc = 'tones'; 
an.art.Test = 'tones'; 

%% do feature extraction
% clear dat
% for nFam = 1:length(fieldnames(an.fam)) % family loop 
%     fnames = fieldnames(an.fam);  % name of current family
%     fname = fnames{nFam}
%     for nInstr = 1:length(an.fam.(fname)) % instrument loop
%         iname = an.fam.(fname){nInstr}; % name of selected instrument 
%         artics = an.art.(fname); % get predefined articulation
%         for nDyn = 1:length(dynamics) % dynamics loop
%             dyns = dynamics{nDyn}; 
%             cd(strcat(hdir, iname, '/', artics,'/', dyns))
%             d = wavdir();
%             f0_all = []; 
%             for k = 1:length(d) % pre-sort files according to f0
%                 filen = d(k).name;
%                 undersc = strfind(filen, '_'); 
%                 notename = filen(undersc(end)+1:end-4); 
%                 f0_all(k) = muspitch2freq(notename); % get pitch 
%             end
%             clear isort
%             [~,isort] = sort(f0_all); 
% 
%             for k = 1:length(d) % read audio and do feature extraction
%                 % get notename and pitch, again
%                 filen = d(isort(k)).name;
%                 undersc = strfind(filen, '_'); 
%                 notename = filen(undersc(end)+1:end-4); 
%                 f0 = muspitch2freq(notename); % get pitch 
% 
%                 % load and analyse
%                 [sig_o, fs] = audioread(filen); % ready 
%                 nArt = 1;
%                 %dat.(iname).(artics).(dyns).x.name(k) = filen;
%                 dat.(iname).(artics).(dyns).x.F0(k) = f0; 
%                 [eSC,erb_magn] = erbSC(sig_o(:,1), fs, 90, 1, 128); % left channel
%                 dat.(iname).(artics).(dyns).x.erbSC(k) = eSC; % SC
%                 dat.(iname).(artics).(dyns).x.erb_magn(k,:) = erb_magn; % filter magnitudes 
%                 dat.(iname).(artics).(dyns).x.linSC(k) = linSC(sig_o(:,1), fs, 60, 1); % left channel
%                 %dat.(iname).(artics).(dyns).x.erbSCcompr(k) = erbSC(sig_o(:,1), fs, 60, .6); % left channel
%                 %dat.(iname).(artics).(dyns).x.linSCcompr(k) = linSC(sig_o(:,1), fs, 60, .6); % left channel
%             end
%             nFam
%             nInstr
%         end
%     end
% end
% cd('/Users/kaisiedenburg/ownCloud/Shared/VSL/Code/Data')
% save('instr_data_new_v06.mat', 'dat')

%% load data 
%cd('/Users/kaisiedenburg/ownCloud/Shared/VSL/Code/Data')
cd('/home/simon/ownCloud2/VSL/ALL_VSL_Sounds/')
load('instr_data_new_v06.mat');

T_bound = readtable('register_boundaries.xlsx');

%% extract register ground truth 
ind_reg = 0; 
for nFam = 1:12
    fnames = fieldnames(an.fam);  % name of current family
    fname = fnames{nFam}; 
    artics = an.art.(fname); % get predefined articulation
    for nInstr = 1:length(an.fam.(fname)) % plot fit
        ind_reg = ind_reg + 1;
        for nReg = 1:2
            aa = T_bound{ind_reg, nReg+1};
            an.regis.(fname){nInstr,nReg} = aa{:}; % name of selected instrumentq
            an.size.(fname)(nInstr) = T_bound{ind_reg, 5};
        end
    end
end

%% get F0 grid
dyn_lev = 'mf'; 
F0s = [];
an.medF0 = [];
instr_pitch_range = [];
nIt = 0; 
% get pitches
for nFam = 1:length(fieldnames(an.fam))-1 % family loop 
    fnames = fieldnames(an.fam);  % name of current family
    fname = fnames{nFam}; 
    artics = an.art.(fname); % get predefined articulation
    for nInstr = 1:length(an.fam.(fname)) % plot fit 
        nIt = nIt + 1; 
        iname = an.fam.(fname){nInstr}; % name of selected instrument
        F0_instr = dat.(iname).(artics).(dyn_lev).x.F0; 
        F0s = [F0s, F0_instr];
        an.medF0.(fname)(nInstr) = median(F0_instr); 
        instr_pitch_range.(iname){1} = freq2muspitch(min(F0_instr));
        instr_pitch_range.(iname){2} = freq2muspitch(max(F0_instr));
        an.range.(fname){nInstr,1} = instr_pitch_range.(iname){1};
        an.range.(fname){nInstr,2} = instr_pitch_range.(iname){2};
    end
end
F0_grid = round(unique(F0s));

% plot 2d pics of pitch-varying spectral envelopes [spectrogram-like]

%% plot SC values across pitch
cmap = colormap('lines'); 
cmap_op = [cmap, .75*ones(length(cmap),1)];  % have some opacity going on  

for nDyn = 1:3
    dyn_lev = dynamics{nDyn}; 
    figure
    subplot(3,4,1)
    for nFam = 1:12 %length(fieldnames(an.fam))-1 % family loop 
        subplot(3,4,nFam)
        fnames = fieldnames(an.fam);  % name of current family
        fname = fnames{nFam} 
        artics = an.art.(fname); % get predefined articulation
        X = []; Y = []; 
        for nInstr = 1:length(an.fam.(fname)) % plot fit 
            iname = an.fam.(fname){nInstr}; % name of selected instrument
            x = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.F0))'; 
            y = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.erbSC))'; 
            y_ind = ~isnan(y); 
            [yhat, p] = csaps(x(y_ind), y(y_ind), .98, x(y_ind)); % spline fitting 
            %x_regr = [ones(length(x(y_ind)),1), x(y_ind), x(y_ind).^2, x(y_ind).^3]; % get regress data 
            %[beta, b_int, ~, ~, stats] = regress(y(y_ind), x_regr); % model: 3rd order poly regression
            %yhat = x_regr*beta; 
            loglog(2.^x(y_ind), 2.^yhat, '-',  'linewidth', 4, 'color', cmap_op(nInstr,:)); hold on
            %Y = [Y; y(y_ind)];
            %X = [X; [nInstr*ones(length(yhat),1), nDyn*ones(length(yhat),1), x_regr(:, 2:end)]]; 
        end
        for nInstr = 1:length(an.fam.(fname)) % plot raw data 
            iname = an.fam.(fname){nInstr}; % name of selected instrument
            x = squeeze(dat.(iname).(artics).(dyn_lev).x.F0); 
            y = squeeze(dat.(iname).(artics).(dyn_lev).x.erbSC);
            loglog(x, y, '.', 'color', cmap(nInstr,:), 'linewidth', 8); hold on
            
            % once more spline fitting to get fitted variable
            xx = log2(x); 
            yy = log2(y); 
            y_ind = ~isnan(yy); 
            [yhat, p] = csaps(xx(y_ind), yy(y_ind), .95, xx(y_ind)); % spline fitting 
            
            % plot register boundaries ground truth
            xgt = (an.regis.(fname){nInstr,1}); % lower
            xgt_ind = find(round(x(y_ind)) == round(muspitch2freq(xgt)));
            loglog([x(xgt_ind)], [2.^yhat(xgt_ind)], 's', 'linewidth', 2, 'color', cmap_op(nInstr, :)); hold on
            xgt = (an.regis.(fname){nInstr,2}); % middle 
            xgt_ind = find(round(x(y_ind)) == round(muspitch2freq(xgt)));
            loglog([x(xgt_ind)], [2.^yhat(xgt_ind)], 's', 'linewidth', 2, 'color', cmap_op(nInstr, :))
            %xgt = (an.regis.(fname){nInstr,3}); % high
            %xgt_ind = find(round(x(y_ind)) == round(muspitch2freq(xgt))); 
            %loglog([x(xgt_ind)], [2.^yhat(xgt_ind)], 's', 'linewidth', 2, 'color', cmap_op(nInstr, :))
        end
        loglog([10 10000], [10 10000], 'color', [.8 .8 .8])
        fnames = fieldnames(an.names);  % name of current family
        fname = fnames{nFam}; 
        legend(an.names.(fname), 'Location', 'SouthEast', 'FontSize', 14)
        %legend(an.names.(fname), 'FontSize', 10, 'Position',[0.1 .8 0.05 0.05])
        title(fname)
        xlim([25 5000])
        set(gca, 'XTick', [50 200 1000 4000])
        set(gca, 'XTickLabel', [.05 .2 1 4])
        ylim([200 6000])
        set(gca, 'YTick', [200 1000 4000])
        set(gca, 'YTickLabel', [.2 1 4])
        set(gca, 'Box', 'Off')
        
    end
    subplot(3,4,1); ylabel('SC [kHz]');
    text(5, 16000, strcat('(', dynamics{nDyn} ,')'), 'fontsize', 24, 'fontweight', 'bold', 'fontangle', 'italic')
    subplot(3,4,5); ylabel('SC [kHz]');
    subplot(3,4,9); ylabel('SC [kHz]');
    subplot(3,4,9); xlabel('F0 [kHz]'); 
    subplot(3,4,10); xlabel('F0 [kHz]'); 
    subplot(3,4,11); xlabel('F0 [kHz]'); 
    subplot(3,4,12); xlabel('F0 [kHz]'); 
end

%% regression with register differentiation 
regis_name = {'lower', 'middle', 'upper'}; 
an.regr_regis = []; 

dyn_lev_MIDI = [21, 85, 127]; 

for nFam = 1:12 %length(fieldnames(an.fam))-1 % family loop 
    fnames = fieldnames(an.fam);  % name of current family
    fname = fnames{nFam}; 
    artics = an.art.(fname); % get predefined articulation
    for nReg = 1:length(regis_name)
        X = []; Y = []; 
        for nInstr = 1:length(an.fam.(fname)) % gather info for every instrument class
            instr_size = an.size.(fname)(nInstr);
            iname = an.fam.(fname){nInstr}; % name of selected instrument
            % get register indices 
            reg_mid = (an.regis.(fname){nInstr,1}); 
            reg_upp = (an.regis.(fname){nInstr,2}); 
            switch nReg 
                case 1        
                    reg_ind = find(dat.(iname).(artics).(dyn_lev).x.F0 < muspitch2freq(reg_mid)); 
                case 2
                    reg_ind = find(dat.(iname).(artics).(dyn_lev).x.F0 >= muspitch2freq(reg_mid) & ...
                        dat.(iname).(artics).(dyn_lev).x.F0 < muspitch2freq(reg_upp)); 
                case 3
                    reg_ind = find(dat.(iname).(artics).(dyn_lev).x.F0 >= muspitch2freq(reg_upp)); 
            end
            
            for nDyn = 1:3
                MIDI_dyn = dyn_lev_MIDI(nDyn); 
                
                dyn_lev = dynamics{nDyn}; 
                % get data
                x = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.F0))';
                y = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.erbSC))'; 

                y_ind = intersect(find(~isnan(y)), reg_ind); % discard nans and implement register 
                x_regr = [x(y_ind), x(y_ind).^2, x(y_ind).^3]; % get regress data 
                Y = [Y; y(y_ind)];
                LL = length(y_ind); 
                X = [X; [ones(LL,1), instr_size*ones(LL,1), MIDI_dyn*ones(LL,1), x_regr, ... % main effects 
                   instr_size*x_regr(:,1),  MIDI_dyn*x_regr(:,1),  MIDI_dyn*instr_size*ones(LL,1)]];%, ... % interaction terms ; % instrument-specific effects ];
            end
        end
        
    % do regression
    YY = (Y); 
    XX = [X(:,1), zscore(X(:, [4 2 3]))]; % intercept, F0, normalized size, MIDI dynamics
    [b_norm, b_ci_norm, ~, ~, stats] = regress(YY, XX); % model
    an.regr_regis.(fname).(regis_name{nReg}).b_norm = b_norm;
    an.regr_regis.(fname).(regis_name{nReg}).b_ci_norm = b_ci_norm;
    an.regr_regis.(fname).(regis_name{nReg}).stats = stats;
    an.regr_regis_R2.x(nFam, nReg) = stats(1);  
    end
end

% get model fit: 
[ss, si]  = sort(mean(an.regr_regis_R2.x,2))
{fnames{si}}
ss'

%% plot results with register differentiation
figure; 
cmap = colormap('lines'); 
cmap(1:4,:) = cmap(1:4,:).^4;

effects = {'F0', 'Instrument Size', 'Dynamic Level', 'SizeXLevel', 'F0xDyn', 'Size X Dynamics'};  
effect_sign = [1 -1 1];
ylims = [-1 1.5; -1 1.5; -.2 1.5;  -1. 1.];
shifts = 3*[-.1,0,.1];
reg_symb = {'v', 's', '^'}; 
numb_vars = size(XX,2)-1; 
subplot(1,numb_vars,2)
plot(-1, 0, reg_symb{1}, 'color', [0 0 0], 'linewidth', 3); hold on
plot(-1, 0, reg_symb{2}, 'color', [0 0 0], 'linewidth', 3); hold on
plot(-1, 0, reg_symb{3}, 'color', [0 0 0], 'linewidth', 3); hold on

%famplot = [1 3 5 6 8 9 11 12 14:17];
famplot = [1 2.5 4 5 6.5 7.5 9 10 11.5:14.5];

for k = 1:numb_vars % different type of effects 
    subplot(1,numb_vars,k)
    for nFam = 1:12 % family loop 
        for nReg = 1:3
            fnames = fieldnames(an.fam);  % name of current family
            fname = fnames{nFam}; 
            %plot(famplot(nFam) + shifts(nReg), an.regr_regis.(fname).(regis_name{nReg}).b_norm(k+1), reg_symb{nReg}, 'color', cmap(nFam,:), 'linewidth', 3); hold on
            plot([famplot(nFam) + shifts(nReg), famplot(nFam) + shifts(nReg)], [0, an.regr_regis.(fname).(regis_name{nReg}).b_norm(k+1)], '-', 'color', cmap(nFam,:), 'linewidth', 5); hold on
            plot([famplot(nFam) famplot(nFam)] + shifts(nReg), [an.regr_regis.(fname).(regis_name{nReg}).b_ci_norm(k+1,1), ...
                an.regr_regis.(fname).(regis_name{nReg}).b_ci_norm(k+1,2)], '-', 'linewidth', 2, 'color', [0.4 0.4 0.4]); hold on
        end
        % add results from without register differentiation
        %plot([nFam + shifts(1), nFam + shifts(3)] , ...
        %    [an.regr.(fname).b(k+1), an.regr.(fname).b(k+1)], ...
        %    '-', 'color', cmap(nFam,:), 'linewidth', 1); hold on
    end
    
    title(effects{k})
    %ylim(ylims(k,:))
    ylim([-1.3 1.3])
    yline(0)
    xlim([0 max(famplot)+.5])
    ylabel('\beta')
    set(gca, 'XTick', famplot)
    set(gca, 'XTickLabels', {fnames{1:12}})
    ff = gca; ff.XTickLabelRotation = 90;
    set(gca, 'Box', 'off')
    %set(gca, 'XTick', famplot(nFam), 'XColor', cmap(nFam,:), 'Color', 'none') %// Keep only one red tick

end
%subplot(1,numb_vars,2)
%legend('Lower Reg.', 'Middle Reg.', 'Upper Reg.', 'FontSize', 16)

%% how independent are scale and shape?

X_fft = [];
X_dct = [];
Y_sc = []; 
Y_f0 = []; 
dynrange = 10^(-3); 
for nDyn = 1:3
    dyn_lev = dynamics{nDyn}; 
    for nFam = 1:12 %length(fieldnames(an.fam))-1 % family loop 
        fnames = fieldnames(an.fam);  % name of current family
        fname = fnames{nFam} 
        artics = an.art.(fname); % get predefined articulation
        for nInstr = 1:length(an.fam.(fname)) % plot fit 
            iname = an.fam.(fname){nInstr}; % name of selected instrument
            y_f0 = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.F0))';
            y_sc = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.erbSC))';
            x_cep_fft = abs(fft(log10(squeeze(dat.(iname).(artics).(dyn_lev).x.erb_magn) + dynrange), [], 2));
            x_cep_dct = (dct(log10(squeeze(dat.(iname).(artics).(dyn_lev).x.erb_magn) + dynrange), [], 2));
            y_ind = ~isnan(y_sc); 
            Y_f0 = [Y_f0; y_f0(y_ind)];
            Y_sc = [Y_sc; y_sc(y_ind)];
            X_fft = [X_fft; x_cep_fft(y_ind, 2:14)];
            X_dct = [X_dct; x_cep_dct(y_ind, 2:14)];
        end
    end
end

% Are F0 and scale information part of dct/fft?
for n = 1:13
    [b, bint, res, rint, stats] = regress(Y_f0, [ones(length(X_dct),1), X_dct(:, 1:n)]); 
    covar(n, 1, 1) = stats(1);
    [b, bint, res, rint, stats] = regress(Y_f0, [ones(length(X_dct),1), X_dct(:, n:13)]); 
    covar(n, 1, 2) = stats(1);

    [b, bint, res, rint, stats] = regress(Y_sc, [ones(length(X_dct),1), X_dct(:, 1:n)]); 
    covar(n, 2, 1) = stats(1);
    [b, bint, res, rint, stats] = regress(Y_sc, [ones(length(X_dct),1), X_dct(:, n:13)]); 
    covar(n, 2, 2) = stats(1);

    [b, bint, res, rint, stats] = regress(Y_f0, [ones(length(X_dct),1), X_fft(:, 1:n)]); 
    covar(n, 3,1) = stats(1);
    [b, bint, res, rint, stats] = regress(Y_f0, [ones(length(X_dct),1), X_fft(:, n:13)]); 
    covar(n, 3,2) = stats(1);

    [b, bint, res, rint, stats] = regress(Y_sc, [ones(length(X_dct),1), X_fft(:, 1:n)]); 
    covar(n, 4,1) = stats(1);
    [b, bint, res, rint, stats] = regress(Y_sc, [ones(length(X_dct),1), X_fft(:, n:13)]); 
    covar(n, 4,2) = stats(1);
end

%% plot it
cm = colormap('lines');
subplot(1,2,1); hold on
col_ind = [2 2 1 1];
for k = [2 4]
    plot(squeeze(covar(:,k,1)), '-', 'color', cm(col_ind(k), :).^2)
end
for k = [2 4]
    plot(squeeze(covar(:,k,1)), '-', 'color', cm(col_ind(k), :).^2)
    plot(squeeze(covar(:,k,2)), '--', 'color', cm(col_ind(k), :).^2)
end
%legend('F0-DCT', 'SC-DCT', 'F0-FFTmag', 'SC-FFmag', 'fontsize', 16)
legend('SC-DCT', 'SC-FFTmag', 'fontsize', 16)
ylabel('R^2')
xlabel('Coefficient n')
set(gca, 'XTick', [1:2:13])
xlim([0 14])
title('SC Regression')
set(gca, 'YTick', [0:.2:1])
text(-2,1.1, '(A)', 'fontsize', 22, 'fontweight', 'bold')

% plot degradation of classification accuracy
cd('/Users/kaisiedenburg/ownCloud/Home-Cloud/MusicProjects/Projects/VSL/Code/Simon/classification/data')
load clData_ccheck.mat

% do it
for k = 1:13
    acc_fft(k,1) = clData_ccheck.fft.right.acc{k}; 
    acc_fft(k,2) = clData_ccheck.fft.left.acc{k}; 
    acc_dct(k,1) = clData_ccheck.dct.right.acc{k}; 
    acc_dct(k,2) = clData_ccheck.dct.left.acc{k}; 
end

subplot(1,2,2); hold on
plot(acc_fft(:,1), '-', 'color', cm(1,:).^2, 'linewidth', 2); hold on
plot(acc_dct(:,1), '-', 'color', cm(2,:).^2, 'linewidth', 2); hold on

plot(acc_fft(:,2), '--', 'color', cm(1,:).^2, 'linewidth', 2); hold on
plot(acc_dct(:,2), '--', 'color', cm(2,:).^2, 'linewidth', 2); hold on

%legend('1:n, FFT', 'n:13, FFT', '1:n, DCT', 'n:13, DCT'); 
legend('FFTmag-CC', 'DCT-CC', 'fontsize', 16); 
xlabel('Coefficient n')
ylabel('Accuracy')
set(gca, 'Box', 'off')
set(gca, 'XTick', [1:2:13])
xlim([0 14])
set(gca, 'YTick', [0:.2:1])
title('Instr. classification')
text(-2,1.1, '(B)', 'fontsize', 22, 'fontweight', 'bold')
