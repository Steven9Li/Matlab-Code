clear;
clc;

load('useful_data\psd52_music.mat');
label = zeros(1*16,1);
data = zeros(1*16,52*5);
data1 = zeros(1*16,52);
data2 = zeros(1*16,52);
data4 = zeros(1*16,52);
data3 = zeros(1*16,52);
data5 = zeros(1*16,52);
count = 1;
negative = [5,12,13,14,15];
positive = [6,7,8,10,11];
middle = [1,2,3,4,9,16];

for i = 1:15
    for j = 1:16
        Pw = psd(i,j).Pw_music;
        Fw = psd(i,j).Fw_music;
        Pw_b = psd(i,j).Pw_eo1;
        Fw_b = psd(i,j).Fw_eo1;
        
        if psd(i,j).valence < 5
            label(count) = -1;
        elseif psd(i,j).valence <= 5
            label(count) = 1;
        else
            label(count) = 1;
        end
        
   
        for k = 1:52
            stats_m = stat(Fw(:,k), Pw(:,k));
            stats_b = stat(Fw_b(:,k), Pw_b(:,k));
%             data(count,k*5-4) = (stats_m(2,1)-stats_b(2,1))/stats_b(2,1);
%             data1(count,k) = (stats_m(2,1)-stats_b(2,1))/stats_b(2,1);
%             
%             data(count,k*5-3) = (stats_m(2,2)-stats_b(2,2))/stats_b(2,2);
%             data2(count,k) = (stats_m(2,2)-stats_b(2,2))/stats_b(2,2);
%             
%             data(count,k*5-2) = (stats_m(2,3)-stats_b(2,3))/stats_b(2,3);
%             data3(count,k) = (stats_m(2,3)-stats_b(2,3))/stats_b(2,3);
%             
%             data(count,k*5-1)  = (stats_m(2,4)-stats_b(2,4))/stats_b(2,4);
%             data4(count,k) = (stats_m(2,4)-stats_b(2,4))/stats_b(2,4);
%             
%             data(count,k*5) = (stats_m(2,5)-stats_b(2,5))/stats_b(2,5);
%             data5(count,k) = (stats_m(2,5)-stats_b(2,5))/stats_b(2,5);

            data(count,k*5-4) = (stats_m(2,1));
            data1(count,k) = (stats_m(2,1));
            
            data(count,k*5-3) = (stats_m(2,2));
            data2(count,k) = (stats_m(2,2));
            
            data(count,k*5-2) = (stats_m(2,3));
            data3(count,k) = (stats_m(2,3));
            
            data(count,k*5-1)  = (stats_m(2,4));
            data4(count,k) = (stats_m(2,4));
            
            data(count,k*5) = (stats_m(2,5));
            data5(count,k) = (stats_m(2,5));
        end
        count = count + 1;
    end
end

%% svm分类器
clc;
idx=randperm(240);
num = 220;
train = idx(1:num);
test = idx(num+1:240);

train_data = data(train,:);
train_label = label(train);
test_data = data(test,:);
test_label = label(test);
svmModel = svmtrain(train_data,train_label,'kernel_function','quadratic');
res = svmclassify(svmModel,test_data);
cc = 0;
for i = 1:20
    if res(i) ~= test_label(i)
        cc = cc + 1;
    end
end
r = 1 - cc /20

%% 脑地形图
clear;
clc;
load('useful_data\psd52_music.mat');
load('useful_data\EEG_CHANNEL52.mat');
chanlocs = channel_st{1,1};

bandpower_delta = zeros(16,52);
bandpower_theta = zeros(16,52);
bandpower_alpha = zeros(16,52);
bandpower_beta = zeros(16,52);
bandpower_gamma = zeros(16,52);

for i = 1:15
    for j = 1:16
        Pw = psd(i,j).Pw_music;
        Fw = psd(i,j).Fw_music;
        
        Pw_b = psd(i,j).Pw_eo1; 
        Fw_b = psd(i,j).Fw_eo1;
        
        for k = 1:52
            stats_b = stat(Fw_b(:,k), Pw_b(:,k));
            stats_m = stat(Fw(:,k), Pw(:,k));
            
            bandpower_delta(j,k) = bandpower_delta(j,k) + (stats_m(2,1) - stats_b(2,1))/stats_b(2,1);
            bandpower_theta(j,k) = bandpower_theta(j,k) + (stats_m(2,2) - stats_b(2,2))/stats_b(2,2);
            bandpower_alpha(j,k) = bandpower_alpha(j,k) + (stats_m(2,3) - stats_b(2,3))/stats_b(2,3);
            bandpower_beta(j,k)  = bandpower_beta(j,k) + (stats_m(2,4) - stats_b(2,4))/stats_b(2,4);
            bandpower_gamma(j,k) = bandpower_gamma(j,k) + (stats_m(2,5) - stats_b(2,5))/stats_b(2,5);
        end
    end
end

%% s三类情绪
negative = [5,12,13,14,15];
positive = [6,7,8,10,11];
middle = [1,2,3,4,9,16];
bandpower_delta_all = zeros(3,52);
bandpower_theta_all = zeros(3,52);
bandpower_alpha_all = zeros(3,52);
bandpower_beta_all = zeros(3,52);
bandpower_gamma_all = zeros(3,52);

for i = 1:16
    if any(negative==i) == 1
        bandpower_delta_all(1,:) = bandpower_delta_all(1,:) + bandpower_delta(i,:);
        bandpower_theta_all(1,:) = bandpower_theta_all(1,:) + bandpower_theta(i,:);
        bandpower_alpha_all(1,:) = bandpower_alpha_all(1,:) + bandpower_alpha(i,:);
        bandpower_beta_all(1,:) = bandpower_beta_all(1,:) + bandpower_beta(i,:);
        bandpower_gamma_all(1,:) = bandpower_gamma_all(1,:) + bandpower_gamma(i,:);
    end
    if any(positive==i) == 1
        bandpower_delta_all(2,:) = bandpower_delta_all(2,:) + bandpower_delta(i,:);
        bandpower_theta_all(2,:) = bandpower_theta_all(2,:) + bandpower_theta(i,:);
        bandpower_alpha_all(2,:) = bandpower_alpha_all(2,:) + bandpower_alpha(i,:);
        bandpower_beta_all(2,:) = bandpower_beta_all(2,:) + bandpower_beta(i,:);
        bandpower_gamma_all(2,:) = bandpower_gamma_all(2,:) + bandpower_gamma(i,:);
    end
    if any(middle==i) == 1
       bandpower_delta_all(3,:) = bandpower_delta_all(3,:) + bandpower_delta(i,:);
        bandpower_theta_all(3,:) = bandpower_theta_all(3,:) + bandpower_theta(i,:);
        bandpower_alpha_all(3,:) = bandpower_alpha_all(3,:) + bandpower_alpha(i,:);
        bandpower_beta_all(3,:) = bandpower_beta_all(3,:) + bandpower_beta(i,:);
        bandpower_gamma_all(3,:) = bandpower_gamma_all(3,:) + bandpower_gamma(i,:);
    end
end

% for i = 1:3
%     figure(i)
%     minm = -0.5;
%     maxm = 0.5;
%     if i== 3
%         cn = 16*6;
%     else
%         cn = 16*5;
%     end
%     bp = bandpower_alpha_all(i,:)/cn;
%     subplot(2,3,3);
%     % topoplot( bp(1:64), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'maplimits',[minm,maxm]);
%     topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
%     title('alpha（8~13Hz）');
%     cbar('vert');
% 
%     bp = bandpower_beta_all(i,:)/cn;
%     subplot(2,3,4);
%     topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
%     title('beta（13~30Hz）');
%     cbar('vert');
% 
%     bp = bandpower_gamma_all(i,:)/cn;
%     subplot(2,3,5);
%     topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
%     title('gammma（30~49Hz）');
%     cbar('vert');
% 
%     bp = bandpower_delta_all(i,:)/cn;
%     subplot(2,3,1);
%     topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
%     title('delta（0.5~4Hz）');
%     cbar('vert');
% 
%     bp = bandpower_theta_all(i,:)/cn;
%     subplot(2,3,2);
%     topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
%     title('theta（4~8Hz）');
%     cbar('vert');
%     str = [num2str(i),'.png'];
%     print(gcf,'-dpng',str);
% end
for i = 1:3
    if i == 3
        cn = 15*5;
    else
        cn = 15*6;
    end
  
    bandpower_alpha_all(i,:) = bandpower_alpha_all(i,:)/cn;
    
    bandpower_beta_all(i,:) = bandpower_beta_all(i,:)/cn;

    bandpower_gamma_all(i,:) = bandpower_gamma_all(i,:)/cn;
   
    bandpower_delta_all(i,:) = bandpower_delta_all(i,:)/cn;
    
    bandpower_theta_all(i,:) = bandpower_theta_all(i,:)/cn;
   
end
alpha = bandpower_alpha_all';
gamma = bandpower_gamma_all';
delta = bandpower_delta_all';
theta = bandpower_theta_all';

%% 做差
for i = 1:2
    figure(i)
    minm = -0.3;
    maxm = 0.3;
    cn = 15*5;
    cm = 15*6;
    bp = bandpower_alpha_all(i,:)/cn - bandpower_alpha_all(3,:)/cm;
    subplot(2,3,3);
    % topoplot( bp(1:64), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'maplimits',[minm,maxm]);
    topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
    title('alpha（8~13Hz）');
    cbar('vert');

    bp = bandpower_beta_all(i,:)/cn - bandpower_beta_all(3,:)/cm;
    subplot(2,3,4);
    topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
    title('beta（13~30Hz）');
    cbar('vert');

    bp = bandpower_gamma_all(i,:)/cn - bandpower_gamma_all(3,:)/cm;
    subplot(2,3,5);
    topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
    title('gammma（30~49Hz）');
    cbar('vert');

    bp = bandpower_delta_all(i,:)/cn - bandpower_delta_all(3,:)/cm;
    subplot(2,3,1);
    topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
    title('delta（0.5~4Hz）');
    cbar('vert');

    bp = bandpower_theta_all(i,:)/cn - bandpower_theta_all(3,:)/cm;
    subplot(2,3,2);
    topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
    title('theta（4~8Hz）');
    cbar('vert');
    str = [num2str(i),'.png'];
    print(gcf,'-dpng',str);
end


% %% 所有被试
% clear;
% clc;
% load('useful_data\psd52_music.mat');
% load('useful_data\EEG_CHANNEL52.mat');
% chanlocs = channel_st{1,1};
% 
% bandpower_delta = zeros(15,52);
% bandpower_theta = zeros(15,52);
% bandpower_alpha = zeros(15,52);
% bandpower_beta = zeros(15,52);
% bandpower_gamma = zeros(15,52);
% 
% for i = 1:15
%     for j = 1:16
%         Pw = psd(i,j).Pw_music;
%         Fw = psd(i,j).Fw_music;
%         
%         Pw_b = psd(i,j).Pw_eo1; 
%         Fw_b = psd(i,j).Fw_eo1;
%         
%         for k = 1:52
%             stats_b = stat(Fw_b(:,k), Pw_b(:,k));
%             stats_m = stat(Fw(:,k), Pw(:,k));
%             
%             bandpower_delta(i,k) = bandpower_delta(i,k) + (stats_m(2,1) - stats_b(2,1))/stats_b(2,1);
%             bandpower_theta(i,k) = bandpower_theta(i,k) + (stats_m(2,2) - stats_b(2,2))/stats_b(2,2);
%             bandpower_alpha(i,k) = bandpower_alpha(i,k) + (stats_m(2,3) - stats_b(2,3))/stats_b(2,3);
%             bandpower_beta(i,k)  = bandpower_beta(i,k) + (stats_m(2,4) - stats_b(2,4))/stats_b(2,4);
%             bandpower_gamma(i,k) = bandpower_gamma(i,k) + (stats_m(2,5) - stats_b(2,5))/stats_b(2,5);
%         end
%     end
% end
% figure(1)
% for i = 1:15
%     
%     minm = -2;
%     maxm = 2;
%     bp = bandpower_alpha(i,:)/15;
%     subplot(4,4,i);
%     % topoplot( bp(1:64), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'maplimits',[minm,maxm]);
%     topoplot(bp(1:52), chanlocs, 'style','map','electrodes','off','plotrad',0.7,'headrad',0.63,'conv','on','maplimits',[minm,maxm]);
%     title('alpha（8~13Hz）');
%     cbar('vert');
% end