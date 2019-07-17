%% 提取电极
clear;
clc;

load('D:\MATLAB\useful_data\EEG_CHANNEL.mat');

channal = zeros(64,1);

for i = 1:15
    c = channel_st{1,i};
    for j = 1:length(c)
        channal(c(j).urchan) = channal(c(j).urchan) + 1;
    end
end

%% 分类
clear;
clc;

load('D:\MATLAB\useful_data\EEG_CHANNEL.mat');
load('D:\MATLAB\useful_data\eeg_data.mat');
channal = zeros(64,1);
for i = 1:15
    c = channel_st{1,i};
    for j = 1:length(c)
        channal(c(j).urchan) = channal(c(j).urchan) + 1;
    end
end

%% 处理
for i = 1:15
    c = channel_st{1,i};
    for j = length(c):-1:1
        if channal(c(j).urchan) ~= 15
            channel_st{1,i}(j) = [];
            for k = 1:16
                music_st(i,k).eo1(j,:) = [];
                music_st(i,k).eo2(j,:) = [];
                music_st(i,k).music(j,:) = [];
            end
        end
    end
end

