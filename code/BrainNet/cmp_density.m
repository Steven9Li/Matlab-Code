function [ density ] = cmp_density( numChannels,  BN_Matrix)
%CMP_DEGREE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [chanPairs(:, 1) chanPairs(:, 2)] = ind2sub(size(BN_Matrix), find(BN_Matrix));
    length = size(chanPairs);
    density = length(1) / (numChannels*(numChannels-1)/2);
end

