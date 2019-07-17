%��ԭʼ���εĴ��?������
%����λ����Ϣ
%ת�ο��缫
%ɾ��缫
%�˲�
%������(��)
locationData = '/data/Lihw/MATLAB/EEG_DATA_f30';
locationFile = '/data/Lihw/MATLAB/location/SynAmps2 Quik-Cap64.DAT';
%all_filename = {'wangjinxiang_pitch.cnt', 'zhaominru_pitch.cnt', 'boyi_pitch.cnt',  'hanminghao_pitch.cnt', 'zhujiaqi_pitch.cnt', 'shijiawei_pitch.cnt', 'daijin_pitch.cnt', 'xumingchao_pitch.cnt', 'yupeng_pitch.cnt', 'zhangguangbi_pitch.cnt', 'wangxiaohan_pitch.cnt', 'wuhuazhao_pitch.cnt', 'wangbin_pitch.cnt', 'zhuheyi_pitch.cnt', 'sunrihui_pitch.cnt', 'tengjun_pitch.cnt', 'wutianhui_pitch.cnt', 'yangyimin_pitch.cnt', 'kongweibing_pitch.cnt', 'wangyan_pitch.cnt',  'xumuhan_pitch.cnt'};
%all_filename = string(all_filename);
sub_num = 15;

for i = 1 : sub_num
    file_name = strcat('/data/Lihw/MATLAB/EEG_DATA/', [num2str(i),'.cnt']);
    %�������
    disp('load data: file_name');
    EEG = pop_loadcnt(file_name, 'dataformat', 'auto', 'memmapfile', '');
    EEG = eeg_checkset( EEG );
    %����λ����Ϣ
    disp('load location file');
    EEG = pop_chanedit(EEG , 'lookup', locationFile); 
    EEG = eeg_checkset( EEG ); 
    %1��45Hz�˲�
    disp('filter');
    [EEG  , ~, ~] = pop_eegfiltnew(EEG  , 1, []);
    [EEG  , com, ~] = pop_eegfiltnew(EEG  , [], 30);
   
    %ȥ��HEO��VEO��M1��M2
    disp('Remove HEO, VEO, M1, M2');
    channel_len = EEG.nbchan;
    if channel_len == 65
        EEG = pop_select(EEG,'nochannel', {'HEO' 'VEO' 'M2'});
    elseif channel_len == 66
        EEG = pop_select(EEG,'nochannel', {'HEO' 'VEO' 'M1' 'M2'});
    end
    EEG = eeg_checkset( EEG );
    %ת�ο��缫����ƽ��缫��Ϊ�ο�
    disp('Re-ref');
    EEG = pop_reref( EEG, []);
    EEG = eeg_checkset( EEG );
    %�������
    disp('save data');
    EEG = pop_saveset( EEG, 'filename',['sub', num2str(i),'_f30.set'],'filepath',locationData);
end