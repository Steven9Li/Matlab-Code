% clear;
% clc;
% 
% load('useful_data/eeg_data.mat');
% load('useful_data/plfp1.mat');
% load('useful_data/channel.mat');
% load('useful_data/EEG_CHANNEL.mat');

negative = [5,12,13,14,15];
positive = [6,7,8,10,11];
middle = [1,2,3,4,9,16];
all = 1:16;
[x,y] = size(res);

Num = 1501;
E_Num = 62;

ret = all;

for i = 1 : 15
    avgs(i) = struct('flux',zeros(E_Num,Num),'zero',zeros(E_Num,Num),'rms',zeros(E_Num,Num),'brightness',zeros(E_Num,Num));
end

res = plfp;
[x,y] = size(res);
%sum_all = zeros(1,Num);
count_all = 0;   
for k = 1:15
    [xx,yy] = size(music_st(k,1).music);
    sum = zeros(xx,Num);
    count = 0;
    for i=1:x
        if any(ret==i) == 0
            continue;
        end
        for j=1:y
            if res(i,j) == 0
                break;
            end
            t = int32(res(i,j)*12.5);
            if t>29000
                continue;
            end
            p = GetPLFP(music_st(k,i),t);
            count = count + 1;
            sum = sum + p;
            %sum_all = sum_all + p;
            count_all = count_all + 1;
        end
    end
    avg = sum/count;
    avgs(k).flux = avg;
    avgs(k).flux_count = count;
end
%avg_all_flux = sum_all / count_all;

%% 2
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