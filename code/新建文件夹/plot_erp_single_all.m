% 创建时间2017/11/09
% 
% 画出单一被试�?��电极ERP
%
%
%

clear;
clc;

load('useful_data/avgs_all2.mat');
load('useful_data/channel.mat');
load('useful_data/Rand_data2.mat');

data = avgs_all.brightness;
data_r = sum_all;
[x, y] = size(data);


rx = zeros(1501);
rrx = zeros(1501);
xl = -50:100;

figure(1)
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
    title(chanlocs(i).labels);
end