% matla画图脚本

clear;
clc;

%导入必备的数据文件
load('data\music_erp.mat');         % ERP数据文件
load('data\labels.mat');            % 电极信息文件
load('data\featureStr.mat');        % 特征信息文件
load('channal_Index.mat');          % 电极排布的信息文件

% 设置子图属性
Nh = 9;             % 行数
Nw = 9;             % 列数
gap = [0.04 0.02];    % 图像边界
marg_h = 0.02;       % 全部子图到figure上下边界的距离
marg_w = 0.02;       % 全部子图到figure左右边界的距离
marg_w = [marg_w marg_w];
marg_h = [marg_h marg_h];
axh = (1-sum(marg_h)-(Nh-1)*gap(1))/Nh; 
axw = (1-sum(marg_w)-(Nw-1)*gap(2))/Nw;
py_o = 1-marg_h(2)-axh;
px_o = marg_w(1);

loc_num = 62;
for k = 1:115
    % 取ERP文件，1取ERP数据，3取随机点数据
    epoch_sum = music_erp{k,1};
    epoch_sum2 = music_erp{k,3};
    
    % 画图
    figure(k)
    % 默认最大化操作
    %set(gcf,'outerposition',get(0,'screensize'));
    set(gcf,'position',[274,42,1200,1000])
    for i = 1:loc_num
        %axes(ha()); 
        indexh = ceil(channal_Index(i)/9);          % 该子图位于多少行
        indexw = channal_Index(i) - (indexh-1)*9;          % 该子图位于多少列
        px = px_o+(axw+gap(2))*(indexw-1);
        py = py_o-(axh+gap(1))*(indexh-1);
        axes('Units','normalized', ...
                'Position',[px py axw axh], ...
                'XTickLabel','', ...
                'YTickLabel','');
        %subplot(9,9,channal_Index(i))
        % ERP画图预处理，降采样，平滑
        rx = double(epoch_sum(i,:));
        rx = resample(rx,125,250);
        rx = smooth(rx);
        
        % X轴范围
        xl = -400:8:799;
        
        %画图
        plot(xl,rx,'LineWidth',1);
        hold on

        rx2 = double(epoch_sum2(i,:));
        rx2 = resample(rx2,125,250);
        rx2 = smooth(rx2);
        plot(xl,rx2,'LineWidth',1);
        
        % 画零点线
        plot([-400 799],[0 0],'k:');
        plot([0 0],[-1 1],'k:');
        % 设定x，y轴刻度
        axis([-400 800 -1.2 1.2]);
        % 设定标题
        title(labels{i},'Interpreter','none');
        box off;
    end
    

    % 设置图例，左右 上下 宽度  高度
    h = legend({'radius = 1','radius = 2'},'Position',[0.8,0.85,0.1,0.05],'FontSize',10,'FontWeight','normal');
    % 关闭图例边框
    set(h, 'Box', 'off')
    % 设置总标题
    suptitle([strrep(fstr{k},'_','\_'),'  Number of Points: ',num2str(music_erp{k,2})])
    saveas(gcf,['erp_',num2str(k),'.png']);
    close(k)
end
