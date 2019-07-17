% EEGLAB history file generated on the 14-May-2018
% ------------------------------------------------

EEG.etc.eeglabvers = '14.1.1'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_loadcnt('D:\MATLAB\EEG_DATA\3.cnt' , 'dataformat', 'auto', 'memmapfile', '');
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'lookup','D:\\MATLAB\\location\\SynAmps2 Quik-Cap64.DAT');
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG,'nochannel',{'HEO' 'VEO' 'M2'});
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = pop_eegfiltnew(EEG, 1,45,3300,0,[],1);
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = pop_reref( EEG, []);
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
EEG = clean_rawdata(EEG, -1, [-1], -1, -1, 5, 'off');
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
