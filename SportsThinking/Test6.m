% CSP∑÷¿‡
clear;
clc;

load('featuresAll.mat');

label = [zeros(1,64),ones(1,64)];
testLabel = [zeros(16,1);ones(16,1)];
res = zeros(2,28);
count = 1;
% —µ¡∑
for i = 1:8
    for j = i+1:8
        data = [featuresAll{i,j},label'];
        [trainedClassifier, validationAccuracy] = trainClassifier12(data);
        % disp(validationAccuracy)
        res(1,count) = validationAccuracy;
        y = trainedClassifier.predictFcn(featuresTestAll{i,j});
        acc = (32-sum(abs(testLabel - y)))/32;
        res(2,count) = acc;
        count = count + 1;
    end
end

