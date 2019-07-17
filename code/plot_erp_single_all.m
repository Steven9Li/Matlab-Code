% 创建于2017/11/09
% 李洪伟
% 画出所有被试的平均ERP

clear;
clc;

negative = load('useful_data/avgs_alln.mat');
load('useful_data/channel.mat');
positive = load('useful_data/avgs_allp.mat');
middle = load('useful_data/avgs_allm.mat');

data = negative.avgs_all.flux;
data_r = positive.avgs_all.flux;
data_2r = middle.avgs_all.flux;
[x, y] = size(data);

xl = -50:100;
count = 1;
ret = [12,11,19,27];
figure(1)
for i = 1:x
%subplot(8,8,i)
if any(ret == i) == 1
    subplot(2,2,count);
    count = count + 1;
    hold on
    rx = data(i,:);
    rx = resample(rx,100,1000);
    rx = smooth(rx);
    
    rrx = data_r(i,:);
    rrx = double(rrx);
    rrx = resample(rrx,100,1000);
    rrx = smooth(rrx);
    
    rrrx = data_2r(i,:);
    rrrrx = double(rrrx);
    rrrx = resample(rrrx,100,1000);
    rrrx = smooth(rrrx);
    
    
    plot(xl,rx,'r','LineWidth',1);
    plot(xl,rrx,'g','LineWidth',1);
    plot(xl,rrrx,'b','LineWidth',1);

    plot([-50 100],[0 0],'k');
    plot([0 0],[-1 1],'k');
    title(chanlocs(i).labels);
end
end

%% 2
rx = data(10,:);
rx = resample(rx,100,1000);
rx = smooth(rx);

rrx = data(11,:);
rrx = double(rrx);
rrx = resample(rrx,100,1000);
rrx = smooth(rrx);

figure(2)
subplot(2,2,1)
hold on
plot(xl,rx,'r','LineWidth',1);
plot(xl,rrx,'g','LineWidth',1);
plot([-50 100],[0 0],'k');
plot([0 0],[-1 1],'k');

subplot(2,2,2)
hold on
plot(xl,rrx,'r','LineWidth',1);
plot([-50 100],[0 0],'k');
plot([0 0],[-1 1],'k');

rx2 = data(10,:);
rx2 = resample(rx2,100,1000);
rx2 = smooth(rx2);

rrx2 = data(11,:);
rrx2 = double(rrx2);
rrx2 = resample(rrx2,100,1000);
rrx2 = smooth(rrx2);

subplot(2,2,3)
hold on
plot(xl,rx,'r','LineWidth',1);
plot(xl,rrx,'g','LineWidth',1);
plot([-50 100],[0 0],'k');
plot([0 0],[-1 1],'k');

subplot(2,2,4)
hold on
plot(xl,rrx,'r','LineWidth',1);
plot([-50 100],[0 0],'k');
plot([0 0],[-1 1],'k');

