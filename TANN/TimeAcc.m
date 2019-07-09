function res = TimeAcc(featureMatrix,start,interval)
% TIMEACC 时间集成函数
% 时间：20190709 16：39
% 效果：将特征矩阵转成特征序列
% 输入参数：
% *featureMatrix：特征矩阵，p*t，p维特征，t代表时间
% *M: 时延段,固定值,高斯函数的组数,取7，暂不适用
% *n: 卷积点的数目,默认为3
% *start: 起点, 以帧为单位
% *interval：间隔, 以帧为单位
% 返回值
% *res：p*m*t
[p,t] = size(featureMatrix);

M = ceil(start/2);
times = ceil((t-start)/interval);
res = zeros(p,M,times);
for i = 1:times
    data = featureMatrix(:,1+(i-1)*interval:start+(i-1)*interval+1);

%     M = ceil(start/2);
    x = [1,2,3];
    y = Gauss1D(x,2,1);
    index = 1;
    for j = 2:2:start
        res(:,index,i) = data(:,j-1)*y(1) + data(:,j)*y(2) + data(:,j+1)*y(3);
        index = index + 1;
    end
    
end

