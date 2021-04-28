% This script performs a support vector machine (SVM) classification for
% the instrument classes. This includes a mixed classification for all
% sounds (independent of dynamics and register), a within case for dynamics
% and register, respectively, and an across evaluation for dynamics and
% register respectively. Additionaly, a coefficient check is executed to
% test the relevance of the erb-frequency cepstral coefficients with
% increasing and decreasing order.
%
% Caution! This script takes up to an hour to an hour to run!
%
% Authors: Kai Siedenburg & Simon Jacobsen, April 2021
% Dept. Medical Physics & Acoustics, CvO Uni Oldenburg

% set variables
variables = {'dynamics', 'register'};
dynamics = {'pp', 'mf', 'ff'};
registers = {'low', 'mid', 'hig'};
featset = {'fftmag', 'dct'};
classes = fieldnames(an.fam);
classes = classes(1:12);
vFeat = linspace(1,13,13);

% This is needed to ingore missing notes in some lower registers
% (Contrabass clarinet and contrabass trombone)
more = load('analysis_regis_ind_update.mat');

%% mixed classification
KFold = 10;

% pre-allocation
labels.fftmag.mixed = {};
labels.dct.mixed = {};
features.fftmag.mixed = [];
features.dct.mixed = [];

% create feature vector
for nFam = 1:12
    fnames = fieldnames(an.fam);
    fname = fnames{nFam};
    for nInstr = 1:numel(an.fam.(fname))
        iname = an.fam.(fname){nInstr};
        artics = an.art.(fname);
        for nDyn = 1:numel(dynamics)
            dyns = dynamics{nDyn};
            for nTones = 1:numel(dat.(iname).(artics).(dyns).x.F0)
                % check whether sound exists
                if ~isnan(dat.(iname).(artics).(dyns).x.cep_fftmag(nTones, 1))
                    % append feature vector
                    fftmag_feat = dat.(iname).(artics).(dyns).x.cep_fftmag(nTones, vFeat);
                    features.fftmag.mixed = [features.fftmag.mixed; fftmag_feat];
                    dct_feat = dat.(iname).(artics).(dyns).x.cep_dct(nTones, vFeat);
                    features.dct.mixed = [features.dct.mixed; dct_feat];
                    % append label vector
                    class = {fname};
                    instr = {iname};
                    labels.fftmag.mixed = [labels.fftmag.mixed; instr, class];
                    labels.dct.mixed = [labels.dct.mixed; instr, class];
                end
            end
%             features.fftmag.mixed = [features.fftmag.mixed; dat.(iname).(artics).(dyns).x.cep_fftmag(:,2:14)];
%             features.dct.mixed = [features.dct.mixed; dat.(iname).(artics).(dyns).x.cep_dct(:,2:14)];
        end
    end
end

%% SVM classification
for nFeat = 1:numel(featset)
    feat = featset{nFeat};
    % do classification
    [CVmdl.(feat).mixed, predict.(feat).mixed, acc.(feat).mixed] = classify_svm(...
        features.(feat).mixed, labels.(feat).mixed(:,2), classes, KFold);
    % compute confusion matrix
    clData.(feat).mixed.cm = confusionmat(labels.(feat).mixed(:,2), predict.(feat).mixed);
    % save other parameters
    clData.(feat).mixed.acc = acc.(feat).mixed;
    clData.(feat).mixed.CVMdl = CVmdl.(feat).mixed;
    clData.(feat).mixed.predict = predict.(feat).mixed;
    
    % add other computations? F1, SD
end

%% within classification
KFold = 3;

% pre-allocation
[labels.fftmag.within.dynamics.pp,...
labels.fftmag.within.dynamics.mf,...
labels.fftmag.within.dynamics.ff] = deal({});
[labels.dct.within.dynamics.pp,...
labels.dct.within.dynamics.mf,...
labels.dct.within.dynamics.ff] = deal({});
[features.fftmag.within.dynamics.pp,...
features.fftmag.within.dynamics.mf,...
features.fftmag.within.dynamics.ff] = deal([]);
[features.dct.within.dynamics.pp,...
features.dct.within.dynamics.mf,...
features.dct.within.dynamics.ff] = deal([]);

% dynamics feature vector
for nFam = 1:12
    fnames = fieldnames(an.fam);
    fname = fnames{nFam};
    for nInstr = 1:numel(an.fam.(fname))
        iname = an.fam.(fname){nInstr};
        artics = an.art.(fname);
        for nDyn = 1:numel(dynamics)
            dyns = dynamics{nDyn};
            for nTones = 1:numel(dat.(iname).(artics).(dyns).x.F0)
                % check whether sound exists
                if ~isnan(dat.(iname).(artics).(dyns).x.cep_fftmag(nTones, 1))
                    % append feature vector
                    fftmag_feat = dat.(iname).(artics).(dyns).x.cep_fftmag(nTones, vFeat);
                    features.fftmag.within.dynamics.(dyns) = [features.fftmag.within.dynamics.(dyns); fftmag_feat];
                    dct_feat = dat.(iname).(artics).(dyns).x.cep_dct(nTones, vFeat);
                    features.dct.within.dynamics.(dyns) = [features.dct.within.dynamics.(dyns); dct_feat];
                    % append label vector
                    class = {fname};
                    instr = {iname};
                    labels.fftmag.within.dynamics.(dyns) = [labels.fftmag.within.dynamics.(dyns); instr, class];
                    labels.dct.within.dynamics.(dyns) = [labels.dct.within.dynamics.(dyns); instr, class];
                end
            end
        end
    end
end

% pre-allocation
[labels.fftmag.within.register.low,...
labels.fftmag.within.register.mid,...
labels.fftmag.within.register.hig] = deal({});
[labels.dct.within.register.low,...
labels.dct.within.register.mid,...
labels.dct.within.register.hig] = deal({});
[features.fftmag.within.register.low,...
features.fftmag.within.register.mid,...
features.fftmag.within.register.hig] = deal([]);
[features.dct.within.register.low,...
features.dct.within.register.mid,...
features.dct.within.register.hig] = deal([]);

% register feature vector
for nFam = 1:12
    fnames = fieldnames(an.fam);
    fname = fnames{nFam};
    for nInstr = 1:numel(an.fam.(fname))
        iname = an.fam.(fname){nInstr};
        artics = an.art.(fname);
        for nDyn = 1:numel(dynamics)
            dyns = dynamics{nDyn};
            for nReg = 1:numel(registers)
                regs = registers{nReg};
                range = more.an.regis_ind.(iname).(regs);
                for nTones = 1:length(range)
                    if isinteger(range)
                        regidx = range;
                    else
                        regidx = range(nTones);
                    end
                    % check whether sound exists
                    if ~isnan(dat.(iname).(artics).(dyns).x.cep_fftmag(regidx,1))
                        % append feature vector
                        fftmag_feat = dat.(iname).(artics).(dyns).x.cep_fftmag(regidx, vFeat);
                        dct_feat = dat.(iname).(artics).(dyns).x.cep_dct(regidx, vFeat);
                        features.fftmag.within.register.(regs) = [features.fftmag.within.register.(regs); fftmag_feat];
                        features.dct.within.register.(regs) = [features.dct.within.register.(regs); dct_feat];
                        % append label vector
                        class = {fname};
                        instr = {iname};
                        labels.fftmag.within.register.(regs) = [labels.fftmag.within.register.(regs); instr, class];
                        labels.dct.within.register.(regs) = [labels.dct.within.register.(regs); instr, class];
                    end
                end
            end
        end
    end
end

%% SVM classification
for nFeat = 1:numel(featset)
    feat = featset{nFeat};
    % loop over dynamics
    for nDyn = 1:numel(dynamics)
        dyns = dynamics{nDyn};
        % do classification
        [CVmdl.(feat).within.dynamics.(dyns), predict.(feat).within.dynamics.(dyns), acc.(feat).within.dynamics.(dyns)] = classify_svm(...
            features.(feat).within.dynamics.(dyns), labels.(feat).within.dynamics.(dyns)(:,2), classes, KFold);
        % compute confusion matrix
        clData.(feat).within.dynamics.(dyns).cm = confusionmat(labels.(feat).within.dynamics.(dyns)(:,2), predict.(feat).within.dynamics.(dyns));
        % save other parameters
        clData.(feat).within.dynamics.(dyns).acc = acc.(feat).within.dynamics.(dyns);
        clData.(feat).within.dynamics.(dyns).CVMdl = CVmdl.(feat).within.dynamics.(dyns);
        clData.(feat).within.dynamics.(dyns).predict = predict.(feat).within.dynamics.(dyns);
    end
    % loop over register
    for nReg = 1:numel(registers)
        regs = registers{nReg};
        % do classification
        [CVmdl.(feat).within.register.(regs), predict.(feat).within.register.(regs), acc.(feat).within.register.(regs)] = classify_svm(...
            features.(feat).within.register.(regs), labels.(feat).within.register.(regs)(:,2), classes, KFold);
        % compute confusion matrix
        clData.(feat).within.register.(regs).cm = confusionmat(labels.(feat).within.register.(regs)(:,2), predict.(feat).within.register.(regs));
        % save other parameters
        clData.(feat).within.register.(regs).acc = acc.(feat).within.register.(regs);
        clData.(feat).within.register.(regs).CVMdl = CVmdl.(feat).within.register.(regs);
        clData.(feat).within.register.(regs).predict = predict.(feat).within.register.(regs);
    end
    
    % add other computations? F1, SD
end

%% across classification
traindyns = {'mf', 'ff'; 'pp', 'ff'; 'pp', 'mf'};
for nDyn = 1:numel(dynamics)
    dyns = dynamics{nDyn};
    features.fftmag.across.dynamics.train.(dyns) = [features.fftmag.within.dynamics.(traindyns{nDyn, 1}); features.fftmag.within.dynamics.(traindyns{nDyn, 2})];
    features.dct.across.dynamics.train.(dyns) = [features.dct.within.dynamics.(traindyns{nDyn, 1}); features.dct.within.dynamics.(traindyns{nDyn, 2})];
    labels.fftmag.across.dynamics.train.(dyns) = [labels.fftmag.within.dynamics.(traindyns{nDyn, 1}); labels.fftmag.within.dynamics.(traindyns{nDyn, 2})];
    labels.dct.across.dynamics.train.(dyns) = [labels.dct.within.dynamics.(traindyns{nDyn, 1}); labels.dct.within.dynamics.(traindyns{nDyn, 2})];
    
    features.fftmag.across.dynamics.test.(dyns) = features.fftmag.within.dynamics.(dyns);
    features.dct.across.dynamics.test.(dyns) = features.dct.within.dynamics.(dyns);
    labels.fftmag.across.dynamics.test.(dyns) = labels.fftmag.within.dynamics.(dyns);
    labels.dct.across.dynamics.test.(dyns) = labels.dct.within.dynamics.(dyns);
end

trainregs = {'mid', 'hig'; 'low', 'hig'; 'low', 'mid'};
for nReg = 1:numel(registers)
    regs = registers{nReg};
    features.fftmag.across.register.train.(regs) = [features.fftmag.within.register.(trainregs{nReg, 1}); features.fftmag.within.register.(trainregs{nReg, 2})];
    features.dct.across.register.train.(regs) = [features.dct.within.register.(trainregs{nReg, 1}); features.dct.within.register.(trainregs{nReg, 2})];
    labels.fftmag.across.register.train.(regs) = [labels.fftmag.within.register.(trainregs{nReg, 1}); labels.fftmag.within.register.(trainregs{nReg, 2})];
    labels.dct.across.register.train.(regs) = [labels.dct.within.register.(trainregs{nReg, 1}); labels.dct.within.register.(trainregs{nReg, 2})];
    
    features.fftmag.across.register.test.(regs) = features.fftmag.within.register.(regs);
    features.dct.across.register.test.(regs) = features.dct.within.register.(regs);
    labels.fftmag.across.register.test.(regs) = labels.fftmag.within.register.(regs);
    labels.dct.across.register.test.(regs) = labels.dct.within.register.(regs);
end

% SVM classification
for nFeat = 1:numel(featset)
    feat = featset{nFeat};
    % loop over dynamics
    for nDyn = 1:numel(dynamics)
        dyns = dynamics{nDyn};
        % do classification
        [CVmdl.(feat).across.dynamics.(dyns), predict.(feat).across.dynamics.(dyns), acc.(feat).across.dynamics.(dyns)] = classify_svm(...
            features.(feat).across.dynamics.train.(dyns), labels.(feat).across.dynamics.train.(dyns)(:,2), classes, KFold, features.(feat).across.dynamics.test.(dyns), labels.(feat).across.dynamics.test.(dyns)(:,2));
        % compute confusion matrix
        clData.(feat).across.dynamics.(dyns).cm = confusionmat(labels.(feat).across.dynamics.test.(dyns)(:,2), predict.(feat).across.dynamics.(dyns));
        % save other parameters
        clData.(feat).across.dynamics.(dyns).acc = acc.(feat).across.dynamics.(dyns);
        clData.(feat).across.dynamics.(dyns).CVMdl = CVmdl.(feat).across.dynamics.(dyns);
        clData.(feat).across.dynamics.(dyns).predict = predict.(feat).across.dynamics.(dyns);
    end
    % loop over register
    for nReg = 1:numel(registers)
        regs = registers{nReg};
        % do classification
        [CVmdl.(feat).across.register.(regs), predict.(feat).across.register.(regs), acc.(feat).across.register.(regs)] = classify_svm(...
            features.(feat).across.register.train.(regs), labels.(feat).across.register.train.(regs)(:,2), classes, KFold, features.(feat).across.register.test.(regs), labels.(feat).across.register.test.(regs)(:,2));
        % compute confusion matrix
        clData.(feat).across.register.(regs).cm = confusionmat(labels.(feat).across.register.test.(regs)(:,2), predict.(feat).across.register.(regs));
        % save other parameters
        clData.(feat).across.register.(regs).acc = acc.(feat).across.register.(regs);
        clData.(feat).across.register.(regs).CVMdl = CVmdl.(feat).across.register.(regs);
        clData.(feat).across.register.(regs).predict = predict.(feat).across.register.(regs);
    end
    
    % add other computations? F1, SD
end

%% coefficients check
KFold = 10;

acc = [];
predict = []; 
CVmdl = [];

for nFeat = 1:numel(featset)
    feat = featset{nFeat};
    for nn = 1:13
        % [n:13]
        [CVmdl.(feat).ccheck.left, predict.(feat).ccheck.left, acc.(feat).ccheck.left] = classify_svm(...
            features.(feat).mixed(:, nn:13), labels.(feat).mixed(:,2), classes, KFold);
        clData.(feat).ccheck.left.acc(nn, 1) = mean(acc.(feat).ccheck.left);
        % [1:nn]
        [CVmdl.(feat).ccheck.right, predict.(feat).ccheck.right, acc.(feat).ccheck.right] = classify_svm(...
            features.(feat).mixed(:, 1:nn), labels.(feat).mixed(:,2), classes, KFold);
        clData.(feat).ccheck.right.acc(nn, 1) = mean(acc.(feat).ccheck.right);
    end
end
