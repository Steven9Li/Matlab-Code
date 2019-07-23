BN_Matrix = abs(brain) >= 0.6;
chanlocs = channel_st{1};

[ds.chanPairs(:, 1) ds.chanPairs(:, 2)] = ind2sub(size(BN_Matrix), find(BN_Matrix));
figure; 
colormap('jet');
topoplot_connect(ds, chanlocs);
title('Connected topoplot');