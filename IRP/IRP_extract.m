% 视觉IRP提取
% 提取 -200ms ~ 1000ms
% 采样率为250Hz，所以共有300个点

clear;clc;

sub_num = 7;
event_num = 2;
channal_num = 62;
erp_length = 300;
IRP_image = cell(sub_num, event_num);
cal = zeros(sub_num, event_num);
loadpath = 'E:\\Data\\EEG\\EEG_IRP\\Visual\\ProProcess_noclean';

% 初始化


    event1 = zeros(2,62,300);
    event2 = zeros(2,62,300);
    count1 = 1;
    count2 = 1;

for i = 1:sub_num
    EEG = pop_loadset('filename',['sub_', num2str(i),'_f_r_re_ica_o_iclabel.set'],'filepath',loadpath);
    data = EEG.data;
    event = EEG.event;
    
    % 分类标签

    
    for k = 1:length(event)
        index = event(k).type;
        
        if index >= 171 && index <= 176
            zp = round(event(k).latency);
            serp = data(:,zp - 50 + 1 : zp + 250);
            
            % 基线矫正
            serp = serp - mean(serp(:,1:50),2);
            event1(count1,:,:) = serp;
            count1 = count1 + 1;
        end
        
        if index == 191
            zp = round(event(k).latency);
            serp = data(:,zp - 50 + 1 : zp + 250);
            
            % 基线矫正
            serp = serp - mean(serp(:,1:50),2);
            event1(count1,:,:) = serp;
            count1 = count1 + 1;
        end
        
        if index >= 71 && index <= 76
            zp = round(event(k).latency);
            serp = data(:,zp - 50 + 1 : zp + 250);
            
            % 基线矫正
            serp = serp - mean(serp(:,1:50),2);
            event2(count2,:,:) = serp;
            count2 = count2 + 1;
        end
        
        if index == 91
            zp = round(event(k).latency);
            serp = data(:,zp - 50 + 1 : zp + 250);
            
            % 基线矫正
            serp = serp - mean(serp(:,1:50),2);
            event2(count2,:,:) = serp;
            count2 = count2 + 1;
        end
    end
    
end
