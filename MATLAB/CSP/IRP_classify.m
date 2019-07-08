% IRP ������
% ���룺 13ά��������
% �����㷨�� CSP������ȡ+SVM

clear;clc;

load('..\data\imagedata.mat');      % �����Ӿ�EEG����

Fs = 250;

IRP_num = 54;
ERP_num = 166;

train_num = 42;
test_num = 12;

channal_num = 13;
dataLength = 200;

nbFilterPairs = 10;

% ����Ԥ������ʽ������
% EEGSignals.x: the EEG signals as a [Ns * Nc * Nt] Matrix where
%    Ns: number of EEG samples per trial
%    Nc: number of channels (EEG electrodes)
%    nT: number of trials
% EEGSignals.y: a [1 * Nt] vector containing the class labels for each trial
% EEGSignals.s: the sampling frequency (in Hz)


for i = 1:7
    % �������ݼ�
    ERP_data = zeros(dataLength, channal_num, ERP_num);
    IRP_data = zeros(dataLength, channal_num, IRP_num);
            
    for j = 1:channal_num
        tmp_data = datatest{j,1}((i-1)*ERP_num+1:i*ERP_num,2:201);
        ERP_data(:,j,:) = tmp_data';
        tmp_data = datatest{j,2}((i-1)*IRP_num+1:i*IRP_num,2:201);
        IRP_data(:,j,:) = tmp_data';
    end
    
    % �����ݼ�����
    rA = randperm(ERP_num);
    rB = randperm(IRP_num);
    
    ERP_data = ERP_data(:,:,rA);
    IRP_data = IRP_data(:,:,rB);
    
    train_labels = [zeros(1,train_num), ones(1,train_num)];
    train_data = zeros(dataLength, channal_num, train_num*2);
    train_data(:,:,1:train_num) = ERP_data(:,:,1:train_num);
    train_data(:,:,train_num+1:2*train_num) = IRP_data(:,:,1:train_num);
        
    EEG_train.x = train_data;
    EEG_train.y = train_labels;
    EEG_train.s = Fs;
    
    CSPMatrix = learnCSP(EEG_train,[0 1]);
    train_features = extractCSP(EEG_train, CSPMatrix, nbFilterPairs);
    train_features(:,21) = train_labels;
    [trainedClassifier, validationAccuracy] = trainClassifier(train_features);
    
    disp(['���� ',num2str(i),' ����֤����ʶ����Ϊ�� ', num2str(validationAccuracy)])
    
    % �������Լ�
    test_labels = [zeros(1,ERP_num - train_num), ones(1,IRP_num - train_num)];
    test_data = zeros(dataLength, channal_num, ERP_num + IRP_num - train_num*2);
    test_data(:,:,1:ERP_num-train_num) = ERP_data(:,:,train_num+1:ERP_num);
    test_data(:,:,ERP_num-train_num+1: ERP_num + IRP_num - train_num*2) = IRP_data(:,:,train_num+1:IRP_num);
    
    EEG_test.x = test_data;
    EEG_test.s = Fs;
    test_features = extractCSP(EEG_test, CSPMatrix, nbFilterPairs);
    test_features(:,nbFilterPairs+1) = [];
    test_res = trainedClassifier.predictFcn(test_features);
    
    acc = sum(abs(test_res - test_labels'))/(ERP_num + IRP_num - train_num*2);
    disp(['���� ',num2str(i),' �Ĳ��Լ���ʶ����Ϊ�� ', num2str(acc)])
    
end




