function [P1, F] = Frequency(data, Fs, nfft)
% ʱ��ת��ΪƵ��
% data һά�ź����ݣ�1*N
% Fs ������
% nfft����Ҷ�任�ĵ���

Y = fft(data, nfft);
P2 = abs(Y/nfft);
P1 = P2(1:nfft/2+1);
P1(2:end-1) = 2*P1(2:end-1);
F = Fs*(0:(nfft/2))/nfft;