% 基于皮尔逊相关系数的脑网络构建
% clear;
% clc;
load ../useful_data/eeg_data52.mat
load ../useful_data/psd52_music.mat

numChannels = 52;
windows = 300;
Length = 30000;
segment = Length/windows;
class1 = 0;
class2 = 0;
class3 = 0;
class4 = 0;

class = zeros(15,16);

for ii = 1:15
for jj = 1:16
    jj
    valence = psd(ii,jj).valence;
    arousal = psd(ii,jj).arousal;

    if valence < 5 && arousal <= 5
        str = '|labels 1 0 0 0 |features ';
        class(ii,jj) = 3;
        class3 = class3 + 1;
    elseif valence < 5 && arousal > 5
        str = '|labels 0 1 0 0 |features ';
        class(ii,jj) = 2;
        class2 = class2 + 1;
    elseif valence >= 5 && arousal <= 5
        str = '|labels 0 0 1 0 |features ';
        class(ii,jj) = 4;
        class4 = class4 + 1;
    else
        str = '|labels 0 0 0 1 |features ';
        class(ii,jj) = 1;
        class1 = class1 + 1;
    end

%     data = music_st(ii,jj).music;
%     coeef = zeros(numChannels,numChannels);
%     for k = 1:segment
%         for i = 1:numChannels
%             for j = 1:numChannels
%                 data1 = data(i,(k-1)*windows+1:k*windows);
%                 data2 = data(j,(k-1)*windows+1:k*windows);
%                 if i ~= j
%                     coeef(i,j) = corr(data1', data2');
%                 else
%                     coeef(i,j) = 0;
%                 end
%             end
%         end
%         one_coeef = reshape(coeef',1,[]);
%         fp=fopen('A.txt','a');
%         fprintf(fp,str);
%         for n = 1:52*52
%             fprintf(fp,'%f ',one_coeef(n));
%         end
%         fprintf(fp,'\n');
%         fclose(fp);
%         coeef = abs(coeef);
%         BN_Matrix = coeef >= 0.6;
% 
%         [~, avg_degree(k)] = cmp_degree(numChannels, BN_Matrix);
%         density(k) = cmp_density(numChannels, BN_Matrix);
%         [~, avg_cluster(k)] = cmp_cluster(numChannels, BN_Matrix);
%     end
%     bn(ii,jj).avg_degree = avg_degree;
%     bn(ii,jj).density = density;
%     bn(ii,jj).avg_cluster = avg_cluster;
end
end

%% 画图
% figure(1)
% for i = 1:15
%     plot(bn(1,i).avg_cluster);
%     hold on
% end
