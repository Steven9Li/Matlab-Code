function [CSPMatrix, trainedClassifier] = Train(data,Fs,trials_num,train_num)
%TRAIN 此处显示有关此函数的摘要
%   此处显示详细说明

    nbFilterPairs = 10;
    rand_data = cell(1,7);
    CSPMatrix = cell(7,7);
    trainedClassifier = cell(7,7);

    for i = 1:7
        rA = randperm(trials_num);
        rand_data{i} = data{i}(:,:,rA);
    end

    for i = 1:7
        for j = (i+1):7

            index_A = i;
            index_B = j;

            train_sets = zeros(Fs,62,train_num*2);


            classA = rand_data{index_A}(:,:,:);
            classB = rand_data{index_B}(:,:,:);

            train_sets(:,:,1:train_num) = classA(:,:,1:train_num);
            train_sets(:,:,(1+train_num):train_num*2) = classB(:,:,1:train_num);
            train_labels = [ones(1,train_num),zeros(1,train_num)];

            EEG_train.x = train_sets;
            EEG_train.y = train_labels;
            EEG_train.s = Fs;

            CSPMatrix{i,j} = learnCSP(EEG_train,[0 1]);
            train_features = extractCSP(EEG_train, CSPMatrix{i,j}, nbFilterPairs);
            train_features(:,21) = train_labels;
            [trainedClassifier{i,j}, validationAccuracy] = trainClassifier(train_features);
            % disp(['Acc: ', num2str(validationAccuracy)])
        end
    end
end

