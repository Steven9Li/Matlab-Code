% 文件读写

clear;
clc;

load('test_data1.mat');
fp=fopen('A.txt','a');%'A.txt'为文件名；'a'为打开方式：在打开的文件末端添加数据，若文件不存在则创建。
fprintf(fp,'|labels ');
for i = 1:59
    fprintf(fp,'%f ',data(i,:));%fp为文件句柄，指定要写入数据的文件。注意：%d后有空格。
    fprintf(fp,'\n');
end
fclose(fp);%关闭文件。