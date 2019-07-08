clear;clc;

% 初始化
load('Sports5.mat');
Fs = 1000;
nbFilterPairs = 10;
validationAcc = zeros(7,7);
testAcc = zeros(7,7);
for times = 1:20
for i = 1:8
    for j = 1:8
        if i == j
            continue;
        end
        index_A = i;
        index_B = j;

        train_num = 64;
        test_num = 16;
        train_sets = zeros(Fs,62,train_num*2);
        test_sets = zeros(Fs,62,test_num*2);

        classA = data{index_A}(:,:,:);
        classB = data{index_B}(:,:,:);

        %打乱顺序随机选取
        rA = randperm(80);
        rB = randperm(80);

        classA = classA(:,:,rA);
        classB = classB(:,:,rB);

        train_sets(:,:,1:train_num) = classA(:,:,1:train_num);
        train_sets(:,:,(1+train_num):train_num*2) = classB(:,:,1:train_num);
        train_labels = [ones(1,train_num),zeros(1,train_num)];

        test_sets(:,:,1:test_num) = classA(:,:,(train_num+1):80);
        test_sets(:,:,(1+test_num):test_num*2) = classB(:,:,(train_num+1):80);
        test_labels = [ones(1,test_num),zeros(1,test_num)];

        EEG_train.x = train_sets;
        EEG_train.y = train_labels;
        EEG_train.s = Fs;

        EEG_test.x = test_sets;
        EEG_test.y = test_labels;
        EEG_test.s = Fs;

        CSPMatrix = learnCSP(EEG_train,[0 1]);
        train_features = extractCSP(EEG_train, CSPMatrix, nbFilterPairs);
        test_features = extractCSP(EEG_test, CSPMatrix, nbFilterPairs);

        train_features(:,21) = train_labels;
        test_features(:,21) = [];

        [trainedClassifier, validationAccuracy] = trainClassifier(train_features);
        yfit = trainedClassifier.predictFcn(test_features);
        testAccuracy = 1 - sum(abs(yfit - test_labels'))/(2*test_num);
        disp(['验证集识别率',num2str(validationAccuracy)]);
        disp(['测试集识别率',num2str(testAccuracy)]);
        validationAcc(i,j) = validationAcc(i,j) + validationAccuracy;
        testAcc(i,j) = testAcc(i,j) + testAccuracy;
    end
end
end


