function [ density ] = cmp_density( numChannels,  BN_Matrix)
%CMP_DEGREE 此处显示有关此函数的摘要
%   此处显示详细说明
    [chanPairs(:, 1) chanPairs(:, 2)] = ind2sub(size(BN_Matrix), find(BN_Matrix));
    length = size(chanPairs);
    density = length(1) / (numChannels*(numChannels-1)/2);
end

