function [P1, F] = Frequency(data, Fs, nfft)
% 时域转换为频域
% data 一维信号数据，1*N
% Fs 采样率
% nfft傅里叶变换的点数

Y = fft(data, nfft);
P2 = abs(Y/nfft);
P1 = P2(1:nfft/2+1);
P1(2:end-1) = 2*P1(2:end-1);
F = Fs*(0:(nfft/2))/nfft;