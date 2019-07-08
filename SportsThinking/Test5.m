% ÄÔµØÐÎÍ¼³ÌÐò
clear;clc;

load('channal.mat');
load('Sports5530.mat');

rest = 8;
status = 2;
channal_num = 62;
Times = 20;
Fs = 1000;
energy = zeros(channal_num, Times);
rest_energy = zeros(channal_num, Times);

for i = 1:Times
    tmp(:,:) = data{rest}(:,:,i);
    rest_energy(:,i) = mean(tmp.^2);
end
rest = mean(rest_energy');

for status = 1:7

for i = 1:Times
    tmp(:,:) = data{status}(:,:,i);
    %energy(:,i) = mean(tmp.^2) - rest;
    energy(:,i) = mean(tmp.^2);
end


figure(status)
for i = 1:Times
    subplot(4,5,i)
    topoplot(energy(:,i), channal, 'electrodes','off','style','both','plotrad',0.7,'headrad',0.63,'conv','off');
    title([num2str(i),'s'],'FontSize',12,'FontWeight','bold','fontname','Times New Remon');
    %cbar('vert');
end
end

%% Test
rawDir = dir('*Raw.edf'); % find all raw-data files.
% load data in continuous form
cfg = [];
cfg.dataset = rawDir(1).name; % select first file.
% read header and read data. Add fields that are missing after edf2fieldtrip().
hdr = ft_read_header(cfg.dataset);
data = edf2fieldtrip(cfg.dataset);
data.hdr = hdr;
data.hdr.Fs = data.fsample;
data.hdr.nChans = length(data.label);
data.hdr.label = data.label;
data.hdr.nSamples = length(data.trial{1}(1,:));

eventDir = dir('3.csv');
cfg = [];
cfg.dataset = eventDir(1).name; % specify name of the Event.csv file.
% cfg.newfs = data.fsample; % specify the new Fs.
cfg.prestim = 3; % seconds pre-marker
cfg.poststim = 1; % seconds post-marker
cfg.eventvalue = [1 2]; % array of relevant event markers
% B-alert Trial function. Save the ft_trialfun_balert in 'toolbox/fieldtrip/trialfun'
cfg.trialfun = 'ft_trialfun_balert';
cfg = ft_trialfun_balert(cfg); %  segment all trials