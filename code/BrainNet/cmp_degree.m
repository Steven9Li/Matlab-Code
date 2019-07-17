function [ degree, avg_degree ] = cmp_degree( numChannels,  BN_Matrix)
%CMP_DEGREE ����������Ķ�
%   �˴���ʾ��ϸ˵��
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

