clear;
clc;

% �����Ե��źŵĹ������ܶ�

%% Ԥ����
Fs = 1000;              %������
window = 1000;           %����    
overlap = 500;           %����
nfft = 512;

load('D:\MATLAB\useful_data\eeg_data52.mat');
[width, height] = size(music_st);
%% ͨ��pwelch���㹦�����ܶ�

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