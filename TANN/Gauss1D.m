function res = Gauss1D(x, mu, sigma)
%GAUSS1D 计算一维高斯函数
%   此处显示详细说明
    a = 1/(sigma*sqrt(2*pi));
    b = -1*(x-mu).^2/(2*sigma^2);
    
    res = a*exp(b);
end

