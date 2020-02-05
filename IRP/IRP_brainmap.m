%% 将IRP画成脑地形图

clear;
clc;

% 导入数据

load('E:\Data\Using\Img_IRP.mat')
load('E:\Data\Chanlocs\chanlocs.mat')

stmi_index = 1;
channal_num = 62;
epoch_sum = zeros(62,300);
epoch_sum2 = zeros(62,300);

% 视觉
for sub_index = 1:7
    for k=1:7
        epoch_sum = epoch_sum + Img_IRP{sub_index,stmi_index+k-1};
        epoch_sum2 = epoch_sum2 + Img_IRP{sub_index,stmi_index+7+k-1};
    end
end

epoch_sum = epoch_sum/49;
epoch_sum2 = epoch_sum2/49;

figure(1)
for i = 1:20
    subplot(2,10,i)
    data = mean(epoch_sum(:,1+(i-1)*10:10*i),2);
    topoplot(data, chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'maplimits',[-1 1]);
    title([num2str(1+(i-1)*50),'ms ~ ',num2str(50*i),'ms'])
end

figure(2)
for i = 1:20
    subplot(2,10,i)
    data = mean(epoch_sum(:,1+(i-1)*10:10*i),2);
    topoplot(data, chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'maplimits',[-1 1]);
    title([num2str(1+(i-1)*50),'ms ~ ',num2str(50*i),'ms'])
end

figure(3)
for i = 1:20
    subplot(2,10,i)
    data = mean(epoch_sum2(:,1+(i-1)*10:10*i),2)-mean(epoch_sum(:,1+(i-1)*10:10*i),2);
    topoplot(data, chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'maplimits',[-1 1]);
    title([num2str(1+(i-1)*50),'ms ~ ',num2str(50*i),'ms'])
end