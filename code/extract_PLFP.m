clear;
clc;

music = load('./useful_data/music_feature.mat');
%music = load('music_feature.mat');
PLFP_flux = zeros(music.musicNum, 20);

count = 0;
Nstep = 80;
minnum = 20;
percenth = 0.6;
percentl = 0.6;
plfp = zeros(16,20);
for i = 1 : music.musicNum
    % PS:频谱通量是差值，所以其帧数要比统计特征少一帧
    flux = music.zerocross(i,1:music.length_of_data(i)-1);
    data_mid = flux;

    %中值滤波
    for j = 3:length(flux)-2
        data_mid(j) = median(flux(j-2:j+2));
    end
    
    %均值滤波
    data_mm = data_mid;
    for j = 3:length(flux)-2
        data_mm(j) = median(data_mid(j-2:j+2));
    end
    
    data_diff = zeros(1,length(data_mm));
    tmp = data_diff;
    figure(i)
    % 原始特征图
    subplot(3,1,1)
    plot(data_mm)
    % 中心差分图
    subplot(3,1,2)
    for k = 2:length(data_mm)-1
        data_diff(k) = (data_mm(k+1)-data_mm(k-1))/2;
    end
    plot(data_diff)
    hold on
    avg = mean(data_diff);
    maxd = max(data_diff);
    mind = min(data_diff);
    
    ht = avg + (maxd - avg)*percenth;
    lt = avg + (mind - avg)*percentl;
    plot(tmp+ht)
    hold on
    plot(tmp+lt)
    
    subplot(3,1,3)
    %plot(diff(data_diff))
    % 多级差分图
    o = 20;
    tmp = data_mm;
    for k = 1:o
        tmp(k) = 0;
    end
    for k = o+1:length(data_mm)
        tmp(k) = data_mm(k) - data_mm(k-o);
    end
    
    avg = mean(tmp);
    maxd = max(tmp);
    mind = min(tmp);
    
    ht = avg + (maxd - avg)*percenth;
    lt = avg + (mind - avg)*percentl;
    plot(zeros(1,length(data_mm))+ht)
    hold on
    plot(zeros(1,length(data_mm))+lt)
    hold on
    plot(tmp)
    count = 0;
    index = 1;
    step = 1;
    flag = 0;
    for k = 100:length(data_diff)-100
        if(step >= 80)
            step = 1;
            flag = 0;
        end
        if flag == 1
            step = step + 1;
            continue;
        end
        if data_diff(k)<ht && data_diff(k)>lt
            count = count + 1;
        else
            if count > minnum
                plfp(i,index) = k;
                count = 0;
                index = index + 1;
                flag = 1;
            else
                count = 0;
            end           
        end
    end

end
