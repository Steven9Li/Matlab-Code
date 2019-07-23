function [stats, pos_1hz, pos_100hz] = stat(fn, data)
% stats -- row1 count
%       -- row2 sum
%       -- row3 max Y's X position(fn)
%       -- row4 max Y 
%       -- row5 = row2/row1 
stats = zeros(5,5);
pos_1hz = 0;
pos_100hz = size(fn,1);
for j=1:size(fn,1)
    Yj = data(j);
    if  fn(j)>100
        pos_100hz = j-1;
        break;
    elseif fn(j)>=31 && fn(j)<=49
        stats(1,5) = stats(1,5)+1;
        stats(2,5) = stats(2,5)+Yj;
        if Yj > stats(4,5)
            stats(3,5) = fn(j);
            stats(4,5) = Yj;
        end
    elseif fn(j)>=13 && fn(j)<=30
        stats(1,4) = stats(1,4)+1;
        stats(2,4) = stats(2,4)+Yj;
        if Yj > stats(4,4)
            stats(3,4) = fn(j);
            stats(4,4) = Yj;
        end
    elseif fn(j)>=8 && fn(j)<=13
        stats(1,3) = stats(1,3)+1;
        stats(2,3) = stats(2,3)+Yj;
        if Yj > stats(4,3)
            stats(3,3) = fn(j);
            stats(4,3) = Yj;
        end
    elseif fn(j)>=4 && fn(j)<=7
        stats(1,2) = stats(1,2)+1;
        stats(2,2) = stats(2,2)+Yj;
        if Yj > stats(4,2)
            stats(3,2) = fn(j);
            stats(4,2) = Yj;
        end
    elseif fn(j)>=1 && fn(j)<=3
        stats(1,1) = stats(1,1)+1;
        stats(2,1) = stats(2,1)+Yj;
        if Yj > stats(4,1)
            stats(3,1) = fn(j);
            stats(4,1) = Yj;
        end
        if  pos_1hz == 0
            pos_1hz = j;
        end
    end
end

for j=1:5
    stats(5,j) = stats(2,j)/stats(1,j);
end