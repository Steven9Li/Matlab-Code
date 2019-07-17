clear;
clc;

fid = fopen('1.txt','w');
data = ones(10,12);
fprintf(fid, '%f', data);