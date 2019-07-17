clear;
clc;

load data.mat

net=newff(input,output,[12,6],{'logsig','logsig','purelin'}); %创建一个新的前向神经网络 
net.divideFcn = ''; %禁止程序划分样本
net.trainFcn='trainlm'; %设置训练方法及参数 
net.trainParam.epochs=5000; 
net.trainParam.goal=0;
net=init(net);%初始化网络 

[net,tr]=train(net,input,output); %调用相应算法训练BP网络 

A=sim(net,input); %对BP网络进行仿真 
E=output-A; %计算仿真误差 
MSE=mse(E);%均方误差 

