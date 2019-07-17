clear;clc;

locationData = '/data/Lihw/MATLAB/EEG_DATA_f30';

%clean_rawdata�ͽ�����
for i = 1:7
    EEG = pop_loadset('filename',['sub', num2str(i),'_f30.set'],'filepath',locationData);
    disp('clean_rawdata');
    EEG = clean_rawdata(EEG  , [], 'off', [], 'off', [], -1);
    %disp('Re-ref');
    %EEG = pop_reref( EEG, []);
    %EEG = eeg_checkset( EEG );
    EEG = pop_resample(EEG  ,250);
    EEG = eeg_checkset( EEG );
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = pop_saveset( EEG, 'filename',['sub', num2str(i),'_f30_c_res_ica.set'],'filepath',locationData);
end