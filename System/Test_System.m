<<<<<<< HEAD
clear;clc;

filename = 'D:\\MyProjects\\SportsThinking\\Data\\Xcat 20190523\\Acquisition 06.dap';
EEG_all = loadcurry(filename, 'CurryLocations', 'False');


%% 1
fs = 1000;
time = 20;
load('classifier.mat');



%% start
tic;
% step 0: 生成EEG结构体，获得指定采样率和时长的EEG结构体
EEG_test = createData(fs, time);

%% step 1: 融合数据
indext = 122950;
cl = 5;
EEG_data = EEG_all.data(:,1+indext : indext+fs*time);
EEG_test.data = EEG_data;

% step 2: 数据预处理，滤波，clean
data = PreProcess(EEG_test);

% step 3: 特征提取

Fs = 1000;
nbFilterPairs = 10;
acc = 0;
for t = 1:20
    test_sets(:,:,1) = data(:,(t-1)*fs+1:t*fs);
    test_res = zeros(1,7);

    for i = 1:7
        for j = (i+1):7
            EEG_test1.x = test_sets;
            test_features = extractCSP(EEG_test1, CSPMatrix{i,j}, nbFilterPairs);
            test_features(:,21) = [];
            y = trainedClassifier{i,j}.predictFcn(test_features);
            if y == 1
                test_res(i) = test_res(i) + 1;
            else
                test_res(j) = test_res(j) + 1;
            end
        end
    end
    [a, res] = max(test_res);
    
    if res == cl
        acc = acc + 1;
    end
    
end
disp(num2str(acc/20))

%% Test 数据通信和数据读取
clear;clc;

global strConfigFile;
strConfigFile = 'Synamp2.xml';

[fileConfig, message] = fopen(strConfigFile, 'r');
if(fileConfig < 0)
    disp(message);
else
    % read in the string
    strConfiguration = '';
    while feof(fileConfig) == 0
        tline = fgetl(fileConfig);
        disp(tline)
        % concatenate the strings
        strConfiguration = [strConfiguration, tline];
    end
end



=======
clear;clc;

filename = 'D:\\MyProjects\\SportsThinking\\Data\\Xcat 20190523\\Acquisition 06.dap';
EEG_all = loadcurry(filename, 'CurryLocations', 'False');


%% 1
fs = 1000;
time = 20;
load('classifier.mat');



%% start
tic;
% step 0: 生成EEG结构体，获得指定采样率和时长的EEG结构体
EEG_test = createData(fs, time);

%% step 1: 融合数据
indext = 122950;
cl = 5;
EEG_data = EEG_all.data(:,1+indext : indext+fs*time);
EEG_test.data = EEG_data;

% step 2: 数据预处理，滤波，clean
data = PreProcess(EEG_test);

% step 3: 特征提取

Fs = 1000;
nbFilterPairs = 10;
acc = 0;
for t = 1:20
    test_sets(:,:,1) = data(:,(t-1)*fs+1:t*fs);
    test_res = zeros(1,7);

    for i = 1:7
        for j = (i+1):7
            EEG_test1.x = test_sets;
            test_features = extractCSP(EEG_test1, CSPMatrix{i,j}, nbFilterPairs);
            test_features(:,21) = [];
            y = trainedClassifier{i,j}.predictFcn(test_features);
            if y == 1
                test_res(i) = test_res(i) + 1;
            else
                test_res(j) = test_res(j) + 1;
            end
        end
    end
    [a, res] = max(test_res);
    
    if res == cl
        acc = acc + 1;
    end
    
end
disp(num2str(acc/20))

%% Test 数据通信和数据读取
clear;clc;

global strConfigFile;
strConfigFile = 'Synamp2.xml';

[fileConfig, message] = fopen(strConfigFile, 'r');
if(fileConfig < 0)
    disp(message);
else
    % read in the string
    strConfiguration = '';
    while feof(fileConfig) == 0
        tline = fgetl(fileConfig);
        disp(tline)
        % concatenate the strings
        strConfiguration = [strConfiguration, tline];
    end
end



>>>>>>> first
