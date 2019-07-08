% IRP��ͼ�ű�

clear;
clc;

%����ر��������ļ�
%load('Data\Sound_IRP.mat');
load('data\Img_IRP.mat');         % ERP�����ļ�
load('data\labels.mat');            % �缫��Ϣ�ļ�
load('data\featureStr.mat');        % ������Ϣ�ļ�
load('small_channal_Index.mat');          % �缫�Ų�����Ϣ�ļ�

stmi_index = 1;
channal_num = 62;

y1 = -3;
y2 = 3;
epoch_sum = zeros(62,300);
epoch_sum2 = zeros(62,300);

% �Ӿ�
for sub_index = 1:7  
    for k=1:7
        if k == 1||k==7
        epoch_sum = epoch_sum + Img_IRP{sub_index,stmi_index+k-1};
        epoch_sum2 = epoch_sum2 + Img_IRP{sub_index,stmi_index+7+k-1};
        end
    end
end

% ����
% for sub_index = 1:7
% 
%         epoch_sum = epoch_sum + Sound_IRP{sub_index,stmi_index};
%         epoch_sum2 = epoch_sum2 + Sound_IRP{sub_index,stmi_index+1};
% 
% end

epoch_sum = epoch_sum/14;
epoch_sum2 = epoch_sum2/14;

% ������ͼ����
Nh = 5;             % ����
Nw = 5;             % ����
gap = [0.1 0.04];    % ͼ��߽�
marg_h = 0.08;       % ȫ����ͼ��figure���±߽�ľ���
marg_w = 0.02;       % ȫ����ͼ��figure���ұ߽�ľ���
marg_w = [marg_w marg_w];
marg_h = [marg_h marg_h];
axh = (1-sum(marg_h)-(Nh-1)*gap(1))/Nh; 
axw = (1-sum(marg_w)-(Nw-1)*gap(2))/Nw;
py_o = 1-marg_h(2)-axh;
px_o = marg_w(1);
%str={'FP','LF','F','RF','LT','LC','C','RC','RT','LP','P','RP','O'};
str={'ǰ��','���Ҷ','������','�Ҷ�Ҷ','���Ҷ','������','����','������','���Ҷ','��Ҷ','��Ҷ����','�Ҷ�Ҷ','��Ҷ'};

loc_num = 62;
simple_channal_num = 13;
epoch_sum_t = zeros(simple_channal_num,300);
epoch_sum2_t = zeros(simple_channal_num,300);
for i = 1:simple_channal_num
    for j = 2:4
        epoch_sum_t(i,:) = epoch_sum_t(i,:) + epoch_sum(small_channal_index(i,j),:);
        epoch_sum2_t(i,:) = epoch_sum2_t(i,:) + epoch_sum2(small_channal_index(i,j),:);
    end
end

epoch_sum = epoch_sum_t/3;
epoch_sum2 = epoch_sum2_t/3;
% ��ͼ
k=1;
figure(k)
% Ĭ����󻯲���
%set(gcf,'outerposition',get(0,'screensize'));
set(gcf,'position',[274,42,1100,900])
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
    rx = rx(26:150);
    % X�᷶Χ
    xl = -200:8:799;

    %��ͼ1
    plot(xl,rx,'LineWidth',1.5);
    hold on

    rx2 = double(epoch_sum2(i,:));
    rx2 = resample(rx2,125,250);
    rx2 = smooth(rx2);
    rx2 = rx2(26:150);
    
    %��ͼ2
    plot(xl,rx2,'LineWidth',1.5);
    hold on
    xlabel('Time/ms','FontSize',10)
    ylabel('Amplitude/uv','FontSize',10)
    % �������
%     y2 = max(max(rx),max(rx2));
%     y1 = min(min(rx),min(rx2));
    
%     y1 = -1.8;
%     y2 = 2.5;
    
    plot([-200 799],[0 0],'k:','LineWidth',1.5);
    plot([0 0],[y1 y2],'k:','LineWidth',1.5);
    % �趨x��y��̶�
    axis([-200 800 y1 y2]);
    % �趨����
    title(str{i},'Interpreter','none','FontSize',12,'FontWeight','normal','fontname','����');
    box off;
    set(gca,'FontSize',10);
end


% ����ͼ�������� ���� ���  �߶�
%h = legend({'radius = 1','radius = 2'},'Position',[0.8,0.85,0.1,0.05],'FontSize',10,'FontWeight','normal');
% �ر�ͼ���߿�
%set(h, 'Box', 'off')
%saveas(gcf,['v-',num2str(sub_index),'-7-1-erp','.png']);
%close(k)
%% T����
HT = zeros(1,13);

for i = 1:13
        HT(i) = ttest2(epoch_sum(i,101:300),epoch_sum2(i,101:300));
end