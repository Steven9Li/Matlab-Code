function res = TimeAcc(featureMatrix,start,interval)
% TIMEACC ʱ�伯�ɺ���
% ʱ�䣺20190709 16��39
% Ч��������������ת����������
% ���������
% *featureMatrix����������p*t��pά������t����ʱ��
% *M: ʱ�Ӷ�,�̶�ֵ,��˹����������,ȡ7���ݲ�����
% *n: ��������Ŀ,Ĭ��Ϊ3
% *start: ���, ��֡Ϊ��λ
% *interval�����, ��֡Ϊ��λ
% ����ֵ
% *res��p*m*t
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

