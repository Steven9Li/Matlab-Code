% �ļ���д

clear;
clc;

load('test_data1.mat');
fp=fopen('A.txt','a');%'A.txt'Ϊ�ļ�����'a'Ϊ�򿪷�ʽ���ڴ򿪵��ļ�ĩ��������ݣ����ļ��������򴴽���
fprintf(fp,'|labels ');
for i = 1:59
    fprintf(fp,'%f ',data(i,:));%fpΪ�ļ������ָ��Ҫд�����ݵ��ļ���ע�⣺%d���пո�
    fprintf(fp,'\n');
end
fclose(fp);%�ر��ļ���