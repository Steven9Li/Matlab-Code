% 脑网络特征与音乐特征的相关性分析

%% load data
clear;
clc;
load('D:\MyProjects\Matlab-Code\MATLAB\Data\bn31.mat');
load('D:\MyProjects\Matlab-Code\MATLAB\Data\brainNetFeature.mat');
load('D:\MyProjects\Matlab-Code\MATLAB\Data\musicEFA.mat');

%% run_1
clc

for musicIndex = 1:16
corrMatrix = zeros(31,115);
bFeature = avg(4).degree;
for subIndex = 1:31
    tic
    bFeature = bn(subIndex,musicIndex).avg_degree;
    for j = 3:117
        
        mFeatureTmp = musicFeature(musicIndex).mf(:,j);
        mFeature = mFeatureTmp';

        bLength = length(bFeature);
        mLength = length(mFeature);

        mFeature = resample(mFeature, bLength, mLength);

        c = corrcoef(bFeature,mFeature);
        corrMatrix(subIndex,j-2) = c(1,2);
        
    end
    toc
end
s = sum((corrMatrix))/31;
figure(musicIndex)
bar(s)
end
%% run_2
clc
BN_Matrix = abs(corrMatrix) >= 0.3;
count = sum(sum(BN_Matrix));
disp(count)

BN_Matrix = abs(corrMatrix) >= 0.4;
count = sum(sum(BN_Matrix));
disp(count)

BN_Matrix = abs(corrMatrix) >= 0.5;
count = sum(sum(BN_Matrix));
disp(count)

BN_Matrix = abs(corrMatrix) >= 0.6;
count = sum(sum(BN_Matrix));
disp(count)

%% run_3

for i = 1:31
    figure(i)
    bar(corrMatrix(i,:))
end


