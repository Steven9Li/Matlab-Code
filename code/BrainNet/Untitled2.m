BN_Matrix = abs(a) >= 0.75
chanlocs = channel_st{1,1};

[ds.chanPairs(:, 1) ds.chanPairs(:, 2)] = ind2sub(size(BN_Matrix), find(BN_Matrix));
figure; 
colormap('hot');
topoplot_connect(ds, chanlocs);
title('Connected topoplot');