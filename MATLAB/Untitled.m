clc;clear;

data = miraudio('3-2.wav');
music_data1 = mirgetdata(data);
data = miraudio('32.wav');
music_data2 = mirgetdata(data);
data = miraudio('1032.wav');
music_data3 = mirgetdata(data);
data = miraudio('3210.wav');
music_data4 = mirgetdata(data);

% ������ͼ����
Nh = 2;             % ����
Nw = 2;             % ����
gap = [0.16 0.08];    % ͼ��߽�
marg_h = 0.1;       % ȫ����ͼ��figure���±߽�ľ���
marg_w = 0.1;       % ȫ����ͼ��figure���ұ߽�ľ���
marg_w = [marg_w marg_w];
marg_h = [marg_h marg_h];
axh = (1-sum(marg_h)-(Nh-1)*gap(1))/Nh; 
axw = (1-sum(marg_w)-(Nw-1)*gap(2))/Nw;
py_o = 1-marg_h(2)-axh;
px_o = marg_w(1);

figure(1)
set(gcf,'position',[274,42,1000,500])
px = px_o+(axw+gap(2))*(1-1);
py = py_o-(axh+gap(1))*(1-1);
axes('Units','normalized', ...
                'Position',[px py axw axh], ...
                'XTickLabel','', ...
                'YTickLabel','');

specgram(music_data1,1024,44100,512,256);
xlabel('time(s)')
ylabel('frequency(Hz)')
axis([0.02 1 0 10000])
title('Three two')
caxis([-100,25])
box off

px = px_o+(axw+gap(2))*(1-1);
py = py_o-(axh+gap(1))*(2-1);
axes('Units','normalized', ...
                'Position',[px py axw axh], ...
                'XTickLabel','', ...
                'YTickLabel','');
%set(gcf,'position',[274,42,600,300])
specgram(music_data2,1024,44100,512,256);
xlabel('time(s)')
ylabel('frequency(Hz)')
axis([0.02 1 0 10000])
title('Thirty two')
caxis([-100,25])
box off


px = px_o+(axw+gap(2))*(2-1);
py = py_o-(axh+gap(1))*(1-1);
axes('Units','normalized', ...
                'Position',[px py axw axh], ...
                'XTickLabel','', ...
                'YTickLabel','');
%set(gcf,'position',[274,42,600,300])
specgram(music_data3,1024,44100,512,256);
xlabel('time(s)')
ylabel('frequency(Hz)')
axis([0.02 1 0 10000])
title('ten three two')
caxis([-100,25])
box off


px = px_o+(axw+gap(2))*(2-1);
py = py_o-(axh+gap(1))*(2-1);
axes('Units','normalized', ...
                'Position',[px py axw axh], ...
                'XTickLabel','', ...
                'YTickLabel','');
%set(gcf,'position',[274,42,600,300])
specgram(music_data4,1024,44100,512,256);
xlabel('time(s)')
ylabel('frequency(Hz)')
axis([0.02 1 0 10000])
title('Three two ten')
caxis([-100,25])
box off

axes('position', [0.8, 0.1, 0.2, 0.6]);
axis off;
colorbar
caxis([-50,50])