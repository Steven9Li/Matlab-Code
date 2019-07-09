function res = FrameAcc(timeMatrix)
%FRAMEACC 帧间集成函数
%   此处显示详细说明

[p,m,t] = size(timeMatrix);
res = zeros(p,m);
times = 1:t;
f = exp(times/ceil(t/3));
for i = 1:t
    res = res + timeMatrix(:,:,i)*f(i);
end

end

