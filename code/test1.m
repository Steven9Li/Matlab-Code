clear;
clc;

% ����pwelch��ɰ溯��

%% ����׼��

load('test_data.mat');
Fs = 250;              %������
window = 1000;           %����    
overlap = 500;           %����
nfft = 512;

%% �ɰ溯��
h = spectrum.welch('Hamming',window,100*overlap/window);
y_a = test_data;
hpsd_a = psd(h,y_a,'NFFT',nfft,'Fs',Fs);
Pw_a = hpsd_a.Data;
Fw_a = hpsd_a.Frequencies;

%% �°溯��
y_b = test_data;
[Pw_b, Fw_b] = pwelch(y_b,hamming(window),100*overlap/window,nfft,Fs);

%% �Ƚ����ֺ���ֵ�Ĳ���
countF = [];
countP = 0;
for i = 1:length(Pw_a)
    if Pw_a(i) - Pw_b(i)  ~= 0
        countP(i) = Pw_a(i) - Pw_b(i);
    end
end

for i = 1:length(Fw_a)
    if Fw_a(i) - Fw_b(i)  ~= 0
        countF = countF + 1;
    end
end

[Pxy,F] = cpsd(test_data,test_data,hamming(window),100*overlap/window,nfft,Fs);

