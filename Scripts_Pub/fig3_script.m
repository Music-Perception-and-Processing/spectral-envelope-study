% This script will generate Figure 3 from the paper.
%
% Authors: Kai Siedenburg & Simon Jacobsen, April 2021
% Dept. Medical Physics & Acoustics, CvO Uni Oldenburg

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