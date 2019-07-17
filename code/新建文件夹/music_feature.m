clear;
clc;

max_length = 10;
musicNum = 16;

brightness = zeros(musicNum , 1);
zerocross = zeros(musicNum , 1);
flux = zeros(musicNum , 1);
rms = zeros(musicNum , 1);
length_of_data = zeros(musicNum, 1);

for i = 1:musicNum
    
    file_name = ['MUSIC_DATA/',num2str(i),'.wav'];
    a = miraudio(file_name);
    f = mirframe(a,0.025,0.5);
    
    mf = mirmfcc(f);
    b = mirgetdata(mf);
    length_of_data(i) = length(b);
    brightness(i,1:length_of_data(i)) = smooth(b(1,:));
    rms(i,1:length_of_data(i)) = smooth(b(2,:));
    zerocross(i,1:length_of_data(i)) = smooth(b(3,:));
    flux(i,1:length_of_data(i)) = smooth(b(4,:));

%     r = mirbrightness(f);
%     b = mirgetdata(r);
%     length_of_data(i) = length(b);
%     brightness(i,1:length_of_data(i)) = smooth(b);
%     
%     r = mirrms(f);
%     r = mirgetdata(r);
%     rms(i,1:length_of_data(i)) = smooth(r);
%     
%     r = mirzerocross(f);
%     z = mirgetdata(r);
%     zerocross(i,1:length_of_data(i)) = smooth(z);
%     
%     r = mirspectrum(f);
%     r = mirflux(r);
%     sf = mirgetdata(r);
%     flux(i,1:length(sf)) = smooth(sf);
    
end

save music_feature_MFCC brightness zerocross rms flux length_of_data musicNum;
