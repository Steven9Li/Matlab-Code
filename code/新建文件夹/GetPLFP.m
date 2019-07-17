function res = GetPLFP( music_st , time )

    t = time;
    res = music_st.music(:,t-500:t+1000);
    [x,y] = size(res);
    for i = 1:x
        tmp = mean(res(i,1:501));
        res(i,:) = res(i,:) - tmp;  
    end
end

