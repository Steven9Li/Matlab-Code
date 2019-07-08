load('classifier56.mat');

EEG_test.x = rand(62,1000);
nbFilterPairs=10;
test_features = extractCSP(EEG_test, CSPMatrix{1,3}, nbFilterPairs);
test_features(:,21) = [];
y = trainedClassifier{1,3}.predictFcn(test_features);