
dynamics = {'pp', 'mf', 'ff'}; 
fs = 44100;

%% load data
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
        F0s = [F0s; F0_instr];
        an.medF0.(fname)(nInstr) = median(F0_instr); 
        instr_pitch_range.(iname){1} = freq2muspitch(min(F0_instr));
        instr_pitch_range.(iname){2} = freq2muspitch(max(F0_instr));
        an.range.(fname){nInstr,1} = instr_pitch_range.(iname){1};
        an.range.(fname){nInstr,2} = instr_pitch_range.(iname){2};
    end
end
F0_grid = round(unique(F0s));

% plot 2d pics of pitch-varying spectral envelopes [spectrogram-like]

%% Plot Figure 3 (SC trajectories)
if pflag
    run fig3_script.m
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
                x = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.F0)); % flip data
                y = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.erbSC)); % flip data

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

%% Plot Figure 4 (regression)
if pflag
    run fig4_script.m
end