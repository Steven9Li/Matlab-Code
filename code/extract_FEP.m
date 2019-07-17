clear;
clc;

%������Ƶ�����ļ�
music = load('./useful_data/music_feature.mat');

%�¼�����Ŀ����Ƶ��Ŀ
num_Event_Point = 100;
num_music = 16;

%nEP���е��¼��㣬eEP�����������¼���
nEP_flux = zeros(num_music,num_Event_Point);
eEP_flux = zeros(num_music,num_Event_Point);

%��ֵ����
count = 0;
Nstep = 80;
percenth = 1.3;
percentl = 0.8;


for k = 1:4
    if k == 1
        flux = music.brightness;
    elseif k == 2
        flux = music.flux;
    elseif k == 3
        flux = music.rms;
    elseif k == 4
        flux = music.zerocross;
    end
    flux_d = diff(flux')';

    %��ֵ�˲�
    % flux_d_a = smooth(flux_d);
    % flux_d = flux_d_a;
    % for j = 3 : length(flux_d_a) - 2
    %     flux_d(j) = median(flux_d_a(j-2 : j+2));
    % end
    % flux_d = abs(flux_d);

    %ԭʼ�����ź������źŶ���
    flux = flux(:,2:length(flux));

    
    for i = 1 : num_music

    index = 1;
    for j =40  : music.length_of_data(i)-2
        %��̬��ֵȡֵ��Χ
        if j>40 && j+40<music.length_of_data(i)-1
            start = j-40;
            stop = j+40;
        elseif j>40
            tmp = length(flux) - j;
            start = j-40-tmp;
            stop = length(flux);
        else
            tmp = 40-j;
            start = 1;
            stop = j+40+tmp;
        end
        %ȡ��̬���ľ�ֵ
        aver = mean(flux(i, start:stop));
        aver_d = mean(flux_d(i, start:stop));

        higher_threshold = percenth*aver;
        lower_threshold = percentl*aver;
        higher_threshold_d = percenth*aver_d;
        lower_threshold_d = percentl*aver_d;

        if flux(i, j)>higher_threshold && flux_d(i, j)>higher_threshold_d
            nEP_flux(i, index) = j;
            index = index + 1;
        end    
    end
    end

       
    if k == 1
        fp.brightness = eEP_flux;
    elseif k == 2
        fp.flux = eEP_flux;
    elseif k == 3
        fp.rms = eEP_flux;
    elseif k == 4
        fp.zerocross = eEP_flux;
    end
end
