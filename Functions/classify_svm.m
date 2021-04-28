function [model, Predictors, accuracy] = classify_svm(train_feat, ...
    train_labl, cnames, KFold, test_feat, test_labl)

% Input:  - feature vector for training (train_feat)
%         - training labels (train_labl)
%         - class names (cnames)
%         - # of folds for cross validation (KFold)
%         - feature vector for testing (test_feat)
%         - testing labels (test_labl)
%
% Output: - Cross validation model (model)
%         - performance measures (Predictors)
%         - classification accuracy (accuracy)


% set-up SVM template
t = templateSVM('Standardize', 1, ...
    'KernelFunction', 'gaussian', ...
    'BoxConstraint', 1);

% train ECOC classifier
Mdl = fitcecoc(train_feat, train_labl, 'Learners', t, ...
    'Coding', 'onevsall', ...
    'ClassNames', cnames, ...
    'Verbose', 2);

% within classification
if nargin == 4
    % 3-fold cross-validation
    CVMdl = crossval(Mdl, 'KFold', KFold);
    % performance
    [Predictors, ~] = kfoldPredict(CVMdl);
    % estimate generalized classification error
    accuracy = 1 - kfoldLoss(CVMdl, 'LossFun', 'ClassifError', 'Mode', 'individual')
    model = CVMdl;

% across classification (generalization)
elseif nargin == 6
%     test_feat = zscore(test_feat);
    % performance
    [Predictors, ~] = predict(Mdl, test_feat);
    % estimate generalized classification error
    accuracy = 1 - loss(Mdl, test_feat, categorical(test_labl), ...
        'LossFun', 'ClassifError')
    model = Mdl;
end
end
