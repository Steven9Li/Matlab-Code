% matlab ��д�������ļ�

clear;
clc;

filename = 'test.bin';
chanName = load('chanlocs.mat');
colors = load('colors.mat');
fid = fopen(filename,'wb');

color_end = 16711680;

%��д�¿�ֵ
fwrite(fid,0,'int');    %Createtime
fwrite(fid,0,'int');    %Axcount
fwrite(fid,0,'int');    %Axstart
fwrite(fid,0,'int');    %Datastart
fwrite(fid,0,'int');    %Width
fwrite(fid,0,'int');    %Height
fwrite(fid,100,'int');    %Rate 1���ش���4ms

Axstart = ftell(fid);   %�̶���ʼ��ַ

%������10���̶�
Axcount = 62;
disp(Axstart);
for n = 1:Axcount
	fwrite(fid,n,'int');                    %index
	charNum = fwrite(fid,chanName.chanlocs(n).labels,'char');       %�̶�����
    if charNum < 20
        blankChar = 20 - charNum;
        for i = 1:blankChar
            a = fwrite(fid,0,'char');
        end
    end
%     fwrite(fid,255,'uchar');
	fwrite(fid, n*10,'int');        %�̶�����

end


width = 2536;
height = 620;
Datastart = ftell(fid);%������ʼλ��
data = zeros(height,width);

for i = 1:width
    data(:,i) = mod(floor(i/50),64);
end

for x=1:width
	for y=1:height
        if x ~= width
            c = colors.color(data(y,x)+1);
        else
            c = color_end;
        end
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
fwrite(fid,100,'int');%Rate 1���ش���4ms

fclose(fid);