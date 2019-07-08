function [ALLEEG, EEG] = preproc_dap(ALLEEG, rootpath, subId, filename, bad_chans_labels, repre)
% EEGLAB批处理程序
% 对 dap 数据格式预处理，包括
% 1) 读取数据 loadcurry(）
% 3) 删除并重建坏电极 pop_interp()
% 4) 重参考 pop_reref()
% 5) 去除直流漂移 Removes DC
% 6) 滤波 eegfilt()
% 7) clear_rawdata()
% 8) ICA pop_runica()
% 9) 保存
%
% sample:
% [ALLEEG, ~, ~, ALLCOM] = eeglab;
% eegfilename = '/home/Data/20160604.cnt';
% bad_chans_labels = {'T8','FT8'};
% [ALLEEG,EEG] = preproc_cnt(ALLEEG, eegfilename, bad_chans_labels, 0);
%
% 2016.4.18 Bo Hongjian - started script
%
  if nargin < 5
    repre = 0;
  end
  if nargin < 4
    bad_chans_labels = [];
  end
  if nargin < 3
    error('Not enough input params.');
  end
  %0.check if exist set file
  setpath = fullfile(rootpath, 'set');
  setname = [subId '.set'];
  setfile = fullfile(setpath, setname);
  dapname = filename;
  dapfile = fullfile(rootpath, 'DAP', subId, dapname);
  if repre == 0 && exist(setfile, 'file') == 2
    EEG = pop_loadset('filename', setname, 'filepath', setpath);
    [ALLEEG, EEG] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
  else
  % Initialize params
    low_cutoff = 0.5;
    high_cutoff = 49;
    filt_order = [];

  %1.Read the dap file
    fprintf('Loading dap data using loadcurry from file: %s\n', filename);
    EEG = loadcurry(dapfile, 'CurryLocations', 'False');

  %3.Remove ECG channels
    rm_idxs = find(ismember({EEG.chanlocs.labels}, {'HEO' 'VEO' 'M1' 'M2' 'EKG' 'EMG'}));
    if ~isempty(rm_idxs)
      EEG = pop_select(EEG,'nochannel', rm_idxs);
    end
    % interpolate bad channels
    [~, indelec, ~, ~] = pop_rejchan(EEG, 'elec',1:EEG.nbchan ,'threshold',5,'norm','on','measure','kurt');
    if ~isempty(bad_chans_labels)
      bad_idxs = find(ismember({EEG.chanlocs.labels}, bad_chans_labels));
      indelec = union(indelec, bad_idxs);
    end
    EEG = pop_interp(EEG, indelec, 'spherical');

  %4.Re-reference to an average reference
    EEG = pop_reref( EEG, []);

  %5.Remove the offset of each channel
    fprintf('Removing DC from each channel ...\n');
    EEG.data = single(detrend(double(EEG.data'),'linear'))';

  %6.Filter data  - do highpass and low-pass in separate
    if isempty(filt_order)
      filt_order = fix(EEG.srate/low_cutoff);
    end
    % highpass
    EEG.data = eegfilt(EEG.data, EEG.srate, low_cutoff, 0, 0, filt_order);
    % low-pass
    EEG.data = eegfilt(EEG.data, EEG.srate, 0, high_cutoff, 0, []);
  
  %7. clear rawdata by ASR
  %EEG = clean_rawdata(EEG, -1, [0.25 0.75], 0.8, 4, 5, 'off');
    EEG = clean_rawdata(EEG, -1, [0.25 0.75], -1, -1, 5, 'off');
    setfilename = [subId '-asr.set'];
    pop_saveset(EEG,'filepath',setpath, 'filename', setfilename, ...
      'savemode', 'twofiles');
  
  %8.ICA analysis
    EEG = pop_runica(EEG,'icatype','runica');
    [ALLEEG, EEG, ~] = eeg_store(ALLEEG, EEG);
    EEG = eeg_checkset(EEG);

  %9.Saving data
    setfilename = [subId '-asr-ica.set'];
    pop_saveset(EEG,'filepath',setpath, 'filename', setfilename, ...
      'savemode', 'twofiles');
    pause(60);
  end
end
