% ¼ÆËãÆ½¾ù
clear;
clc;

load('D:\MyProjects\Matlab-Code\MATLAB\Data\bn31.mat');
load('D:\MyProjects\Matlab-Code\MATLAB\Data\class31.mat')

featureLength = length(bn(1,1).avg_degree);

for ii = 1:4 
    degree = zeros(1,featureLength);
    density = zeros(1,featureLength);
    cluster = zeros(1,featureLength);
    count = 0;
    for i = 1:31
        for j = 1:16
            if class(i,j) == ii
                degree = degree + bn(i,j).avg_degree;
                density = density + bn(i,j).density;
                cluster = cluster + bn(i,j).avg_cluster;
                % path = path + bn(i,j).path;
                count = count + 1;
            end
        end
    end

    avg(ii).degree = degree/count;
    avg(ii).density = density/count;
    avg(ii).cluster = cluster/count;
    % avg(ii).path = path/count;
end

figure(1)
for i = 1:4
    %plot(avg(i).path);
    avg(i).degreestd = std(avg(i).degree);
    avg(i).densitystd = std(avg(i).density);
    avg(i).clusterstd = std(avg(i).cluster);
%     avg(i).pathstd = std(avg(i).path);
    
    avg(i).degreeavg = mean(avg(i).degree);
    avg(i).densityavg = mean(avg(i).density);
    avg(i).clusteravg = mean(avg(i).cluster);
%     avg(i).pathavg = mean(avg(i).path);
    
    avg(i).degreet = avg(i).degree';
    avg(i).densityt = avg(i).density';
    avg(i).clustert = avg(i).cluster';
%     avg(i).patht = avg(i).path';
    %hold on
end
%legend('HVHA','LVHA','LVLA','HVLA');

%% »­Í¼

figure(1)
for i = 1:4
    subplot(3,1,1)
    plot(avg(i).degree);
    hold on
    
    box off;
    
    subplot(3,1,2)
    plot(avg(i).cluster);
    hold on
    
    box off;
end
h = legend('Happy','Distressed','Bored','Calm');
set(h, 'Box', 'off')
