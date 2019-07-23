% 基于皮尔逊相关系数的脑网络构建
clear;
clc;
load('D:\MyProjects\Matlab-Code\MATLAB\Data\music_data.mat')
load('D:\MyProjects\Matlab-Code\MATLAB\Data\behavior_data.mat')

%% run
clc;
numChannels = 62;
winLength = 100;
winMove = 50;
segment = 30000; 

class = zeros(31,16);
avg_degree = zeros(1,10);
density = zeros(1,10);
avg_cluster = zeros(1,10);

for ii = 1:31
    disp(ii)
for jj = 1:16
    valence = behavior_data.V(ii,jj);
    arousal = behavior_data.A(ii,jj);
    if valence < 5 && arousal <= 5
        str = '|labels 1 0 0 0 |features ';
        class(ii,jj) = 3;
    elseif valence < 5 && arousal > 5
        str = '|labels 0 1 0 0 |features ';
        class(ii,jj) = 2;
    elseif valence >= 5 && arousal <= 5
        str = '|labels 0 0 1 0 |features ';
        class(ii,jj) = 4;
    else
        str = '|labels 0 0 0 1 |features ';
        class(ii,jj) = 1;
    end
    
    m_data = music_data{ii,jj};
    [~,dataLength] = size(m_data);
    coeef = zeros(numChannels,numChannels);
    for k = 1:segment
        start = 1 + (k-1)*winMove;
        if start+winLength > dataLength
%             disp(k)
            break;
        end
        data = m_data(:,start:start+winLength);
        coeef = corr(data');
        BN_Matrix = coeef >= 0.6;
        BN_Matrix = double(BN_Matrix);
        [~, avg_degree(k)] = cmp_degree(numChannels, BN_Matrix);
        density(k) = cmp_density(numChannels, BN_Matrix);
        [~, avg_cluster(k)] = cmp_cluster(numChannels, BN_Matrix);
    end
    bn(ii,jj).avg_degree = avg_degree;
    bn(ii,jj).density = density;
    bn(ii,jj).avg_cluster = avg_cluster;
end
end

%% 画图
figure(1)
for i = 1:15
    plot(bn(1,i).avg_cluster);
    hold on
end
