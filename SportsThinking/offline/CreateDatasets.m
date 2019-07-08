function data = CreateDatasets(EEG, Fs, t)
%CREATEDATASETS 此处显示有关此函数的摘要
%   此处显示详细说明

    data_all = EEG.data;
    event = EEG.event;
    data = cell(1,8);
    count = ones(1,8);

    for i = 1:7
        data{i} = zeros(Fs*t, 62, 80);
    end

    for k = 1:length(event)-1

        e = event(k);
        e1 = event(k+1);

        if e.type >= 65 && e.type <= 71

            if e1.type == e.type
                task_index = e.type - 64;
                eindex = round(e.latency);
                for i = 1:20
                    tmp = data_all(:,eindex+1+(i-1)*Fs*t:eindex+i*Fs*t);
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
                eindex  = round(e.latency);
                for i = 1:20
                    tmp = data_all(:,eindex+1+(i-1)*Fs*t:eindex+i*Fs*t);
                    data{task_index}(:,:,count(task_index)) = tmp';
                    count(task_index) = count(task_index) + 1;
                end
            end 
        end
    end

end

