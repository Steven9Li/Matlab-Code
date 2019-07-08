%% IRP��Ϊ���ݷ���
% ��ȡ�¼���
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

%% ͳ��

clear;clc;
load('data\event.mat');

% ����ͳ���ԣ�ֻ�ад̼�����Ӧ��
disp('ͳ��������Ϊ')
sound_count = zeros(7,5);     %�д̼���������ȷ������������ȷ�����ӳپ�ֵ�����󰴼����������󰴼��ӳپ�ֵ����ȷ��
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
disp('������Ϊͳ�ƽ���')

% �Ӿ�ͳ���ԣ����ִ̼�������Ӧ��
disp('ͳ���Ӿ���Ϊ')
%1-4�д̼���������ȷ������������ȷ�����ӳپ�ֵ����ȷ�� 
%5-8ƫ��̼���������ȷ������������ȷ�����ӳپ�ֵ����ȷ��
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
disp('������Ϊͳ�ƽ���')

%% �Ա���1��Image��Ӧʱ����ͳ��

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



