%% 去飘移
clear;clc;
load('Sports5-r.mat');
for k = 1:8
    disp(k)
for i = 1:62
    %disp(i)
    for j = 1:200
        data{k}(:,i,j) = data{k}(:,i,j) - ones(1000,1,1)*mean(data{k}(:,i,j));
    end
end
end

%% 训练分类器

%load('Sports5-r.mat');
Fs = 1000;
nbFilterPairs = 10;
rand_data = cell(1,8);
CSPMatrix = cell(8,8);
trainedClassifier = cell(8,8);
trials_num = 200;
train_num = 160;
test_num = 40;

for i = 1:8
    rA = randperm(trials_num);
    rand_data{i} = data{i}(:,:,rA);
end

for i = 1:8
    for j = (i+1):8

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
        disp(['Acc: ', num2str(validationAccuracy)])
    end
end
save('classifierNoclean-r','CSPMatrix','trainedClassifier');

%% 一对一多分类
% clear;clc;
% % 构建测试集
% load('classifierNoclean.mat');
% load('Sports6.mat');
% Fs = 1000;
% nbFilterPairs = 10;
% trials_num = 80;
% train_num = 64;
% test_num = 16;

for ii = 1:7
for jj = (ii+1):7
classes = [1,2,3,4,5,6,7,8];
classes(jj) = [];
classes(ii) = [];
test_sets = zeros(Fs,62,test_num*6);
test_labels = zeros(1,test_num*6);

for i = 1:6
    test_sets(:,:,(i-1)*test_num+1:i*test_num) = rand_data{classes(i)}(:,:,train_num+1:trials_num);
    test_labels((i-1)*test_num+1:i*test_num) = ones(1,test_num)*classes(i);
end

test_res = zeros(test_num*6, 8);

for i = 1:6
    for j = (i+1):6
        EEG_test.x = test_sets;
        test_features = extractCSP(EEG_test, CSPMatrix{classes(i),classes(j)}, nbFilterPairs);
        test_features(:,21) = [];
        y = trainedClassifier{classes(i),classes(j)}.predictFcn(test_features);
        for k = 1:length(y)
            if y(k) == 1
                test_res(k,classes(i)) = test_res(k,classes(i)) + 1;
            else
                test_res(k,classes(j)) = test_res(k,classes(j)) + 1;
            end
        end
        
    end
end

[a, res] = max(test_res');
sucess = 0;
for i = 1:5*test_num
    if res(i) == test_labels(i)
        sucess = sucess+1;
    end
end

acc = sucess/(test_num*5);
disp([num2str(ii),',',num2str(jj),' 识别率为： ', num2str(acc)])
end
end

%% 一对一多分类，使用非训练数据)
clear;clc;
% 构建测试集
load('classifier.mat');     % Sports5的数据训练的CSP和SVM
load('Sports5CSP.mat');

Fs = 1000;
nbFilterPairs = 10;
trials_num = 80;

for ii = 1:7
for jj = (ii+1):7
classes = [1,2,3,4,5,6,7];
classes(jj) = [];
classes(ii) = [];
test_sets = zeros(Fs,62,trials_num*5);
test_labels = zeros(1,trials_num*5);

for i = 1:5
    test_sets(:,:,(i-1)*trials_num+1:i*trials_num) = data{classes(i)}(:,:,1:trials_num);
    test_labels((i-1)*trials_num+1:i*trials_num) = ones(1,trials_num)*classes(i);
end

test_res = zeros(trials_num*5, 7);

for i = 1:5
    for j = (i+1):5
        EEG_test.x = test_sets;
        test_features = extractCSP(EEG_test, CSPMatrix{classes(i),classes(j)}, nbFilterPairs);
        test_features(:,21) = [];
        y = trainedClassifier{classes(i),classes(j)}.predictFcn(test_features);
        for k = 1:length(y)
            if y(k) == 1
                test_res(k,classes(i)) = test_res(k,classes(i)) + 1;
            else
                test_res(k,classes(j)) = test_res(k,classes(j)) + 1;
            end
        end
        
    end
end

[a, res] = max(test_res');
sucess = 0;
for i = 1:5*trials_num
    if res(i) == test_labels(i)
        sucess = sucess+1;
    end
end

acc = sucess/(trials_num*5);
disp([num2str(ii),',',num2str(jj),' 识别率为： ', num2str(acc)])
end
end

