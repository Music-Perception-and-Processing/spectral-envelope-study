% This script will generate Figure 5 from the paper.
%
% Authors: Kai Siedenburg & Simon Jacobsen, April 2021
% Dept. Medical Physics & Acoustics, CvO Uni Oldenburg


%% How independent are shape and scale
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
            y_f0 = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.F0));
            y_sc = log2(squeeze(dat.(iname).(artics).(dyn_lev).x.erbSC));
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

%% Plotting
figure;
cm = colormap('lines');
subplot(1,2,1); hold on
col_ind = [2 2 1 1];
for k = [2 4]
    plot(squeeze(covar(:,k,1)), '-', 'color', cm(col_ind(k), :).^2, 'LineWidth', 2)
end
for k = [2 4]
    plot(squeeze(covar(:,k,1)), '-', 'color', cm(col_ind(k), :).^2, 'LineWidth', 2)
    plot(squeeze(covar(:,k,2)), '--', 'color', cm(col_ind(k), :).^2, 'LineWidth', 2)
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
for k = 1:13
    acc_fft(k,1) = clData.fftmag.ccheck.right.acc(k); 
    acc_fft(k,2) = clData.fftmag.ccheck.left.acc(k); 
    acc_dct(k,1) = clData.dct.ccheck.right.acc(k); 
    acc_dct(k,2) = clData.dct.ccheck.left.acc(k); 
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