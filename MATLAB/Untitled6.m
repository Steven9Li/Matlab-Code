% 2019/5/5
% IRP与ERP分类代码

%% 听觉
clear;clc;

sub_num = 7;
event_num = 2;
channal_num = 62;
erp_length = 300;
cal = zeros(sub_num, event_num);
loadpath = 'E:\\Data\\IRP\\';

% 分类标签
datatest = cell(13,2);
for i = 1:13
    for j = 1:2
        datatest{i,j} = zeros(1,201);
    end
end

load('small_channal_Index.mat');
simple_channal_num = 13;
count0 = 1;
count1 = 1;

fid = fopen('data.txt','w');
chan_index = 1;
for i = 1:7
    EEG = pop_loadset('filename',['sub_', num2str(i),'_f_r_re_ica_o.set'],'filepath',loadpath);
    data = EEG.data;
    event = EEG.event;
    epoch_sum_t = zeros(simple_channal_num,length(data));
    
    for ii = 1:simple_channal_num
        for j = 2:4
            epoch_sum_t(ii,:) = epoch_sum_t(ii,:) + data(small_channal_index(ii,j),:);
        end
    end
    
    data = epoch_sum_t;
    
    for k = 1:length(event)
        index = event(k).type;
%         if index == 10
%             index = 1;
%             cal(i, index) = cal(i, index) + 1;
%             zp = round(event(k).latency) + 100;
%             serp = data(:,zp - 100 : zp + 199);
%             
%             % 基线矫正
%             for j = 1:simple_channal_num
%                 serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
%             end
%             for j = 1:simple_channal_num
%                 datatest{j,1}(count1,1) = 1;
%                 datatest{j,1}(count1,2:201) = serp(chan_index,101:300);
%             end
%             
%             str = '|labels 0 1 |features ';
%             fprintf(fid,'%s',str);
%             for kk = 1:200
%                 fprintf(fid,'%f ',serp(j,kk));
%             end
%             fprintf(fid,'\n');
%             
%             count1 = count1 + 1;
%             
%         end
        
%         if index == 20
%             index = 2;
%             cal(i, index) = cal(i, index) + 1;
%             zp = round(event(k).latency) + 100;
%             serp = data(:,zp - 100 : zp + 199);
%             % 基线矫正
%             for j = 1:simple_channal_num
%                 serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
%             end
%             for j = 1:simple_channal_num
%                 datatest{j,2}(count0,1) = 0;
%                 datatest{j,2}(count0,2:201) = serp(chan_index,101:300);
%             end
%             
%             str = '|labels 1 0 |features ';
%             fprintf(fid,'%s',str);
%             for kk = 1:200
%                 fprintf(fid,'%f ',serp(j,kk));
%             end
%             fprintf(fid,'\n');
%             count0 = count0 + 1;   
%         end
        
        if index >= 71 && index <= 76
            index = 1;
            cal(i, index) = cal(i, index) + 1;
            zp = round(event(k).latency) + 100;
            serp = data(:,zp - 100 : zp + 199);
            
            % 基线矫正
            for j = 1:simple_channal_num
                serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
                serp(j,:) = smooth(serp(j,:));
            end
            for j = 1:simple_channal_num
                datatest{j,1}(count1,1) = 1;
                datatest{j,1}(count1,2:201) = serp(j,101:300);
            end
            
            str = '|labels 0 1 |features ';
            fprintf(fid,'%s',str);
            for kk = 1:200
                fprintf(fid,'%f ',serp(j,kk));
            end
            fprintf(fid,'\n');
            
            count1 = count1 + 1;
            
        end
        if index == 91
            index = 1;
            cal(i, index) = cal(i, index) + 1;
            zp = round(event(k).latency) + 100;
            serp = data(:,zp - 100 : zp + 199);
            
            % 基线矫正
            for j = 1:simple_channal_num
                serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
                serp(j,:) = smooth(serp(j,:));
            end
            for j = 1:simple_channal_num
                datatest{j,1}(count1,1) = 1;
                datatest{j,1}(count1,2:201) = serp(j,101:300);
            end
            
            str = '|labels 0 1 |features ';
            fprintf(fid,'%s',str);
            for kk = 1:200
                fprintf(fid,'%f ',serp(j,kk));
            end
            fprintf(fid,'\n');
            
            count1 = count1 + 1;
            
        end
        
        if index >= 171 && index <= 176
            index = 2;
            cal(i, index) = cal(i, index) + 1;
            zp = round(event(k).latency) + 100;
            serp = data(:,zp - 100 : zp + 199);
            % 基线矫正
            for j = 1:simple_channal_num
                serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
                serp(j,:) = smooth(serp(j,:));
            end
            for j = 1:simple_channal_num
                datatest{j,2}(count0,1) = 0;
                datatest{j,2}(count0,2:201) = serp(j,101:300);
            end
            
            str = '|labels 1 0 |features ';
            fprintf(fid,'%s',str);
            for kk = 1:200
                fprintf(fid,'%f ',serp(j,kk));
            end
            fprintf(fid,'\n');
            count0 = count0 + 1;   
        end
        
        if index == 191
            index = 2;
            cal(i, index) = cal(i, index) + 1;
            zp = round(event(k).latency) + 100;
            serp = data(:,zp - 100 : zp + 199);
            % 基线矫正
            for j = 1:simple_channal_num
                serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
                serp(j,:) = smooth(serp(j,:));
            end
            for j = 1:simple_channal_num
                datatest{j,2}(count0,1) = 0;
                datatest{j,2}(count0,2:201) = serp(j,101:300);
            end
            
            str = '|labels 1 0 |features ';
            fprintf(fid,'%s',str);
            for kk = 1:200
                fprintf(fid,'%f ',serp(j,kk));
            end
            fprintf(fid,'\n');
            count0 = count0 + 1;   
        end
            
    end
end

fclose(fid);

%% 听觉分类测试
clear;clc;
load('Data\imagedata.mat');

index = 1;
%MappedData = mapminmax(OriginalData, 0, 1);
data1 = datatest{index,1}(1:378,:);
for i = 1:378
    data1(i,2:201) = mapminmax(data1(i,2:201), -1, 1);
end

%data1 = datatest{index,1}(1:378,:);

data2 = datatest{index,2}(1:378,:);

for i = 1:378
    data2(i,2:201) = mapminmax(data2(i,2:201), -1, 1);
end

disp(num2str(index))
data = [data1;data2];

%% 听觉分类测试

clear;
clc;
load('data\imagedata.mat');

index = 2;

data1 = [datatest{index,1}(1:378,1),datatest{index,1}(1:378,25),datatest{index,1}(1:378,75),datatest{index,1}(1:378,100),datatest{index,1}(1:378,150)];

data2 = [datatest{index,2}(1:378,1),datatest{index,2}(1:378,25),datatest{index,2}(1:378,75),datatest{index,2}(1:378,100),datatest{index,2}(1:378,150)];

data = [data1;data2];