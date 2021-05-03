% This is the main script for the computation of data and generation of
% figures for the JASA paper
% Siedenburg, K., Jacobsen, S., Reuter, C.
% "Spectral envelope position and shape in sustained musical instrument
% sounds." Journal of the Acoustical Society of America (2021)
%
% The audio files taken from the Vienna Symphonic Library (VSL) could not
% be made public. Hence, dummy scripts and functions for the feature
% extraction are included, but will not be executable.
%
% Authors: Kai Siedenburg & Simon Jacobsen, April 2021
% Dept. Medical Physics & Acoustics, CvO Uni Oldenburg

%% Define directories and parameters

hdir = [pwd, filesep];             % set home directory (current folder)
addpath([hdir, 'Scripts']);    % add path to Scripts folder
addpath([hdir, 'Data']);           % add path to Data folder
addpath([hdir, 'Functions']);      % add path to Functions folder

pflag = 1;  % set to 1 to plot figures
sflag = 1;  % set to 1 to save new data

% get latest data version suffix
d = dir([hdir, 'Data', filesep, '*instr_data_new*.mat']);
[~,idx] = max([d.datenum]);
[~, name, ~] = fileparts(d(idx).name);
[~, suffix] = strtok(name, 'v');
suffix = strip(suffix, 'left', 'v');
suffix_int = str2double(suffix);

load(['instr_data_new_v', suffix, '.mat']);  % load feature data
load('analysis.mat');                        % set the analysis scope (an)

%% SC & Regression
%
% This section includes the computation and visualization of the spectral
% centroid (SC) trajectories and the computation and visualization for the
% regression model.
%
% Scripts:      - analysis.m
%
% Plot scripts: - fig3_script.m
%               - fig4_script.m
%
% Functions:    - ??
%
% Output:       - ??

run analysis_new.m

%% Classification
%   
% This section includes the instrument class classification for mixed,
% within, and across conditions and the computation of statistics.
%
% Caution! This section takes up to an hour to run!
%
% Scripts:   - svm_classification.m
%            - stats_computation.m
%
% Functions: - classify_svm.m
%            - computeSVMperform.m
%
% Output:    - cross validation model and performance measures (clData)
%
% This section performs SVM classification for the instrument classes. The
% classification is performed within register/dynamics, across
% register/dynamics, and for the whole data set.

% Perform classification
run svm_classification.m

% Compute statistics
run stats_computation.m

% Performance
performance = num2str([round(clData.fftmag.mixed.acc_mean, 2), round(clData.fftmag.mixed.acc_std, 2), ...
    round(clData.fftmag.within.dynamics.acc_mean_all, 2), round(clData.fftmag.within.dynamics.acc_std_all, 2), ...
    round(clData.fftmag.across.dynamics.acc_mean, 2), round(clData.fftmag.across.dynamics.acc_std, 2), ...
    round(clData.fftmag.within.register.acc_mean_all, 2), round(clData.fftmag.within.register.acc_std_all, 2), ...
    round(clData.fftmag.across.register.acc_mean, 2), round(clData.fftmag.across.register.acc_std, 2); ...
    round(clData.dct.mixed.acc_mean, 2), round(clData.dct.mixed.acc_std, 2), ...
    round(clData.dct.within.dynamics.acc_mean_all, 2), round(clData.dct.within.dynamics.acc_std_all, 2), ...
    round(clData.dct.across.dynamics.acc_mean, 2), round(clData.dct.across.dynamics.acc_std, 2), ...
    round(clData.dct.within.register.acc_mean_all, 2), round(clData.dct.within.register.acc_std_all, 2), ...
    round(clData.dct.across.register.acc_mean, 2), round(clData.dct.across.register.acc_std, 2)], ...
    '%.2f   ');
disp(performance);

% save data
if sflag
    new_suffix_int = suffix_int + 1;
    if new_suffix_int < 10
        new_suffix = ['0' int2str(new_suffix_int)];
    else
        new_suffix = ['_v', int2str(new_suffix_int)];
    end
    save([hdir, 'Data', filesep,'clData', new_suffix], 'clData');
end

%% Compare regression/classification coefficient detail (Figure 5)

if pflag
    run fig5_script.m
end

%% Plot Figure 6 (F1 scores)

if pflag
    run fig6_script.m
end