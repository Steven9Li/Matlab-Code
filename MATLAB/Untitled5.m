%% IRP行为数据分析
% 提取事件点
clear;clc;

sound_data_path = 'E:\\Data\\IRP_sound\\';
image_data_path = 'E:\\Data\\IRP\\';
% locpath = 'D:\\MyProjects\\MATLAB\\EEG_loc\\SynAmps2 Quik-Cap64.DAT';

sub_num = 7;
event = cell(2,sub_num);


for i = 1:sub_num
    filepath = strcat([sound_data_path,num2str(i),'.cnt']);
    disp(['load file: ', filepath]);
    EEG = pop_loadcnt(filepath, 'dataformat', 'auto', 'memmapfile', '');
    EEG = eeg_checkset( EEG );
    event{1,i} = EEG.event;
end

for i = 1:sub_num
    filepath = strcat([image_data_path,num2str(i),'.cnt']);
    disp(['load file: ', filepath]);
    EEG = pop_loadcnt(filepath, 'dataformat', 'auto', 'memmapfile', '');
    EEG = eeg_checkset( EEG );
    event{2,i} = EEG.event;
end

%% 统计

clear;clc;
load('data\event.mat');

% 听觉统计性（只有靶刺激有响应）
disp('统计听觉行为')
sound_count = zeros(7,5);     %靶刺激总数、正确按键次数、正确按键延迟均值、错误按键次数、错误按键延迟均值、正确率
for i = 1:7
    e = event{1,i};
    for k = 1:length(e)-1
        if e(k).type == 10
            sound_count(i,1) = sound_count(i,1)+1;
        end
        
        if e(k).type == 10 && e(k+1).type == 1
            sound_count(i,2) = sound_count(i,2)+1;
            sound_count(i,3) = sound_count(i,3)+(e(k+1).latency - e(k).latency);
        end
        
        if e(k).type ~= 10 && e(k+1).type == 1
            sound_count(i,4) = sound_count(i,4)+1;
            sound_count(i,5) = sound_count(i,5)+(e(k+1).latency - e(k).latency);
        end
    end
    sound_count(i,5) = sound_count(i,5)/(sound_count(i,4)*1000);
    sound_count(i,3) = sound_count(i,3)/(sound_count(i,2)*1000);
    sound_count(i,6) = sound_count(i,2)*100/(sound_count(i,1));
end
disp('听觉行为统计结束')

% 视觉统计性（两种刺激均有响应）
disp('统计视觉行为')
%1-4靶刺激总数、正确按键次数、正确按键延迟均值、正确率 
%5-8偏差刺激总数、正确按键次数、正确按键延迟均值、正确率
image_count = zeros(7,8);     

for i = 1:7
    e = event{2,i};
    for k = 1:length(e)-1
        if e(k).type < 100 && e(k).type > 10
            image_count(i,1) = image_count(i,1)+1;
        end
        
        if e(k).type > 100
            image_count(i,5) = image_count(i,5)+1;
        end
        
        if e(k).type < 100 && e(k+1).type == 2 && e(k).type > 10
            image_count(i,2) = image_count(i,2)+1;
            image_count(i,3) = image_count(i,3)+(e(k+1).latency - e(k).latency);
        end
        
        if e(k).type > 100 && e(k+1).type == 1
            image_count(i,6) = image_count(i,6)+1;
            image_count(i,7) = image_count(i,7)+(e(k+1).latency - e(k).latency);
        end
    end
     image_count(i,3) = image_count(i,3)/(image_count(i,2)*1000);
     image_count(i,7) = image_count(i,7)/(image_count(i,6)*1000);
     image_count(i,4) = image_count(i,2)/(image_count(i,1));
     image_count(i,8) = image_count(i,6)/(image_count(i,5));
end
disp('听觉行为统计结束')

%% 对被试1的Image响应时间做统计

image_data_path = 'E:\\Data\\IRP\\';
% locpath = 'D:\\MyProjects\\MATLAB\\EEG_loc\\SynAmps2 Quik-Cap64.DAT';
i=1;
filepath = strcat([image_data_path,num2str(i),'.cnt']);
disp(['load file: ', filepath]);
EEG = pop_loadcnt(filepath, 'dataformat', 'auto', 'memmapfile', '');
e = EEG.event;
time = zeros(300,2);
count = 1;
for k = 1:length(e)-1
    if e(k).type < 100 && e(k+1).type == 2 && e(k).type > 10
        time(count,1) = (e(k+1).latency - e(k).latency)/1000;
        time(count,2) = 2;
        count = count + 1;
    end

    if e(k).type > 100 && e(k+1).type == 1
        time(count,1) = (e(k+1).latency - e(k).latency)/1000;
        time(count,2) = 1;
        count = count + 1;
    end
end



