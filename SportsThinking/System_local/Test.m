clear;
clc;

disp('开始初始化')
classifier = load('classifier56.mat');
handles.CSP = classifier.CSPMatrix;
handles.Classifier = classifier.trainedClassifier;
CSPMatrix = handles.CSP;

trainedClassifier = handles.Classifier;
nbFilterPairs = 10;
test_res = zeros(20,6);

for ii = 1:20
    rawData = rand(64,1000);
    rawData(63,:) = [];
    rawData(63,:) = [];
    for i = 1:6
        for j = (i+1):6
            EEG_test.x = rawData;
            test_features = extractCSP(EEG_test, CSPMatrix{i,j}, nbFilterPairs);
            test_features(:,21) = [];
            y = trainedClassifier{i,j}.predictFcn(test_features);
            if y == 1
                test_res(ii,i) = test_res(ii,i) + 1;
            else
                test_res(ii,j) = test_res(ii,j) + 1;
            end
        end
    end    
end
[~, res] = max(test_res');
set(handles.edit2,'string',num2str(res'));