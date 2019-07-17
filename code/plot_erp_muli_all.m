% 创建时间2017/11/12
% 
% 画出�?有被试的同一电极
%
%
%

clear;
clc;

load('useful_data/avgs_all2.mat');
load('useful_data/channel.mat');
load('useful_data/Rand_data2.mat');

rx = zeros(1001);
rrx = zeros(1001);
xl = -50:100;

figure(1)
for i = 1:62
    subplot(8,8,i)
    hold on
    rx = avgs_all.zero(i,:);
    rx = double(rx);
    rx = resample(rx,100,1000);
    rx = smooth(rx);
    
    rrx = sum_all(i,:);
    rrx = double(rrx);
    rrx = resample(rrx,100,1000);
    rrx = smooth(rrx);
    
    
    plot(xl,rx,'r','LineWidth',1);
    plot(xl,rrx,'g','LineWidth',1);

    plot([-50 100],[0 0],'k');
    plot([0 0],[-1 1],'k');
    title(chanlocs(i).labels);
end