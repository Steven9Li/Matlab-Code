<<<<<<< HEAD
function EEG = createData(sample, time)
    %CREATEDATA 此函数生成EEG结构体
    %输入参数说明：
    %   sample:采样率,整数
    %   time:时长，整数
    
%     if time > 20
%         disp('脑电时长超过8s，请重新选择输入')
%         return
%     end
    
    EEG = load('EEG_example.mat');
    EEG = pop_resample(EEG.EEG, sample);
    EEG = pop_select(EEG,'point',1:sample*time);
    EEG.data = [];
end

=======
function EEG = createData(sample, time)
    %CREATEDATA 此函数生成EEG结构体
    %输入参数说明：
    %   sample:采样率,整数
    %   time:时长，整数
    
%     if time > 20
%         disp('脑电时长超过8s，请重新选择输入')
%         return
%     end
    
    EEG = load('EEG_example.mat');
    EEG = pop_resample(EEG.EEG, sample);
    EEG = pop_select(EEG,'point',1:sample*time);
    EEG.data = [];
end

>>>>>>> first
