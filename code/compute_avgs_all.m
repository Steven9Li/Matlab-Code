% 鍒涘缓鏃堕棿 2017/11/09
% 从单一被试的所有平局计算所有人的平均

clear;
clc;

load('useful_data/avgs_middle.mat');
load('useful_data/feature_point.mat');
load('useful_data/channel.mat');
load('useful_data/EEG_CHANNEL.mat');


E_num = length(chanlocs);
P_num = 1501;

sum_all = zeros(E_num, P_num);
count = zeros(E_num, 1);
for i = 1:15
    index = 1;
    for j = 1:62
        if strcmp(chanlocs(j).labels , channel_st{i}(index).labels) == 1
            sum_all(j,:) = sum_all(j,:) + avgs(i).flux(index,:) * avgs(i).flux_count;
            count(j) = count(j) + avgs(i).flux_count;
            index = index + 1;
        end
    end
end

for i = 1:62
    sum_all(i,:) = sum_all(i,:)/count(i);
end

avgs_all.flux = sum_all;

sum_all = zeros(E_num, P_num);
count = zeros(E_num, 1);
for i = 1:15
    index = 1;
    for j = 1:62
        if strcmp(chanlocs(j).labels , channel_st{i}(index).labels) == 1
            sum_all(j,:) = sum_all(j,:) + avgs(i).brightness(index,:) * avgs(i).brightness_count;
            count(j) = count(j) + avgs(i).brightness_count;
            index = index + 1;
        end
    end
end

for i = 1:62
    sum_all(i,:) = sum_all(i,:)/count(i);
end

avgs_all.brightness = sum_all;

sum_all = zeros(E_num, P_num);
count = zeros(E_num, 1);
for i = 1:15
    index = 1;
    for j = 1:62
        if strcmp(chanlocs(j).labels , channel_st{i}(index).labels) == 1
            sum_all(j,:) = sum_all(j,:) + avgs(i).zero(index,:) * avgs(i).zero_count;
            count(j) = count(j) + avgs(i).zero_count;
            index = index + 1;
        end
    end
end

for i = 1:62
    sum_all(i,:) = sum_all(i,:)/count(i);
end

avgs_all.zero = sum_all;

sum_all = zeros(E_num, P_num);
count = zeros(E_num, 1);
for i = 1:15
    index = 1;
    for j = 1:62
        if strcmp(chanlocs(j).labels , channel_st{i}(index).labels) == 1
            sum_all(j,:) = sum_all(j,:) + avgs(i).rms(index,:) * avgs(i).rms_count;
            count(j) = count(j) + avgs(i).rms_count;
            index = index + 1;
        end
    end
end

for i = 1:62
    sum_all(i,:) = sum_all(i,:)/count(i);
end

avgs_all.rms = sum_all;