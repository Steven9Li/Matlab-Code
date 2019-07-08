% matla��ͼ�ű�

clear;
clc;

%����ر��������ļ�
%load('Data\Img_IRP.mat');
%load('data\music_erp.mat');         % ERP�����ļ�
%load('data\labels.mat');            % �缫��Ϣ�ļ�
%load('data\featureStr.mat');        % ������Ϣ�ļ�
load('small_channal_Index.mat');     % �缫�Ų�����Ϣ�ļ�
load('data\music_erp.mat');          % ERP�����ļ�

% ������ͼ����
Nh = 5;             % ����
Nw = 5;             % ����
gap = [0.08 0.04];    % ͼ��߽�
marg_h = 0.02;       % ȫ����ͼ��figure���±߽�ľ���
marg_w = 0.02;       % ȫ����ͼ��figure���ұ߽�ľ���
marg_w = [marg_w marg_w];
marg_h = [marg_h marg_h];
axh = (1-sum(marg_h)-(Nh-1)*gap(1))/Nh;
axw = (1-sum(marg_w)-(Nw-1)*gap(2))/Nw;
py_o = 1-marg_h(2)-axh;
px_o = marg_w(1);
%str={'FP','LF','F','RF','LT','LC','C','RC','RT','LP','P','RP','O'};
str={'ǰ��','���Ҷ','������','�Ҷ�Ҷ','���Ҷ','������','����','������','���Ҷ','��Ҷ','��Ҷ����','�Ҷ�Ҷ','��Ҷ'};

k = 14;

loc_num = 62;
simple_channal_num = 13;
epoch_sum = music_erp{k,1};
epoch_sum2 = music_erp{k-1,1};
epoch_sum_t = zeros(simple_channal_num,300);
epoch_sum2_t = zeros(simple_channal_num,300);
for i = 1:simple_channal_num
    for j = 2:4
        epoch_sum_t(i,:) = epoch_sum_t(i,:) + epoch_sum(small_channal_index(i,j),:);
        epoch_sum2_t(i,:) = epoch_sum2_t(i,:) + epoch_sum2(small_channal_index(i,j),:);
    end
end
load('sirp.mat');
epoch_sum = epoch_sum_t/3;
epoch_sum2 = res;
% ��ͼ
k=1;
figure(k)
% Ĭ����󻯲���
%set(gcf,'outerposition',get(0,'screensize'));
set(gcf,'position',[274,42,1200,800])
for i = 1:simple_channal_num
    %axes(ha()); 
    indexh = ceil(small_channal_index(i,1)/5);          % ����ͼλ�ڶ�����
    indexw = small_channal_index(i,1) - (indexh-1)*5;          % ����ͼλ�ڶ�����
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
    xlabel('Time/ms')
    ylabel('Amplitude/uv')
    % �������
    plot([-400 799],[0 0],'k:');
    plot([0 0],[-1 1],'k:');
    % �趨x��y��̶�
    axis([-400 800 -1.2 1.2]);
    % �趨����
    title(str{i},'Interpreter','none','FontSize',10);
    box off;
end


% ����ͼ�������� ���� ���  �߶�
%h = legend({'radius = 1','radius = 2'},'Position',[0.8,0.85,0.1,0.05],'FontSize',10,'FontWeight','normal');
% �ر�ͼ���߿�
%set(h, 'Box', 'off')
saveas(gcf,'oddball.png');
%close(k)

