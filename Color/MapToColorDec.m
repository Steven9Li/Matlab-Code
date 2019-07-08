function color = MapToColorDec(mc)
% ����������colormapתΪʮ������ʽ
% mc��n*3�Ķ�ά����Ҫ��ֵ��0~255֮��

[x,y] = size(mc);
color = zeros(x,1);
if y ~= 3
    disp('�����������������Ҫ��');
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