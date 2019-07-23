clear;
clc;

load ../useful_data/psd52_music.mat
load ../useful_data/psd52_music.mat
load bn.mat

for i = 1:52
    for j = 1:52
        
        valence = psd(i,j).valence;
        arousal = psd(i,j).arousal;
        
        if valence < 5 && arousal <= 5
            str = '|labels 1 0 0 0 |features ';
        elseif valence < 5 && arousal > 5
            str = '|labels 0 1 0 0 |features ';
        elseif valence >= 5 && arousal <= 5
            str = '|labels 0 0 1 0 |features ';
        else
            str = '|labels 0 0 0 1 |features ';
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