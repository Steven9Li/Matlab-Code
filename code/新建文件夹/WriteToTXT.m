clear;
clc;

file1 = 'data_preprocessed_matlab';
file = 'deap_mat_40';
Fs = 512;              %采样率
window = 512;           %窗长    
overlap = 256;           %窗移
nfft = 512;

count = 0;
for i = 1:32
    if i < 10
        filename1 = [file1,'\s0' ,num2str(i),'.mat'];
        filename = [file,'\s0' ,num2str(i),'.mat'];
    else
        filename1 = [file1,'\s' ,num2str(i),'.mat'];
        filename = [file,'\s' ,num2str(i),'.mat'];
    end
    load(filename1);
    load(filename);
    for j = 1:40
        valence = labels(j,1);
        if valence < 5
            str = '|labels 0 1 |features ';
        else
            str = '|labels 1 0 |features ';
        end
        for k = 1:60
            count = count + 1
            fp=fopen('B.txt','a');
            fprintf(fp,str);
            for n = 1:32
                start = ((k+2)*512+1);
                stop = (k+3)*512;
                fprintf(fp,'%f ',data(n,start:stop));
            end
            fprintf(fp,'\n');
            fclose(fp);
        end
    end
        
end
