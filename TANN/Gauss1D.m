function res = Gauss1D(x, mu, sigma)
%GAUSS1D ����һά��˹����
%   �˴���ʾ��ϸ˵��
    a = 1/(sigma*sqrt(2*pi));
    b = -1*(x-mu).^2/(2*sigma^2);
    
    res = a*exp(b);
end

