% 2019-3-21
% 常规ERP提取

clear;clc;

sub_num = 7;
event_num = 2;
channal_num = 62;
erp_length = 300;
Sound_IRP = cell(sub_num, event_num);
cal = zeros(sub_num, event_num);
loadpath = 'E:\\Data\\IRP_sound\\';

% 初始化
for i = 1:sub_num
    for j = 1:event_num
        Sound_IRP{i,j} = zeros(channal_num, erp_length);
    end
end

% 分类标签
datatest1 = zeros(300,201);
datatest0 = zeros(300,201);
count1 = 1;
count0 = 1;
for i = 1:1
    EEG = pop_loadset('filename',['sub_', num2str(i),'_f_r_re_ica_o.set'],'filepath',loadpath);
    data = EEG.data;
    event = EEG.event;
    
    for k = 1:length(event)
        index = event(k).type;
        if index == 10
            index = 1;
            cal(i, index) = cal(i, index) + 1;
            zp = round(event(k).latency) + 100;
            serp = data(:,zp - 100 : zp + 199);
            
            % 基线矫正
            for j = 1:channal_num
                serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
            end
            datatest1(count1,1) = 1;
            datatest1(count1,2:201) = serp(1,101:300);
            count1 = count1 + 1;
            Sound_IRP{i,index} = Sound_IRP{i,index} + serp;
        end
        
        if index == 20
            index = 2;
            cal(i, index) = cal(i, index) + 1;
            zp = round(event(k).latency) + 100;
            serp = data(:,zp - 100 : zp + 199);
            % 基线矫正
            for j = 1:channal_num
                serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
            end
            datatest0(count0,1) = 0;
            datatest0(count0,2:201) = serp(1,101:300);
            count0 = count0 + 1;
            Sound_IRP{i,index} = Sound_IRP{i,index} + serp;
        end
        
%         if index >= 171 && index <= 176
%             index = index - 163;
%             cal(i, index) = cal(i, index) + 1;
%             zp = round(event(k).latency);
%             serp = data(:,zp - 100 : zp + 199);
%             
%             % 基线矫正
%             for j = 1:channal_num
%                 serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
%             end
%             Img_IRP{i,index} = Img_IRP{i,index} + serp;
%         end
%         
%         if index == 191
%             index = 14;
%             cal(i, index) = cal(i, index) + 1;
%             zp = round(event(k).latency);
%             serp = data(:,zp - 100 : zp + 199);
%             
%             % 基线矫正
%             for j = 1:channal_num
%                 serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
%             end
%             Img_IRP{i,index} = Img_IRP{i,index} + serp;
%         end
    end
end

for i = 1:sub_num
    for j = 1:event_num
        Sound_IRP{i,j} = Sound_IRP{i,j}/cal(i,j);
    end
end

%% 11
clear;clc;
load('Data\Sound_IRP.mat');
load('channal_Index.mat');
%sub_index = 1;
stmi_index = 1;
channal_num = 62;
epoch_sum = zeros(62,300);
epoch_sum2 = zeros(62,300);

for sub_index = 1:1
    epoch_sum = epoch_sum + Sound_IRP{sub_index,stmi_index};
    epoch_sum2 = epoch_sum2 + Sound_IRP{sub_index,stmi_index+1};
end

% epoch_sum = epoch_sum/7;
% epoch_sum2 = epoch_sum2/7;

for i = 1:62
    h(i) = ttest2(epoch_sum(i,101:300),epoch_sum2(i,101:300));
end
figure(1)

for i = 1:channal_num
    subplot(9,9,channal_Index(i))

    rx = double(epoch_sum(i,:));
    rx = resample(rx,125,250);
    rx = smooth(rx);

    xl = -50:99;
    plot(xl,rx,'LineWidth',1);
    hold on
    plot([-50 99],[0 0],'k:');
    plot([0 0],[-1 1],'k:');

    rx2 = double(epoch_sum2(i,:));
    rx2 = resample(rx2,125,250);
    rx2 = smooth(rx2);
    plot(xl,rx2,'LineWidth',1);
    %title(labels{i});

end
%% 3
figure(2)

for i = 1:channal_num
    subplot(9,9,channal_Index(i))

    rx = double(epoch_sum(i,:));
    rx = resample(rx,125,250);
    rx = smooth(rx);

    xl = -50:99;
    %plot(xl,rx,'LineWidth',1);
    hold on
    plot([-50 99],[0 0],'k:');
    plot([0 0],[-1 1],'k:');

    rx2 = double(epoch_sum2(i,:));
    rx2 = resample(rx2,125,250);
    rx2 = smooth(rx2);
    plot(xl,rx2-rx,'LineWidth',1);
    %title(labels{i});

end

%% part 2
load('data\music_erp.mat');
res=zeros(1,62);
for i = 1:62
    a = music_erp{13,1}(i,101:300)';
    b = music_erp{13,3}(i,101:300)';
    
    res(i) = ttest2(a,b);
end

