function color = MapToColorDec(mc)
% 将传进来的colormap转为十进制形式
% mc：n*3的二维矩阵，要求值在0~255之间

[x,y] = size(mc);
color = zeros(x,1);
if y ~= 3
    disp('输入矩阵列数不符合要求');
    return
end

for i = 1:x*y
    if mc(i) > 255
        mc(i) = 255;
    end
    if mc(i) < 0
        mc(i) = 0;
    end
end

for i = 1:x
    r = dec2hex(mc(i,1));
    g = dec2hex(mc(i,2));
    b = dec2hex(mc(i,3));
    
    rgbHex = [r,g,b];
    color(i) = hex2dec(rgbHex);
end