clear;
clc;

file_name = ['D:/MATLAB_WorkSpace/MUSIC_DATA/1.wav'];
a = miraudio(file_name,'Sampling',1000);
data = mirgetdata(a);
data = data(1:5000);

b = miraudio(data,1000);
datab = mirgetdata(b);

f = mirframe(b,0.5,'s',50,'%');
dataf = mirgetdata(f);

s = mirspectrum(f);
datas = mirgetdata(s);

ff = dataf(:,1);
fs = fft2(ff);
fd = datas(:,1);