function res = FrameAcc(timeMatrix)
%FRAMEACC ֡�伯�ɺ���
%   �˴���ʾ��ϸ˵��

[p,m,t] = size(timeMatrix);
res = zeros(p,m);
times = 1:t;
f = exp(times/ceil(t/3));
for i = 1:t
    res = res + timeMatrix(:,:,i)*f(i);
end

end

