% »­ÄÔµØÐÎÍ¼
clear;
clc;

load('D:\MyProjects\Matlab-Code\MATLAB\Data\eo1_psd.mat');
load('D:\MyProjects\Matlab-Code\MATLAB\Data\music_psd.mat');
load('D:\MyProjects\Matlab-Code\MATLAB\Data\standard_channal.mat');

e1 = [1,2,3,4];
e2 = [9,16];
e3 = [5,12,13,14,15];
e4 = [6,7,8];

num_subs = 31;
num_music = 16;
num_channels = 62;
name = {'delta','theta','alpha','beta','gamma'};
ret = e3;

brain_m = zeros(num_channels,5);
brain_e = zeros(num_channels,5);
brain_change = zeros(num_channels,5);

for i = 1:num_subs
    for j = 1:num_music
        if any(ret==j) == 0
            continue;
        end
        for c = 1:num_channels
            stats_m = stat(music_psd(i,j).Fw_eo1(:,c), music_psd(i,j).Pw_eo1(:,c));
            stats_e = stat(eo1_psd(i,j).Fw_eo1(:,c), eo1_psd(i,j).Pw_eo1(:,c));

            for k = 1:5
                brain_m(c,k) = brain_m(c,k) + stats_m(2,k);
                brain_e(c,k) = brain_e(c,k) + stats_e(2,k);
            end
        end
    end
end


figure(1)
hi = 0.5;
lo = -0.5;
el = length(ret);
for ii = 1:5
    bm = log(brain_m(:,ii));
    be = log(brain_e(:,ii));
    bp = (bm - be)./(be-log(el*num_subs));
    % bp = rand(1,62)-0.5;
    subplot(2,3,ii);
    topoplot(bp, standard_channal, 'electrodes','off','conv','on','whitebk','on','style','map','plotrad',0.7,'headrad',0.63,'whitebk','on','maplimits',[lo,hi],'conv','on');
    title(name{1,ii},'FontSize',30);
    cbar('vert');
end




