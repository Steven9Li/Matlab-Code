clear;
clc;

% 测试小波变换

%% 数据准备

load('test_data.mat');

[c,l] = wavedec(test_data,5,'db5');

a5 = wrcoef('a', c , l, 'db5',5);
