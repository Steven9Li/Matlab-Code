function [ cluster, avg_cluster ] = cmp_cluster( numChannels,  BN_Matrix)
%CMP_DEGREE 此处显示有关此函数的摘要
%   此处显示详细说明
    cluster = zeros(1, numChannels);

    for i = 1:numChannels
        count = 0;
        vector = zeros(1, numChannels);
        for j = 1:numChannels
            if i == j
                continue;
            end
            if BN_Matrix(i,j)>0
                count = count + 1;
                vector(count) = j;
            end
        end
        Ei = 0;
        for ii = 1:count
            for jj = 1:count
                if ii == jj
                    continue;
                end;
                if BN_Matrix(vector(ii),vector(jj))>0 || BN_Matrix(vector(jj),vector(ii))>0
                    Ei = Ei + 1;
                end
            end
        end
        if count == 0 || count == 1
            cluster(i) = 0;
        else
            cluster(i) = Ei/(count*(count-1));
        end
    end
    avg_cluster = mean(cluster);
end

