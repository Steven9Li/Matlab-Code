% Curry 7.0  脑电数据预处理程序

clear;clc;

filename = 'D:\\MyProjects\\SportsThinking\\Data\\Xcat 20190523\\Acquisition 06.dap';
subId = 'Xcat0523';
% Initialize params
low_cutoff = 0.1;
high_cutoff = 44;
filt_order = [];
%1.Read the dap file
fprintf('Loading dap data using loadcurry from file: %s\n', filename);
EEG = loadcurry(filename, 'CurryLocations', 'False');
EEG = pop_select(EEG,'nochannel', {'HEO' 'VEO' 'M1' 'M2' 'EKG' 'EMG'});
% 
% fprintf('Removing DC from each channel ...\n');
% EEG.data = single(detrend(double(EEG.data'),'linear'))';
% 
% %6.Filter data  - do highpass and low-pass in separate
% if isempty(filt_order)
%   filt_order = fix(EEG.srate/low_cutoff);
% end
% % highpass
% EEG.data = eegfilt(EEG.data, EEG.srate, low_cutoff, 0, 0, filt_order);
% % low-pass
% EEG.data = eegfilt(EEG.data, EEG.srate, 0, high_cutoff, 0, []);
% 
% EEG = pop_reref( EEG, []);

% EEG = clean_rawdata(EEG, -1, [0.25 0.75], -1, -1, 5, 'off');
setfilename = [subId '-r.set'];
pop_saveset(EEG,'filepath','D:\\MyProjects\\SportsThinking\\Data\\\\Xcat 20190523\\', 'filename', setfilename, ...
  'savemode', 'twofiles');

%8.ICA analysis
% EEG = pop_runica(EEG,'icatype','runica');
% [ALLEEG, EEG, ~] = eeg_store(ALLEEG, EEG);
% EEG = eeg_checkset(EEG);

%9.Saving data
% setfilename = [subId '-asr-ica.set'];
% pop_saveset(EEG,'filepath',setpath, 'filename', setfilename, ...
%   'savemode', 'twofiles');