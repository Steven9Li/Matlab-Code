clear;clc;

load('arglist.mat');
locationData = '/data/Lihw/MATLAB/EEG_DATA_F_C';
typelocationData = '/data/Lihw/MATLAB/EEG_DATA_F';
%ica
for i = 1:15
    EEG = pop_loadset('filename',[num2str(i),'_f.set'],'filepath',typelocationData);
  
    
    arglist{1,4}=EEG.nbchan;
    arglist{1,6}=EEG.nbchan;
    
    [W,S,mods] = runamica15(EEG.data(:,:),arglist{:});
    
    EEG.icaweights = W;
    EEG.icasphere = S(1:size(W,1),:);
    EEG.icawinv = mods.A(:,:,1);
    EEG.mods = mods;
    
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',[num2str(i),'_f_nica.set'],'filepath',locationData);
end