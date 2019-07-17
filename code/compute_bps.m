clear;
clc;

% 计算功率谱密度
% load('current_data\EEG_EPOCH_O.mat');

% typelocationData = 'D:\MATLAB_WorkSpace\EEG_DATA_F';
% EEG = pop_loadset('filename','1_f.set','filepath',typelocationData);
load('useful_data\channel.mat');
load('useful_data\avgs_all2.mat');
Fs = 100;
window = 20;
overlap = 10;
h = spectrum.welch('Hann',window,100*overlap/window);
nfft = 64;
channel_len = 62;
%destpath = fullfile(pwd,'feature');
data = avgs_all.brightness;

for j=1:channel_len
    % rest base line
    y_b = data(j,1:500);
    y_b = resample(y_b,100,1000);
    hpsd_b = psd(h,y_b,'NFFT',nfft,'Fs',Fs);
    Pw_b = hpsd_b.Data;
    Fw_b = hpsd_b.Frequencies;
    stats_b = stat(Fw_b, Pw_b);

    % music seg
    y = data(j,501:1000);
    y = resample(y,100,1000);
    hpsd = psd(h,y,'NFFT',nfft,'Fs',Fs);
    Pw = hpsd.Data;
    Fw = hpsd.Frequencies;
    stats_m = stat(Fw, Pw);

    bandpower_delta(j) = (stats_m(2,1) - stats_b(2,1))/stats_b(2,1);
    bandpower_theta(j) = (stats_m(2,2) - stats_b(2,2))/stats_b(2,2);
    bandpower_alpha(j) = (stats_m(2,3) - stats_b(2,3))/stats_b(2,3);
    bandpower_beta(j)  = (stats_m(2,4) - stats_b(2,4))/stats_b(2,4);
    bandpower_gamma(j) = (stats_m(2,5) - stats_b(2,5))/stats_b(2,5);
%     bandpower_delta(j) = stats_m(2,1);
%     bandpower_theta(j) = stats_m(2,2);
%     bandpower_alpha(j) = stats_m(2,3);
%     bandpower_beta(j)  = stats_m(2,4);
%     bandpower_gamma(j) = stats_m(2,5);
end % end of for channel

%chanlocs = EEG.chanlocs;


figure(1)
bp = bandpower_alpha;
subplot(3,2,1);
% topoplot( bp(1:64), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'maplimits',[minm,maxm]);
topoplot( bp(1:62), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63);
title('alpha');
cbar('vert');

bp = bandpower_beta;
subplot(3,2,2);
topoplot( bp(1:62), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63);
title('beta');
cbar('vert');

bp = bandpower_gamma;
subplot(3,2,3);
topoplot( bp(1:62), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63);
title('gammma');
cbar('vert');

bp = bandpower_delta;
subplot(3,2,4);
topoplot( bp(1:62), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63);
title('delta');
cbar('vert');

bp = bandpower_theta;
subplot(3,2,5);
topoplot( bp(1:62), chanlocs, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63);
title('theta');
cbar('vert');
