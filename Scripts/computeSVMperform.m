function [P, R, F1] = computeSVMperform(cm)

% preallocate
F1 = zeros(12, 1);
P = zeros(12, 1);
R = zeros(12, 1);

for nFam = 1:12
    % compute precision
    P(nFam) = cm(nFam, nFam)/sum(cm(nFam, :));
    %compute recall
    R(nFam) = cm(nFam, nFam)/sum(cm(:, nFam));
    % compute F-score
    F1(nFam) = 2.*(P(nFam).*R(nFam))./(P(nFam) + R(nFam));
end

