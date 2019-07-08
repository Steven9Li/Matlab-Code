% KNN提取音乐特征上的事件点

clear;
clc;

fd = load('data\musicEFA.mat');

feature_num = 115;
feature = fd.musicFeature(1).mf(:,3:117);
X = feature(:,1);
[imf,residual] = emd(X);

figure(1)
subplot(4,1,1)
plot(X)
axis([0,3100,-inf,inf]);

subplot(4,1,2)
plot(imf(:,1));
axis([0,3100,-inf,inf]);

subplot(4,1,3)
plot(imf(:,2));
axis([0,3100,-inf,inf]);

subplot(4,1,4)
plot(imf(:,3));
axis([0,3100,-inf,inf]);
