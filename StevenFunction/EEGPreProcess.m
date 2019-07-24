function EEG = EEGPreProcess(filePath, chanlocsFiles, uselessChannal, resample, lowFilter, highFilter, icaFlag, cleanFlag, saveName, savePath)
% EEG预处理程序
% 输入参数：
% filePath EEG文件位置;
% chanlocsFiles 电极位置文件位置;
% resample 重定义采样率
% uselessChannal 需要删除的电极
% lowFilter, highFilter 高通滤波和低通滤波参数
% icaFlag, cleanFlag 是否进行ICA和clean操作 0 表示不进行
% saveName, savePath 保存 文件名和路径
% 输出参数：EEG结构体

if nargin ~= 10
    disp("输入参数有误，请检查！")
    EEG = 0;
    return
end

% 导入文件
    disp(['load file: ', filePath]);
    EEG = pop_loadcnt(filePath, 'dataformat', 'auto', 'memmapfile', '');
    EEG = eeg_checkset( EEG );
    
% 导入电极位置文件
    disp('load location file');
    EEG = pop_chanedit(EEG , 'lookup', chanlocsFiles); 
    EEG = eeg_checkset( EEG );
    
% 删除无用电极
    disp(uselessChannal)
    EEG = pop_select(EEG,'nochannel', uselessChannal);
    
% 降采样至250
    disp('Resample');
    EEG = pop_resample(EEG, resample);
    EEG = eeg_checkset( EEG );
    
% 滤波    
    EEG = pop_eegfilt(EEG, lowFilter, highFilter, [], 0, 0, 0, 'fir1', 0);
    EEG = eeg_checkset( EEG );
    
% 转参考
    disp('Re-ref：average');
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
    
% 保存数据
    disp('save data');
    pop_saveset( EEG, 'filename',saveName,'filepath',savePath);
end

