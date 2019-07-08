                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 % 2019/3/7
% 李洪伟
% EEG分段后处理过程

%% part 1
% 同一首音乐整段叠加
load('music_data.mat');
load('channal_num.mat');
res = cell(1,16);

for i = 1:16
    data = zeros(62,6000);
    for j = 1:31
        data = data + music_data{j,i};
    end
    for j = 1:62
        data(j,:) = data(j,:)/channal_num(j);
    end
    res{i} = data;
end

%% test 1
[F,p] = Frequency(res{i}(14,:), 250 ,250);
%p = p(1:100);
%F = F(1:100);
plot(p,F);
%axis([0 100 0 10]);

%% part 2

% ERP提取
clear;
clc;

load('data\music_data.mat');
load('data\channal_num.mat');

sub_num = 31;
music_num = 16;
point_num = 20;
loc_num = 62;
% -0.4,0.8
erp_length = 300;
point = load('data\musicEFA.mat');
music_erp = cell(115,4);
for feature_i = 1:115
% feature_i = 25;
disp(feature_i)
    fp = zeros(music_num,1);
    for i = 1:music_num
        for j = 1:length(point.musicFeature(i).ep(feature_i,:))
            fp(i,j) = point.musicFeature(i).ep(feature_i,j);
        end
    end

    % 取相同数目的随机点
    rp = zeros(music_num, point_num);
    for i = 1:music_num
        for j = 1:point_num
            if fp(i,j) == 0
                break;
            else
                rp(i,j) = (int32(rand()*5700) + 100)/2.5;
            end
        end
    end

    count = 0;
    epoch_sum = zeros(loc_num,erp_length);
    for music_index = 1:music_num
        for i = 1:sub_num
            fea = fp(music_index,:);
            for k = 1:point_num
                if fea(k) == 0
                    break;
                else
                    % 获得事件点对应的EEG数据点
                    index = int32(fea(k)*2.5);
                    if index <= 100 || index > 6000 - 200
                        break;
                    end
                    serp = music_data{i,music_index}(:,index-100:index+199);
                    % 基线矫正
                    for j = 1:loc_num
                        serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
                    end
                    epoch_sum = epoch_sum + serp;
                    count = count + 1;
                end
            end
        end
    end
    
    % 总叠加次数
    count = count / sub_num;
    times = repmat(count*channal_num,[1,erp_length]);
    epoch_sum = epoch_sum./times;
    %disp('信息点叠加平均完成')
    music_erp{feature_i, 1} = epoch_sum;
    music_erp{feature_i, 2} = count;
    
    count = 0;
    epoch_sum2 = zeros(loc_num,erp_length);
    for music_index = 1:music_num
        for i = 1:sub_num
            fea = rp(music_index,:);
            for k = 1:point_num
                if fea(k) == 0
                    break;
                else
                    % 获得事件点对应的EEG数据点
                    index = int32(fea(k)*2.5);
                    if index <= 100 || index > 6000 - 200
                        break;
                    end
                    serp = music_data{i,music_index}(:,index-100:index+199);
                    % 基线矫正
                    for j = 1:loc_num
                        serp(j,:) = serp(j,:) - ones(1,erp_length)*mean(serp(j,1:100));
                    end
                    epoch_sum2 = epoch_sum2 + serp;
                    count = count + 1;
                end
            end
        end
    end
    count = count / sub_num;
    times = repmat(count*channal_num,[1,erp_length]);
    epoch_sum2 = epoch_sum2./times;
    music_erp{feature_i, 3} = epoch_sum2;
    music_erp{feature_i, 4} = count;
    disp('End')
end
%% 画图
clear;
clc;
load('data\music_erp.mat');
load('data\labels.mat');
load('data\featureStr.mat');
load('channal_Index.mat');
loc_num = 62;
for k = 15:15
    epoch_sum = music_erp{k,1};
    epoch_sum2 = music_erp{k,3};
    figure(k)   
    set(gcf,'outerposition',get(0,'screensize'));
    set(gcf,'position',[500,500,2000,1000])
    for i = 1:loc_num
        subplot(9,9,channal_Index(i))

        rx = double(epoch_sum(i,:));
        rx = resample(rx,125,250);
        rx = smooth(rx);

        xl = -400:8:799;
        plot(xl,rx,'LineWidth',1);
        hold on
        

        rx2 = double(epoch_sum2(i,:));
        rx2 = resample(rx2,125,250);
        rx2 = smooth(rx2);
        plot(xl,rx2,'LineWidth',1);
        
        plot([-400 799],[0 0],'k:');
        plot([0 0],[-1 1],'k:');
        %xlabel('ms')
        axis([-400 800 -1 1]);
        title(labels{i},'Interpreter','none');

    end
    legend('标签1','标签2','location','northwest');
    suptitle([strrep(fstr{k},'_','\_'),'  Number of Points: ',num2str(music_erp{k,2})])
    %saveas(gcf,['erp',num2str(k),'.png']);
    %close(k)
end

%% part 3
clear;clc;

load('data\music_erp.mat');
k=4;
epoch_sum = music_erp{k,1};
epoch_sum2 = music_erp{k,3};

h = zeros(1,62);
for i = 1:62
    h(i) = ttest2(epoch_sum(i,101:200),epoch_sum2(i,101:200));
end