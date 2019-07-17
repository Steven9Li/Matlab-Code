% ·ÖÀà
clear;
clc;

load ../useful_data/psd52_music.mat
load bn.mat
label = zeros(1*16,1);
count = 1;
for i = 1:15
    for j = 1:16
        if psd(i,j).valence < 5
            label(count) = -1;
        elseif psd(i,j).valence <= 5
            label(count) = 1;
        else
            label(count) = 1;
        end
        data(count,1) = mean(bn(i,j).avg_degree);
        data(count,2) = mean(bn(i,j).density);
        data(count,3) = mean(bn(i,j).avg_cluster);
        count = count + 1;
    end
end

