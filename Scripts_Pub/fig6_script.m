
set(0,'DefaultAxesFontSize',22)
set(0, 'DefaultAxesLineWidth', 2)
set(0, 'DefaultLineLineWidth', 2);
set(0,'DefaultAxesTitleFontWeight','normal');

% variables
dynamics = {'pp', 'mf', 'ff'};
registers = {'low', 'mid', 'hig'};
variables = {'dyn', 'reg'};
classes = {'Vocals', 'Strings', 'Flutes', 'Recorders', 'Clarinets', ...
    'Saxophones', 'Oboes', 'Bassoons', 'Trumpets', 'Trombones', 'Horns', 'Tubas'};
titles = {'Dynamics Level', 'Register'};
c = lines(numel(classes));
x = 2.*[1 3 5 6 8 9 11 12 14:17];
os = 0.4;

for nDyn = 1:numel(dynamics)
    dyns = dynamics{nDyn};
    F1.dyn(:, nDyn) = clData.fftmag.within.dynamics.(dyns).F1;
    F1_gen.dyn(:, nDyn) = clData.fftmag.across.dynamics.(dyns).F1;
end
for nReg = 1:numel(registers)
    regs = registers{nReg};
    F1.reg(:, nReg) = clData.fftmag.within.register.(regs).F1;
    F1_gen.reg(:, nReg) = clData.fftmag.across.register.(regs).F1;
end

t = tiledlayout(1,2, 'TileSpacing', 'compact');
for nPlot = 1:2
    nexttile
    hold on
    vars = variables{nPlot};
    vF1 = F1.(vars);
    mF1 = nanmean(vF1,2);
    vF1_gen = F1_gen.(vars);
    mF1_gen = nanmean(vF1_gen,2);
    for nFam = 1:numel(classes)
        plot([x(nFam)-os x(nFam)-os], [0.01 mF1(nFam)],...
            'Color', c(nFam, :), 'LineWidth', 6)
        plot([x(nFam)-os x(nFam)-os], [min(vF1(nFam, :)) max(vF1(nFam, :))], ...
            'Color', [0 0 0], 'LineWidth', 2)
        
        p1 = plot([x(nFam)+os x(nFam)+os], [0.01 mF1_gen(nFam)],...
            'Color', c(nFam, :), 'LineWidth', 6);
        p1.Color(4) = 0.5;
        p2 = plot([x(nFam)+os x(nFam)+os], [min(vF1_gen(nFam, :)) max(vF1_gen(nFam, :))], ...
            'Color', [0 0 0], 'LineWidth', 2);
        p2.Color(4) = 0.5;
    end
    p_within = plot(nan, nan, 'k');
    p_across = plot(nan, nan, 'Color', [0.5 0.5 0.5]);
    hold off
    title(titles{nPlot})
    xlim([0 2*18])
    ylim([0 1])
    ylabel('F1 score')
    yticks([0 0.2 0.4 0.6 0.8 1])
    xticks(x)
    xticklabels(classes)
    ff = gca; ff.XTickLabelRotation = 90;
    legend([p_within p_across], {'within', 'across'})
end  