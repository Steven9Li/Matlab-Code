clear;
clc;

load('useful_data/eeg_data.mat');
load('useful_data/feature_point.mat');
load('useful_data/channel.mat');
load('useful_data/EEG_CHANNEL.mat');

negative = [5,12,13,14,15];
positive = [6,7,8,10,11];
middle = [1,2,3,4,9,16];
all = 1:16;
res = PLFP_flux;
[x,y] = size(res);

Num = 1501;
E_Num = 62;

ret = all;

for i = 1 : 15
    avgs(i) = struct('flux',zeros(E_Num,Num),'zero',zeros(E_Num,Num),'rms',zeros(E_Num,Num),'brightness',zeros(E_Num,Num));
end

res = PLFP_flux;
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

res = PLFP_brightness;
[x,y] = size(res);
sum_all = zeros(E_Num,Num);
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
    avgs(k).brightness = avg;
    avgs(k).brightness_count = count;
end
%avg_all_brightness = sum_all / count_all;

res = PLFP_zero;
[x,y] = size(res);
sum_all = zeros(E_Num,Num);
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
    avgs(k).zero = avg;
    avgs(k).zero_count = count;
end
%avg_all_zero = sum_all / count_all;

res = PLFP_rms;
[x,y] = size(res);
%sum_all = zeros(E_Num,Num);
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
    avgs(k).rms = avg;
    avgs(k).rms_count = count;
end

