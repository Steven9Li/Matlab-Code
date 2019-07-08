clear;clc;

EEG = pop_loadset('filename','Xcat0523-r.set','filepath','D:\\MyProjects\\SportsThinking\\Data\\Xcat 20190523\\');
data_all = EEG.data;
event = EEG.event;
chanlocs = EEG.chanlocs;
Fs = 1000;
t = 1;
data = cell(1,8);
count = ones(1,8);

for i = 1:7
    data{i} = zeros(Fs*t, 62, 80);
end

index = 1;
for k = 1:length(event)-1
   
    e = event(k);
    e1 = event(k+1);
    
    if e.type >= 65 && e.type <= 71
        
        if e1.type == e.type
            task_index = e.type - 64;
            for i = 1:20
                tmp = data_all(:,e.latency+1+(i-1)*Fs*t:e.latency+i*Fs*t);
                data{task_index}(:,:,count(task_index)) = tmp';
                count(task_index) = count(task_index) + 1;
            end       
        end 
    end
    
    if e.type == 1
        
        if e1.type == e.type
            continue;
        else
            task_index = 8;
            for i = 1:20
                tmp = data_all(:,e.latency+1+(i-1)*Fs*t:e.latency+i*Fs*t);
                data{task_index}(:,:,count(task_index)) = tmp';
                count(task_index) = count(task_index) + 1;
            end
        end 
    end
end
disp('END')