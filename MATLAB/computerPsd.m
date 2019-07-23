clear;
clc;

% 计算脑电信号的功率谱密度

%% 预定义
Fs = 250;              %采样率
window = 250;           %窗长    
overlap = 125;           %窗移
nfft = 512;

load('D:\MyProjects\Matlab-Code\MATLAB\Data\music_data.mat')
[width, height] = size(music_data);
%% 通过pwelch计算功率谱密度

for i = 1:width
    for j = 1:height
        data = music_data{i,j};
        [len,limit] = size(data);
        times = 1;
        start = 1;
        while(true)
            start = 1 + 125*(times - 1);
            if start+249 > limit
                break;
            end
            for k = 1:len
                single_channal = data(k,start:start+249);
                [Pw, Fw] = pwelch(single_channal,hann(window),100*overlap/window,nfft,Fs);
                Pw_eo1(:,k,times) = Pw;
                Fw_eo1 = Fw;
            end
            times = times + 1;
        end

        psd(i,j).Pw_eo1 = Pw_eo1;
        psd(i,j).Fw_eo1 = Fw_eo1;      
       
    end
end