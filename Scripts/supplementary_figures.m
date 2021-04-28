
%% generate CM plots for supplementary materials 

% mixed 
figure
subplot(1,2,1)

cm = clData.fftmag.mixed.cm;
classes = fieldnames(an.fam);
classes = classes(1:12);
cc = confusionchart(cm, categorical(classes), ...
    'FontSize', 16);
cc.ColumnSummary = 'column-normalized';
cc.RowSummary = 'row-normalized';
cc.Title = 'FFTmag-CC';
cc.XLabel = 'True classes';
cc.YLabel = 'Predicted classes';
sortClasses(cc, classes)


subplot(1,2,2)

cm = clData.dct.mixed.cm;
classes = fieldnames(an.fam);
classes = classes(1:12);
cc = confusionchart(cm, categorical(classes), ...
    'FontSize', 16);
cc.ColumnSummary = 'column-normalized';
cc.RowSummary = 'row-normalized';
cc.Title = 'DCT-CC';
cc.XLabel = 'True classes';
cc.YLabel = 'Predicted classes';
sortClasses(cc, classes)

%% fftmag dynamics across/within 
descr = {'fftmag', 'dct'}; 
para = {'dynamics', 'register'}; 
levels = {'pp', 'mf', 'ff'; 'low', 'mid', 'hig'}; 

for nDes = 1:2
    for nPar = 1:2

        figure
        subplot(1,2,1)
        cm = sum(cat(3, ...
            clData.(descr{nDes}).within.(para{nPar}).(levels{nPar, 1}).cm, ...
            clData.(descr{nDes}).within.(para{nPar}).(levels{nPar, 2}).cm, ...
            clData.(descr{nDes}).within.(para{nPar}).(levels{nPar, 3}).cm),3);

        classes = fieldnames(an.fam);
        classes = classes(1:12);
        cc = confusionchart(cm, categorical(classes), ...
            'FontSize', 16);
        cc.ColumnSummary = 'column-normalized';
        cc.RowSummary = 'row-normalized';
        cc.Title = 'Within';
        cc.XLabel = 'True classes';
        cc.YLabel = 'Predicted classes';
        sortClasses(cc, classes)

        subplot(1,2,2)
        cm = sum(cat(3, ...
            clData.(descr{nDes}).across.(para{nPar}).(levels{nPar, 1}).cm, ...
            clData.(descr{nDes}).across.(para{nPar}).(levels{nPar, 2}).cm, ...
            clData.(descr{nDes}).across.(para{nPar}).(levels{nPar, 3}).cm),3);

        classes = fieldnames(an.fam);
        classes = classes(1:12);
        cc = confusionchart(cm, categorical(classes), ...
            'FontSize', 16);
        cc.ColumnSummary = 'column-normalized';
        cc.RowSummary = 'row-normalized';
        cc.Title = 'Across';
        cc.XLabel = 'True classes';
        cc.YLabel = 'Predicted classes';
        sortClasses(cc, classes)
    end
end
