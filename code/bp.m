clear;
clc;

load data.mat

net=newff(input,output,[12,6],{'logsig','logsig','purelin'}); %����һ���µ�ǰ�������� 
net.divideFcn = ''; %��ֹ���򻮷�����
net.trainFcn='trainlm'; %����ѵ������������ 
net.trainParam.epochs=5000; 
net.trainParam.goal=0;
net=init(net);%��ʼ������ 

[net,tr]=train(net,input,output); %������Ӧ�㷨ѵ��BP���� 

A=sim(net,input); %��BP������з��� 
E=output-A; %���������� 
MSE=mse(E);%������� 

