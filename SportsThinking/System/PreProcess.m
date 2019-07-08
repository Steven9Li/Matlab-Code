function data = PreProcess(EEG)
%PREPROCESS 此处显示有关此函数的摘要
%   此处显示详细说明
EEG = pop_select(EEG,'nochannel', {'HEO' 'VEO' 'M1' 'M2' 'EKG' 'EMG'});
EEG.data = single(detrend(double(EEG.data'),'linear'))';

low_cutoff = 0.1;
high_cutoff = 44;

%6.Filter data  - do highpass and low-pass in separate
% highpass
EEG.data = eegfilt(EEG.data, EEG.srate, low_cutoff, 0, 0, 300);
% low-pass
EEG.data = eegfilt(EEG.data, EEG.srate, 0, high_cutoff, 0, []);

EEG = pop_reref( EEG, []);

EEG = clean_rawdata(EEG, -1, [0.25 0.75], -1, -1, 5, 'off');

data = EEG.data;
end

