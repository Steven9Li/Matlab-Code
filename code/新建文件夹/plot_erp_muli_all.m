% 创建时间2017/11/12
% 
% 画出所有被试的同一电极
%
%
%

clear;
clc;

load('useful_data/fp_data.mat');
load('useful_data/channel.mat');
load('useful_data/Rand_data.mat');

e = 28;
rx = zeros(1001);
rrx = zeros(1001);
xl = -50:100;

figure(1)
for i = 1:15
subplot(4,4,i)
    hold on
    rx = avgs(i).flux(e,:);
    rx = double(rx);
    rx = resample(rx,100,1000);
    rx = smooth(rx);
    
%     rrx = data_r(i,:);
%     rrx = double(rrx);
%     rrx = resample(rrx,100,1000);
%     rrx = smooth(rrx);
    
    
    plot(xl,rx,'r','LineWidth',1);
    %plot(xl,rrx,'c','LineWidth',1);

    plot([-50 100],[0 0],'k');
    plot([0 0],[-1 1],'k');
    %title('Frontal');
end