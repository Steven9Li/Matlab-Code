% matlab 读写二进制文件

clear;
clc;

filename = 'test.bin';
chanName = load('chanlocs.mat');
colors = load('colors.mat');
fid = fopen(filename,'wb');

%先写下空值
fwrite(fid,0,'int');    %Createtime
fwrite(fid,0,'int');    %Axcount
fwrite(fid,0,'int');    %Axstart
fwrite(fid,0,'int');    %Datastart
fwrite(fid,0,'int');    %Width
fwrite(fid,0,'int');    %Height
fwrite(fid,4,'int');    %Rate 1像素代表4ms

Axstart = ftell(fid);   %刻度起始地址

%假设有10个刻度
Axcount = 62;

for n = 1:Axcount
	fwrite(fid,n,'int');                    %index
    
	charNum = fwrite(fid,chanName.chanlocs(n).labels,'char*1');       %刻度名称
    if charNum < 20
        blankChar = char(20 - charNum);
        fwrite(fid,blankChar,'char*1');
    end      
    % disp(charNum);
	fwrite(fid,Axcount + n*10,'int');        %刻度坐标
end


width = 10000;
height = 620;
Datastart = ftell(fid);%数据起始位置
data = zeros(height,width);

for i = 1:width
    data(:,i) = mod(floor(i/100),64);
end

for x=1:width
	for y=1:height
        c = colors.color(data(y,x)+1);
		fwrite(fid,c,'int');	%写入颜色值
	end
end

fseek(fid, 0, 'bof'); %跳转回头部

%开始写头部数据
fwrite(fid,0,'int');%Createtime
fwrite(fid, Axcount,'int');%Axcount
fwrite(fid, Axstart, 'int');%Axstart
fwrite(fid,Datastart,'int');%Datastart
fwrite(fid,width, 'int');%Width
fwrite(fid,height, 'int');%Height
fwrite(fid,4,'int');%Rate 1像素代表4ms

fclose(fid);