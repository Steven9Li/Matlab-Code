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
% step 0: ����EEG�ṹ�壬���ָ�������ʺ�ʱ����EEG�ṹ��
EEG_test = createData(fs, time);

%% step 1: �ں�����
indext = 122950;
cl = 5;
EEG_data = EEG_all.data(:,1+indext : indext+fs*time);
EEG_test.data = EEG_data;

% step 2: ����Ԥ�����˲���clean
data = PreProcess(EEG_test);

% step 3: ������ȡ

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

%% Test ����ͨ�ź����ݶ�ȡ
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
% step 0: ����EEG�ṹ�壬���ָ�������ʺ�ʱ����EEG�ṹ��
EEG_test = createData(fs, time);

%% step 1: �ں�����
indext = 122950;
cl = 5;
EEG_data = EEG_all.data(:,1+indext : indext+fs*time);
EEG_test.data = EEG_data;

% step 2: ����Ԥ�����˲���clean
data = PreProcess(EEG_test);

% step 3: ������ȡ

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

%% Test ����ͨ�ź����ݶ�ȡ
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
