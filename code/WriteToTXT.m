% 将matlab数据转换成txt，用于深度学习

clear;
clc;

load('D:\MATLAB\useful_data\eeg_data52.mat');
[width, height] = size(music_st);

%% 写入txt
count = 0;
for i = 1:width
    for j = 1:height
        data = music_st(i,j).music;
        valence = music_st(i,j).valence;
        
        if valence < 5
            str = '|labels 0 1 |features ';
        else
            str = '|labels 1 0 |features ';
        end
        
        for k = 1:30
            count = count + 1
            fp=fopen('A1.txt','a');
            fprintf(fp,str);
            for n = 1:52
                fprintf(fp,'%f ',data(n,((k-1)*1000+1):k*1000));
            end
            fprintf(fp,'\n');
            fclose(fp);
        end
        
    end
end