% P300

clear;
clc;

EEG = pop_loadset('filename','p300_original_f_ica_o.set','filepath','/data/Lihw/MATLAB/P300SampleData');
data_all = EEG.data;
event = EEG.event;

sum11 = zeros(62, 1001);
sum22 = zeros(62, 1001);
count11 = 0;
count22 = 0;
for k = 1:length(event)
    e = event(k);
    if e.type == 11
        sum11 = sum11 + data_all(:,e.latency-400:e.latency+600);
        count11 = count11 + 1;
    end
    
    if e.type == 22
        sum22 = sum22 + data_all(:,e.latency-400:e.latency+600);
        count22 = count22 + 1;
    end
end

avg_11 = sum11/count11;
avg_22 = sum22/count22;

rx = zeros(1001);
rrx = zeros(1001);
xl = -40:60;

figure(1)
for i = 1:62
subplot(8,8,i)
    hold on
    rx = avg_11(i,:);
    rx = double(rx);
    rx = resample(rx,100,1000);
    rx = smooth(rx);
  
    rrx = avg_22(i,:);
    rrx = double(rrx);
    rrx = resample(rrx,100,1000);
    rrx = smooth(rrx);
    
    plot(xl,rx,'r','LineWidth',1);
    plot(xl,rrx,'c','LineWidth',1);

    plot([-40 60],[0 0],'k');
    plot([0 0],[-5 5],'k');
    title(EEG.chanlocs(i).labels);
end