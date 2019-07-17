clear;
clc;

load('psd_deap.mat');
label = zeros(32*40,1);
data = zeros(32*40,32*5);
count = 1;

for i = 1:32
    for j = 1:40
        Pw = psd(i,j).Pw_music;
        Fw = psd(i,j).Fw_music;
        
        if psd(i,j).valence < 5
            label(count) = -1;
        elseif psd(i,j).valence == 5
            label(count) = 1;
        else
            label(count) = 1;
        end
        
        for k = 1:32
            stats_m = stat(Fw(:,k), Pw(:,k));
            data(count,k*5-4) = stats_m(2,1);
            data(count,k*5-3) = stats_m(2,2);
            data(count,k*5-2) = stats_m(2,3);
            data(count,k*5-1)  = stats_m(2,4);
            data(count,k*5) = stats_m(2,5);
        end
        count = count + 1;
    end
end
%% svm·ÖÀàÆ÷
clc;
idx=randperm(1280);
num = 1000;
train = idx(1:num);
test = idx((num+1):1280);

train_data = data(train,:);
train_label = label(train);
test_data = data(test,:);
test_label = label(test);
svmModel = svmtrain(train_data,train_label,'kernel_function','linear');
res = svmclassify(svmModel,test_data);
cc = 0;
for i = 1:280
    if res(i) ~= test_label(i)
        cc = cc + 1;
    end
end
r = 1 - cc /280