<<<<<<< HEAD
% matlab实时读取脑电信号
clear;
clc;

%% 与设备通信
global gServer;                     % global pointer to the COM device interface
global gBlocksPerSecond;            % stores the number of bloacks of data per second
global gTotalChannels;              % stores the total number of device channels
global gSamplesPerChannelPerBlock;  % array of samples per channel per data block
global gDisplayData;                % global for storing current data to be displayed
global gbDataReady;                 % flag to stop re-display of same data, set to true after new data has arrived
global gDisplayData;
gDisplayData = [];

strSynamp2Device = 'CMSynamp2.CmpDevice';
gServer = actxserver(strSynamp2Device);
registerevent(gServer, 'OnNotify');
strSynamp2Connect = '';
% connect
device = gServer.invoke('ICmpDevice');
invoke(device, 'Connect', strSynamp2Connect);


if ( exist('dataFolder','dir') ~= 7)
    mkdir('dataFolder');%creat folder
end

%open file for recording the captured data 
saveName = strcat('dataFolder\SynampData.txt');
fid = fopen(saveName,'w');

if gbDataReady == true
    
end

=======
% matlab实时读取脑电信号
clear;
clc;

%% 与设备通信
global gServer;                     % global pointer to the COM device interface
global gBlocksPerSecond;            % stores the number of bloacks of data per second
global gTotalChannels;              % stores the total number of device channels
global gSamplesPerChannelPerBlock;  % array of samples per channel per data block
global gDisplayData;                % global for storing current data to be displayed
global gbDataReady;                 % flag to stop re-display of same data, set to true after new data has arrived
global gDisplayData;
gDisplayData = [];

strSynamp2Device = 'CMSynamp2.CmpDevice';
gServer = actxserver(strSynamp2Device);
registerevent(gServer, 'OnNotify');
strSynamp2Connect = '';
% connect
device = gServer.invoke('ICmpDevice');
invoke(device, 'Connect', strSynamp2Connect);


if ( exist('dataFolder','dir') ~= 7)
    mkdir('dataFolder');%creat folder
end

%open file for recording the captured data 
saveName = strcat('dataFolder\SynampData.txt');
fid = fopen(saveName,'w');

if gbDataReady == true
    
end

>>>>>>> first
