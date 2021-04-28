% This script computes the accuracy (& standard deviation), precision,
% recall, and F1 scores for each classification condition.
%
% Authors: Kai Siedenburg & Simon Jacobsen, April 2021
% Dept. Medical Physics & Acoustics, CvO Uni Oldenburg


% variables
features = {'fftmag', 'dct'};
grouping = {'mixed', 'within', 'across'};
variables = {'dynamics', 'register'};
subvariables = {'pp', 'mf', 'ff'; 'low', 'mid', 'hig'};


% get accuracy/SD and P/R/F1
for nFeat = 1:numel(features)
    feat = features{nFeat};
    for nGroup = 1:numel(grouping)
        groups = grouping{nGroup};
        switch groups
            case 'mixed'
                % accuracy/SD
                clData.(feat).(groups).acc_mean = mean(clData.(feat).(groups).acc);
                clData.(feat).(groups).acc_std = std(clData.(feat).(groups).acc);
                % P/R/F1
                cm = clData.(feat).(groups).cm;
                [clData.(feat).(groups).P,...
                 clData.(feat).(groups).R,...
                 clData.(feat).(groups).F1] = computeSVMperform(cm);
            case 'within'
                for nVar = 1:numel(variables)
                    vars = variables{nVar};
                    vAcc = [];
                    for nSubVar = 1:numel(subvariables(nVar, :))
                        subvars = subvariables{nVar, nSubVar};
                        % acurracy/SD
                        clData.(feat).(groups).(vars).(subvars).acc_mean = mean(clData.(feat).(groups).(vars).(subvars).acc);
                        clData.(feat).(groups).(vars).(subvars).acc_std = std(clData.(feat).(groups).(vars).(subvars).acc);
                        vAcc = [vAcc; clData.(feat).(groups).(vars).(subvars).acc_mean];
                        % P/R/F1
                        cm = clData.(feat).(groups).(vars).(subvars).cm;
                        [clData.(feat).(groups).(vars).(subvars).P,...
                         clData.(feat).(groups).(vars).(subvars).R,...
                         clData.(feat).(groups).(vars).(subvars).F1] = computeSVMperform(cm);
                    end
                    clData.(feat).(groups).(vars).acc_mean_all = mean(vAcc);
                    clData.(feat).(groups).(vars).acc_std_all = std(vAcc);
                end
            case 'across'
                for nVar = 1:numel(variables)
                    vars = variables{nVar};
                    vAcc = [];
                    for nSubVar = 1:numel(subvariables(nVar, :))
                        subvars = subvariables{nVar, nSubVar};
                        % accuracy/SD
                        acc = clData.(feat).(groups).(vars).(subvars).acc;
                        vAcc = [vAcc; acc];
                        % P/R/F1
                        cm = clData.(feat).(groups).(vars).(subvars).cm;
                        [clData.(feat).(groups).(vars).(subvars).P,...
                         clData.(feat).(groups).(vars).(subvars).R,...
                         clData.(feat).(groups).(vars).(subvars).F1] = computeSVMperform(cm);
                    end
                    clData.(feat).(groups).(vars).acc_mean = mean(vAcc);
                    clData.(feat).(groups).(vars).acc_std = std(vAcc);
                end
        end
    end
end
