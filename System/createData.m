<<<<<<< HEAD
function EEG = createData(sample, time)
    %CREATEDATA �˺�������EEG�ṹ��
    %�������˵����
    %   sample:������,����
    %   time:ʱ��������
    
%     if time > 20
%         disp('�Ե�ʱ������8s��������ѡ������')
%         return
%     end
    
    EEG = load('EEG_example.mat');
    EEG = pop_resample(EEG.EEG, sample);
    EEG = pop_select(EEG,'point',1:sample*time);
    EEG.data = [];
end

=======
function EEG = createData(sample, time)
    %CREATEDATA �˺�������EEG�ṹ��
    %�������˵����
    %   sample:������,����
    %   time:ʱ��������
    
%     if time > 20
%         disp('�Ե�ʱ������8s��������ѡ������')
%         return
%     end
    
    EEG = load('EEG_example.mat');
    EEG = pop_resample(EEG.EEG, sample);
    EEG = pop_select(EEG,'point',1:sample*time);
    EEG.data = [];
end

>>>>>>> first
