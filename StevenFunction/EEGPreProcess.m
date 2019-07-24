function EEG = EEGPreProcess(filePath, chanlocsFiles, uselessChannal, resample, lowFilter, highFilter, icaFlag, cleanFlag, saveName, savePath)
% EEGԤ�������
% ���������
% filePath EEG�ļ�λ��;
% chanlocsFiles �缫λ���ļ�λ��;
% resample �ض��������
% uselessChannal ��Ҫɾ���ĵ缫
% lowFilter, highFilter ��ͨ�˲��͵�ͨ�˲�����
% icaFlag, cleanFlag �Ƿ����ICA��clean���� 0 ��ʾ������
% saveName, savePath ���� �ļ�����·��
% ���������EEG�ṹ��

if nargin ~= 10
    disp("��������������飡")
    EEG = 0;
    return
end

% �����ļ�
    disp(['load file: ', filePath]);
    EEG = pop_loadcnt(filePath, 'dataformat', 'auto', 'memmapfile', '');
    EEG = eeg_checkset( EEG );
    
% ����缫λ���ļ�
    disp('load location file');
    EEG = pop_chanedit(EEG , 'lookup', chanlocsFiles); 
    EEG = eeg_checkset( EEG );
    
% ɾ�����õ缫
    disp(uselessChannal)
    EEG = pop_select(EEG,'nochannel', uselessChannal);
    
% ��������250
    disp('Resample');
    EEG = pop_resample(EEG, resample);
    EEG = eeg_checkset( EEG );
    
% �˲�    
    EEG = pop_eegfilt(EEG, lowFilter, highFilter, [], 0, 0, 0, 'fir1', 0);
    EEG = eeg_checkset( EEG );
    
% ת�ο�
    disp('Re-ref��average');
    EEG = pop_reref( EEG, []);
    EEG = eeg_checkset( EEG );
   
% ICA
    if icaFlag == 1
        EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    end
  
% clean
    if cleanFlag == 1
        EEG = clean_rawdata(EEG, -1, [0.25 0.75], -1, -1, 5, 'off');
    end
    
% ��������
    disp('save data');
    pop_saveset( EEG, 'filename',saveName,'filepath',savePath);
end

