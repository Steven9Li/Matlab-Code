% EEG分段操作
% 特点：每个EEG的电极数目不一样，但都是同一套设备采集的
clear;clc;


% 文件位置
savelocation = 'E:\\Data\\eeg_picture_3';
Fs = 1000;                   %采样率
picture_num = 300;
% 定义好结构体

picEpochs(picture_num) = struct('index',[],'data',[]);

i = 6;
EEG = pop_loadset('filename',['sub_', num2str(i),'_f_o.set'],'filepath',savelocation);
data_all = EEG.data;
event = EEG.event;
chanlocs = EEG.chanlocs;

% 截取EEG片段
index = 1;
for k = 1:length(event)
    e = event(k);
    e.latency = round(e.latency);
    
    if e.type >= 11 && e.type <= 160
        %disp(e.type)
        picEpochs(index).index = e.type - 10;
        data = data_all(: , e.latency-0.5*Fs+1 : e.latency+1.5*Fs);
        avg = mean(data(:,1:500),2);
        ravg = repmat(avg,1,2000);
        picEpochs(index).data = data - ravg;
        index = index + 1;  
    end
end

save pic6 picEpochs;
