function [ degree, avg_degree ] = cmp_degree( numChannels,  BN_Matrix)
%CMP_DEGREE 计算脑网络的度
%   此处显示详细说明
    degree = zeros(1, numChannels);

    for i = 1:numChannels
        count = 0;
        for j = 1:numChannels
            if i == j
                continue;
            end
            if BN_Matrix(i,j)>0
                count = count + 1;
            end
        end
        degree(i) = count;
    end
    avg_degree = mean(degree);

end

