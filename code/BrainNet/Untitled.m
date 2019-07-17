clear;
clc;

load bn.mat;
load class.mat;
data1 = zeros(15*16,100);
data2 = zeros(15*16,100);
data3 = zeros(15*16,100);
data = zeros(15*16,300);
c = zeros(1,15*16);
for i = 1:15
    for j = 1:16
        %data((i-1)*16+j,:)=[bn(i,j).path,bn(i,j).avg_degree,bn(i,j).avg_cluster,class(i,j)];
        if class(i,j) == 1 || class(i,j) == 2
            str = '|labels 1 0 |features ';
        else
            str = '|labels 0 1 |features ';
        end
        fp=fopen('B.txt','a');
        fprintf(fp,str);
        for n = 1:100
            fprintf(fp,'%f ',bn(i,j).path(n));
        end
        fprintf(fp,'\n');
        fclose(fp);
    end
end
