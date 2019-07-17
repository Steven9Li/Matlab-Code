clear;
clc;

file_name = ['MUSIC_DATA\1.wav'];
a = miraudio(file_name,'Sampling',441000);
data = mirgetdata(a);

f = mirframe(a,0.025,'s',50,'%');
dataf = mirgetdata(f);
