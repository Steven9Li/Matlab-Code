clear;
clc;

% 计算脑电信号的功率谱密度

%% 预定义
Fs = 1000;              %采样率
window = 1000;           %窗长    
overlap = 500;           %窗移
nfft = 512;

load('D:\MATLAB\useful_data\eeg_data52.mat');
[width, height] = size(music_st);
%% 通过pwelch计算功率谱密度

for i = 1:width
    for j = 1:height
        data = music_st(i,j).eo1;
        [len,~] = size(data);
        for k = 1:len
            single_channal = data(k,:);
            [Pw, Fw] = pwelch(single_channal,hann(window),100*overlap/window,nfft,Fs);
            Pw_eo1(:,k) = Pw;
            Fw_eo1(:,k) = Fw;
        end
        psd(i,j).valence = music_st(i,j).valence;
        psd(i,j).arousal = music_st(i,j).arousal;
        psd(i,j).Pw_eo1 = Pw_eo1;
        psd(i,j).Fw_eo1 = Fw_eo1;
        
        data = music_st(i,j).music;
        [len,~] = size(data);
        for k = 1:len
            single_channal = data(k,:);
            [Pw, Fw] = pwelch(single_channal,hann(window),100*overlap/window,nfft,Fs);
            Pw_eo1(:,k) = Pw;
            Fw_eo1(:,k) = Fw;
        end
        psd(i,j).Pw_music = Pw_eo1;
        psd(i,j).Fw_music = Fw_eo1;
        
        data = music_st(i,j).eo2;
        [len,~] = size(data);
        for k = 1:len
            single_channal = data(k,:);
            [Pw, Fw] = pwelch(single_channal,hann(window),100*overlap/window,nfft,Fs);
            Pw_eo1(:,k) = Pw;
            Fw_eo1(:,k) = Fw;
        end
        psd(i,j).Pw_eo2 = Pw_eo1;
        psd(i,j).Fw_eo2 = Fw_eo1;
    end
end