% 脑地形图画图

% matla画图脚本

clear;
clc;

%导入必备的数据文件
load('Data\Img_IRP.mat');
load('Data\exp_channal.mat');

stmi_index = 1;
stmi_index = 1;



channal_num = 62;
epoch_sum = zeros(62,300);
epoch_sum2 = zeros(62,300);

for sub_index = 1:7
    for k=1:7
        epoch_sum = epoch_sum + Img_IRP{sub_index,stmi_index+k-1};
        epoch_sum2 = epoch_sum2 + Img_IRP{sub_index,stmi_index+7+k-1};
    end
end

epoch_sum = epoch_sum/49;
epoch_sum2 = epoch_sum2/49;

res = epoch_sum2 - epoch_sum;
res = res(:,101:300);

figure(1)
data = double(res(:,140));
% topoplot( bp(1:64), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'maplimits',[minm,maxm]);
topoplot(data, chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'maplimits',[-1 1]);
title('560ms','FontSize',12,'FontWeight','bold','fontname','Times New Remon');
cbar('vert');