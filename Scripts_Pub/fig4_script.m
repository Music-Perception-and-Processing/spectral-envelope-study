% This script will generate Figure 4 from the paper.
%
% Authors: Kai Siedenburg & Simon Jacobsen, April 2021
% Dept. Medical Physics & Acoustics, CvO Uni Oldenburg

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