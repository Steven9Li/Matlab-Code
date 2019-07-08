% matla��ͼ�ű�

clear;
clc;

%����ر��������ļ�
load('data\music_erp.mat');         % ERP�����ļ�
load('data\labels.mat');            % �缫��Ϣ�ļ�
load('data\featureStr.mat');        % ������Ϣ�ļ�
load('channal_Index.mat');          % �缫�Ų�����Ϣ�ļ�

% ������ͼ����
Nh = 9;             % ����
Nw = 9;             % ����
gap = [0.04 0.02];    % ͼ��߽�
marg_h = 0.02;       % ȫ����ͼ��figure���±߽�ľ���
marg_w = 0.02;       % ȫ����ͼ��figure���ұ߽�ľ���
marg_w = [marg_w marg_w];
marg_h = [marg_h marg_h];
axh = (1-sum(marg_h)-(Nh-1)*gap(1))/Nh; 
axw = (1-sum(marg_w)-(Nw-1)*gap(2))/Nw;
py_o = 1-marg_h(2)-axh;
px_o = marg_w(1);

loc_num = 62;
for k = 1:115
    % ȡERP�ļ���1ȡERP���ݣ�3ȡ���������
    epoch_sum = music_erp{k,1};
    epoch_sum2 = music_erp{k,3};
    
    % ��ͼ
    figure(k)
    % Ĭ����󻯲���
    %set(gcf,'outerposition',get(0,'screensize'));
    set(gcf,'position',[274,42,1200,1000])
    for i = 1:loc_num
        %axes(ha()); 
        indexh = ceil(channal_Index(i)/9);          % ����ͼλ�ڶ�����
        indexw = channal_Index(i) - (indexh-1)*9;          % ����ͼλ�ڶ�����
        px = px_o+(axw+gap(2))*(indexw-1);
        py = py_o-(axh+gap(1))*(indexh-1);
        axes('Units','normalized', ...
                'Position',[px py axw axh], ...
                'XTickLabel','', ...
                'YTickLabel','');
        %subplot(9,9,channal_Index(i))
        % ERP��ͼԤ������������ƽ��
        rx = double(epoch_sum(i,:));
        rx = resample(rx,125,250);
        rx = smooth(rx);
        
        % X�᷶Χ
        xl = -400:8:799;
        
        %��ͼ
        plot(xl,rx,'LineWidth',1);
        hold on

        rx2 = double(epoch_sum2(i,:));
        rx2 = resample(rx2,125,250);
        rx2 = smooth(rx2);
        plot(xl,rx2,'LineWidth',1);
        
        % �������
        plot([-400 799],[0 0],'k:');
        plot([0 0],[-1 1],'k:');
        % �趨x��y��̶�
        axis([-400 800 -1.2 1.2]);
        % �趨����
        title(labels{i},'Interpreter','none');
        box off;
    end
    

    % ����ͼ�������� ���� ���  �߶�
    h = legend({'radius = 1','radius = 2'},'Position',[0.8,0.85,0.1,0.05],'FontSize',10,'FontWeight','normal');
    % �ر�ͼ���߿�
    set(h, 'Box', 'off')
    % �����ܱ���
    suptitle([strrep(fstr{k},'_','\_'),'  Number of Points: ',num2str(music_erp{k,2})])
    saveas(gcf,['erp_',num2str(k),'.png']);
    close(k)
end
