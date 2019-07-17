clear;
clc;

file1 = 'data_preprocessed_matlab';
file = 'deap_mat_40';
Fs = 512;              %采样率
window = 512;           %窗长    
overlap = 256;           %窗移
nfft = 512;


for i = 1:32
    if i < 10
        filename1 = [file1,'\s0' ,num2str(i),'.mat'];
        filename = [file,'\s0' ,num2str(i),'.mat'];
    else
        filename1 = [file1,'\s' ,num2str(i),'.mat'];
        filename = [file,'\s' ,num2str(i),'.mat'];
    end
    load(filename1);
    load(filename);
    for j = 1:40
        dy = squeeze(data(j,:,:));
        for k = 1:32
            single_channal = dy(k,(5*Fs+1):length(dy));
            [Pw, Fw] = pwelch(single_channal,hann(window),100*overlap/window,nfft,Fs);
            Pw_eo(:,k) = Pw;
            Fw_eo(:,k) = Fw;
        end
        psd(i,j).Pw_music = Pw_eo;
        psd(i,j).Fw_music = Fw_eo;
        psd(i,j).valence = labels(j,1);
        psd(i,j).arousal = labels(j,2);
    end
        
end
