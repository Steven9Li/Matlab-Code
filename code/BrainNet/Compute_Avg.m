% ¼ÆËãÆ½¾ù
clear;
clc;

load bn.mat;
load class.mat;
load path.mat;
for ii = 1:4
    degree = zeros(1,100);
    density = zeros(1,100);
    cluster = zeros(1,100);
    path = zeros(1,100);
    count = 0;
    for i = 1:15
        for j = 1:16
            if class(i,j) == ii
                degree = degree + bn(i,j).avg_degree;
                density = density + bn(i,j).density;
                cluster = cluster + bn(i,j).avg_cluster;
                path = path + bn(i,j).path;
                count = count + 1;
            end
        end
    end

    avg(ii).degree = degree/count;
    avg(ii).density = density/count;
    avg(ii).cluster = cluster/count;
    avg(ii).path = path/count;
end

figure(1)
for i = 1:4
    plot(avg(i).path);
    avg(i).degreestd = std(avg(i).degree);
    avg(i).densitystd = std(avg(i).density);
    avg(i).clusterstd = std(avg(i).cluster);
    avg(i).pathstd = std(avg(i).path);
    
    avg(i).degreeavg = mean(avg(i).degree);
    avg(i).densityavg = mean(avg(i).density);
    avg(i).clusteravg = mean(avg(i).cluster);
    avg(i).pathavg = mean(avg(i).path);
    
    avg(i).degreet = avg(i).degree';
    avg(i).densityt = avg(i).density';
    avg(i).clustert = avg(i).cluster';
    avg(i).patht = avg(i).path';
    hold on
end
legend('HVHA','LVHA','LVLA','HVLA');