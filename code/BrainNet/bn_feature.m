% 功能脑网络特征提取（无向图）
% 通过矩阵存储网络，无向图的网络应为对角线对称
% 创建于2018/3/26
% Steven LiHw

clear;
clc;

%% 测试用例1
% load chanlocs.mat
% numChannels = 64;
% data = rand(numChannels, numChannels);
% BN_Matrix = (data - triu(data)) >= 0.9;

numChannels = 6;
load example.mat

%% 脑网络画图
% [ds.chanPairs(:, 1) ds.chanPairs(:, 2)] = ind2sub(size(BN_Matrix), find(BN_Matrix));
% figure; 
% colormap('jet');
% topoplot_connect(ds, chanlocs);
% title('Connected topoplot');

%% 度
degree = zeros(1, numChannels);

for i = 1:numChannels
    count = 0;
    for j = 1:numChannels
        if i == j
            continue;
        end
        if BN_Matrix(i,j)>0
            count = count + 1;
        end
    end
    degree(i) = count;
end
avg_degree = mean(degree);

%% 网络密度
[chanPairs(:, 1) chanPairs(:, 2)] = ind2sub(size(BN_Matrix), find(BN_Matrix));
length = size(chanPairs);

density = length(1) / (numChannels*(numChannels-1)/2);

%% 聚类系数

cluster = zeros(1, numChannels);

for i = 1:numChannels
    count = 0;
    vector = zeros(1, numChannels);
    for j = 1:numChannels
        if i == j
            continue;
        end
        if BN_Matrix(i,j)>0
            count = count + 1;
            vector(count) = j;
        end
    end
    Ei = 0;
    for ii = 1:count
        for jj = 1:count
            if ii == jj
                continue;
            end;
            if BN_Matrix(vector(ii),vector(jj))>0 || BN_Matrix(vector(jj),vector(ii))>0
                Ei = Ei + 1;
            end
        end
    end
    if count == 0 || count == 1
        cluster(i) = 0;
    else
        cluster(i) = Ei/(count*(count-1));
    end
end
avg_cluster = mean(cluster);

%% 平均路径长度与直径




