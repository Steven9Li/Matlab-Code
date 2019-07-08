% matlab ��д�������ļ�

clear;
clc;

filename = 'test.bin';
chanName = load('chanlocs.mat');
colors = load('colors.mat');
fid = fopen(filename,'wb');

%��д�¿�ֵ
fwrite(fid,0,'int');    %Createtime
fwrite(fid,0,'int');    %Axcount
fwrite(fid,0,'int');    %Axstart
fwrite(fid,0,'int');    %Datastart
fwrite(fid,0,'int');    %Width
fwrite(fid,0,'int');    %Height
fwrite(fid,4,'int');    %Rate 1���ش���4ms

Axstart = ftell(fid);   %�̶���ʼ��ַ

%������10���̶�
Axcount = 62;

for n = 1:Axcount
	fwrite(fid,n,'int');                    %index
    
	charNum = fwrite(fid,chanName.chanlocs(n).labels,'char*1');       %�̶�����
    if charNum < 20
        blankChar = char(20 - charNum);
        fwrite(fid,blankChar,'char*1');
    end      
    % disp(charNum);
	fwrite(fid,Axcount + n*10,'int');        %�̶�����
end


width = 10000;
height = 620;
Datastart = ftell(fid);%������ʼλ��
data = zeros(height,width);

for i = 1:width
    data(:,i) = mod(floor(i/100),64);
end

for x=1:width
	for y=1:height
        c = colors.color(data(y,x)+1);
		fwrite(fid,c,'int');	%д����ɫֵ
	end
end

fseek(fid, 0, 'bof'); %��ת��ͷ��

%��ʼдͷ������
fwrite(fid,0,'int');%Createtime
fwrite(fid, Axcount,'int');%Axcount
fwrite(fid, Axstart, 'int');%Axstart
fwrite(fid,Datastart,'int');%Datastart
fwrite(fid,width, 'int');%Width
fwrite(fid,height, 'int');%Height
fwrite(fid,4,'int');%Rate 1���ش���4ms

fclose(fid);