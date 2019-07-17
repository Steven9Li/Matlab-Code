% 创建于2017/11/18
% 
% 画出单个被试的ERP

clear;
clc;


load('useful_data/channel.mat');
load('useful_data/Rand_data2.mat');
load('useful_data/fp1_data.mat');

for np = 1:15
    data = avgs(np).rms;
    data = double(data);
    [x, y] = size(data);
   
    data_r = sum_all;

    rx = zeros(1501);
    rrx = zeros(1501);
    xl = -50:100;

    figure(np)
    for i = 1:x
    subplot(8,8,i)
        hold on
        rx = data(i,:);
        rx = resample(rx,100,1000);
        rx = smooth(rx);

        rrx = data_r(i,:);
        rrx = double(rrx);
        rrx = resample(rrx,100,1000);
        rrx = smooth(rrx);


        plot(xl,rx,'r','LineWidth',1);
        plot(xl,rrx,'g','LineWidth',1);

        plot([-50 100],[0 0],'k');
        plot([0 0],[-1 1],'k');
        %title(channel(i));
    end
end