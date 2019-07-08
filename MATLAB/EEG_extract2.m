% EEG�ֶβ���
% �ص㣺ÿ��EEG�ĵ缫��Ŀ��һ����������ͬһ���豸�ɼ���
clear;clc;


% �ļ�λ��
savelocation = 'E:\\Data\\eeg_picture_3';
Fs = 1000;                   %������
picture_num = 300;
% ����ýṹ��

picEpochs(picture_num) = struct('index',[],'data',[]);

i = 6;
EEG = pop_loadset('filename',['sub_', num2str(i),'_f_o.set'],'filepath',savelocation);
data_all = EEG.data;
event = EEG.event;
chanlocs = EEG.chanlocs;

% ��ȡEEGƬ��
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
