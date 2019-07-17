clear;
clc;

% music = load('./useful_data/music_feature.mat');
music = load('music_feature_MFCC.mat');
PLFP_rms = zeros(music.musicNum, 20);
PLFP_zero = zeros(music.musicNum, 20);
PLFP_flux = zeros(music.musicNum, 20);
PLFP_brightness = zeros(music.musicNum, 20);

count = 0;
Nstep = 80;
minnum = 20;
percenth = 0.8;
percentl = 0.8;

for i = 1 : music.musicNum
    
    flux = music.flux(i,:);
    flux_d = zeros(size(flux));
    flux_d(2:length(flux)) = diff(flux);
    flux_d_a = flux_d;
    
    flux_d = flux_d_a;
    for j = 3 : length(flux) - 2
        flux_d(j) = median(flux_d_a(j-2 : j+2));
    end

    flux_d = abs(flux_d);

    count_t = 0;
    index = 1;
    flag = 0;
    count_f = 0;
    for j =40  : length(flux) - Nstep
        if flag == 1
            count_f = count_f + 1;
            if count_f >= 80
                flag = 0;
                count_f = 0;
            end
            continue;
        end
        aver = mean(flux_d(j:j+Nstep-1));
        maxd = max(flux_d(j:j+Nstep-1));
        mind = min(flux_d(j:j+Nstep-1));
        higher_threshold = aver + (maxd - aver)*percenth;
        lower_threshold = aver - (aver - mind)*percentl;
        
        if flux_d(j) <= lower_threshold
            count_t = count_t+1;
        
        elseif flux_d(j) >= higher_threshold
            if count_t >= minnum
                PLFP_flux(i,index) = j;
                index = index + 1;
                count_t = 0;
                count = count + 1;
            end
            
        else
            count_t = 0;
        end
            
    end
end

for i = 1 : music.musicNum
    
    flux = music.zerocross(i,:);
    flux_d = zeros(size(flux));
    flux_d(2:length(flux)) = diff(flux);
    flux_d_a = flux_d;
    
    flux_d = flux_d_a;
    for j = 3 : length(flux) - 2
        flux_d(j) = median(flux_d_a(j-2 : j+2));
    end

    flux_d = abs(flux_d);
     

    count_t = 0;
    index = 1;
    for j = 1 : length(flux) - Nstep
        aver = mean(flux_d(j:j+Nstep-1));
        maxd = max(flux_d(j:j+Nstep-1));
        mind = min(flux_d(j:j+Nstep-1));
        
        higher_threshold = aver + (maxd - aver)*percenth;
        lower_threshold = aver - (aver - mind)*percentl;
        if flux_d(j) <= lower_threshold
            count_t = count_t+1;
        
        elseif flux_d(j) >= higher_threshold
            if count_t >= minnum
                PLFP_zero(i,index) = j;
                index = index + 1;
                count_t = 0;
            end
            
        else
            count_t = 0;
        end
            
    end
end

for i = 1 : music.musicNum
    
    flux = music.rms(i,:);
    flux_d = zeros(size(flux));
    flux_d(2:length(flux)) = diff(flux);
    flux_d_a = flux_d;
    
    flux_d = flux_d_a;
    for j = 3 : length(flux) - 2
        flux_d(j) = median(flux_d_a(j-2 : j+2));
    end

    flux_d = abs(flux_d);
     
    count_t = 0;
    index = 1;
    for j = 1 : length(flux) - Nstep
        aver = mean(flux_d(j:j+Nstep-1));
        maxd = max(flux_d(j:j+Nstep-1));
        mind = min(flux_d(j:j+Nstep-1));

        higher_threshold = aver + (maxd - aver)*percenth;
        lower_threshold = aver - (aver - mind)*percentl;
        if flux_d(j) <= lower_threshold
            count_t = count_t+1;
        
        elseif flux_d(j) >= higher_threshold
            if count_t >= minnum
                PLFP_rms(i,index) = j;
                index = index + 1;
                count_t = 0;
            end
            
        else
            count_t = 0;
        end
            
    end
end

for i = 1 : music.musicNum
    
    flux = music.brightness(i,:);
    flux_d = zeros(size(flux));
    flux_d(2:length(flux)) = diff(flux);
    flux_d_a = flux_d;
    
    flux_d = flux_d_a;
    for j = 3 : length(flux) - 2
        flux_d(j) = median(flux_d_a(j-2 : j+2));
    end

    flux_d = abs(flux_d);
     
    count_t = 0;
    index = 1;
    for j = 1 : length(flux) - Nstep
        aver = mean(flux_d(j:j+Nstep-1));
        maxd = max(flux_d(j:j+Nstep-1));
        mind = min(flux_d(j:j+Nstep-1));

        higher_threshold = aver + (maxd - aver)*percenth;
        lower_threshold = aver - (aver - mind)*percentl;
        if flux_d(j) <= lower_threshold
            count_t = count_t+1;
        
        elseif flux_d(j) >= higher_threshold
            if count_t >= minnum
                PLFP_brightness(i,index) = j;
                index = index + 1;
                count_t = 0;
            end
            
        else
            count_t = 0;
        end
            
    end
end

save feature_point PLFP_rms PLFP_flux PLFP_brightness PLFP_zero