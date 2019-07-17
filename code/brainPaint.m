% »­ÄÔµØÐÎÍ¼
clear;
clc;

psds = load('useful_data\psd52_music.mat');
channel = load('useful_data\EEG_CHANNEL52.mat');

negative = [5,12,13,14,15];
positive = [6,7,8,10,11];
middle = [1,2,3,4,9,16];
all = 1:16;
num_subs = 15;
num_music = 16;
num_channels = 52;
psd = psds.psd;
name = {'delta','theta','alpha','beta','gamma'};

ret = positive;
chanlocs = channel.channel_st{1,1};

brain_m = zeros(num_channels,5);
brain_e = zeros(num_channels,5);
brain_change = zeros(num_channels,5);

for i = 1:num_subs
    for j = 1:num_music
        if any(ret==j) == 0
            continue;
        end
        for c = 1:num_channels
            stats_m = stat(psd(i,j).Fw_music(:,c), psd(i,j).Pw_music(:,c));
            stats_e = stat(psd(i,j).Fw_eo1(:,c),psd(i,j).Pw_eo1(:,c));

            for k = 1:5
                brain_m(c,k) = brain_m(c,k) + stats_m(2,k);
                brain_e(c,k) = brain_e(c,k) + stats_e(2,k);
            end
        end
    end
end

ret2 = negative;

brain_m2 = zeros(num_channels,5);
brain_e2 = zeros(num_channels,5);
brain_change2 = zeros(num_channels,5);

for i = 1:num_subs
    for j = 1:num_music
        if any(ret2==j) == 0
            continue;
        end
        for c = 1:num_channels
            stats_m = stat(psd(i,j).Fw_music(:,c), psd(i,j).Pw_music(:,c));
            stats_e = stat(psd(i,j).Fw_eo1(:,c),psd(i,j).Pw_eo1(:,c));

            for k = 1:5
                brain_m2(c,k) = brain_m2(c,k) + stats_m(2,k);
                brain_e2(c,k) = brain_e2(c,k) + stats_e(2,k);
            end
        end
    end
end

figure(1)
hi = 0.5;
lo = -0.5;

for ii = 1:5
    bm = brain_m(:,ii);
    be = brain_e(:,ii);
    bp = (bm - be)./be;
    
    bm2 = brain_m2(:,ii);
    be2 = brain_e2(:,ii);
    bp2 = (bm2 - be2)./be2;
    
    bpc = (bp - bp2);
    subplot(2,3,ii);
    topoplot(bp(1:52), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'whitebk','on','maplimits',[lo,hi],'conv','on');
    title(name{1,ii},'FontSize',30);
    cbar('vert');
end




