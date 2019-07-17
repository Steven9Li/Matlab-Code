clear;
clc;
% Input: fileName: where the cnt file
%        sec: second of the music (1~120)
% Output: array for 6 music, each of them:
%         ec:    60s eyes closed before music (spontaneous)
%         eo1:   15s eyes open before music
%         music: 30s music clips
%         eo2:   15s eyes open after music
%         valence: rating for valence (1~9)
%         arousal: rating for arousal (1~9)
%         liking:  rating for liking (1~5)
%         familiar:  rating for familiar (1~5)

% init params
Fs = 1000;
MusicFs = 44100;
deltat = 100; % 100ms = 100 samples
musicLen = 30; % music length
musicNum = 16;
locationData = '/data/Lihw/MATLAB/EEG_DATA_F_C';
%typelocationData = 'D:\MATLAB_WorkSpace\EEG_DATA';
% numLocation = 62;

channel_st = cell(1,15);

for i = 1 : 15
    %导入数据
    EEG = pop_loadset('filename',[num2str(i),'_f_c_r_ica_o.set'],'filepath',locationData);
    data_all = EEG.data;
    event = EEG.event;
    
    %导入电极数
    numLocation = length(EEG.chanlocs);
    %channel_st(i).num = numLocation;
    %channel_st(i).labels = EEG.chanlocs.labels;

    
    for k = 1 : musicNum
        music_st(i, k) = struct('eo1', zeros(numLocation,1),'music', zeros(numLocation,1), ...
            'eo2', zeros(numLocation,1), 'valence', 0, 'arousal', 0);
    end
    channel_st{1,i} = EEG.chanlocs;
    mIndex = 0;
    for k = 1:length(event)
        e = event(k);
        % 15s of eo (code 51~66)������ǰ��15s��Ϣ
        if e.type >= 51 && e.type <= 66
            mIndex = e.type - 50;
            music_st(i,mIndex).eo1 = data_all(:,e.latency + deltat:e.latency+Fs*15+deltat-1);
        end
        
        %  30s of music (code 11~26)�� 30s�����ֲ���
        if e.type >= 11 && e.type <= 26
            music_st(i,mIndex).music = data_all(:,e.latency+deltat:e.latency+Fs*musicLen+deltat-1);
        end
        
        %  15s of eo (code 71~86)��15s���ֺ�ľ�Ϣ
        if e.type >= 71 && e.type <= 86
            music_st(i,mIndex).eo2 = data_all(:,e.latency+deltat:e.latency+Fs*15+deltat-1);
        end
        
        %  questionnaire (code 31~33)�����öȺͻ��Ѷ�
        if e.type == 31
            music_st(i,mIndex).valence = event(k+1).type;
        end
        if e.type == 32
            music_st(i,mIndex).arousal = event(k+1).type;
        end
    end
    clear EEG;
    
end

%save EEG_EPOCH music_st
%save EEG_CHANNEL channel_st