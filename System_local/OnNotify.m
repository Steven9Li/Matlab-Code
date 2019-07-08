% --------------------------------------------------------------------
%   OnNotify
%
% An event from the device driver

% NOTIFY_CONNECTED              1   // not currently used
% NOTIFY_DATA                   2   // a data packet is ready
% NOTIFY_CONNECTED_NO_CONFIG	3	// device has connected, requesting configuration
% NOTIFY_IMPEDANCE_READY        4   // impedance data is ready
% NOTIFY_LOST_PKTS              5   // data packets have been lost
function OnNotify(varargin)
    global gServer;                     % global pointer to the COM device interface
    global gBlocksPerSecond;            % stores the number of bloacks of data per second
    global gTotalChannels;              % stores the total number of device channels
    global gbDataReady;     % flag to stop re-display of same data, set to true after new data has arrived
    global count1;
    global data1s;  %1s data
    global count2;
	switch varargin{3}  % nEvent
        case 1  % NOTIFY_CONNECTED
             disp('NOTIFY_CONNECTED');
           % not used yet
        case 2  % NOTIFY_DATA
            % only get new data if we've finished processing teh previous
            % lot
                       
            if gbDataReady == false
                % disp(['开始读取数据: ',num2str(count1)])
                gDisplayData = zeros(64,100);
                % data is ready to be retrieved from the device
                device = gServer.invoke('ICmpDeviceExtensions');
                deviceData = invoke(device, 'ReadDataEx');
                if isempty(deviceData) ~=  1
                    count1 = count1 + 1;
                end

                % 此处使用的固定长度
                m = 2;
                for c = 1:64
                    gDisplayData(c,:) = deviceData(m+(c-1)*100:m+c*100-1);
                end
                data1s(:,(count1-1)*100+1:count1*100) = gDisplayData*1000;
                if count1 == 10
                    disp(count2)
                    count2 = count2 + 1;
                    count1 = 0;
                end
            end
            
            % disp('End Data')
       case 3  % NOTIFY_CONNECT_NO_CONFIG
            disp('Send configuration')
            % device has connected, but needs to be configured.
            % send it a configuration XML string or loop through all the
            % Channel objects and configure them individually
            device = gServer.invoke('ICmpDevice');
            
            % open the configuration file - should add a GUI to allow user
            % to select file
            strConfigFile = 'Synamp2.xml';
            [fileConfig, message] = fopen(strConfigFile, 'r');
            if(fileConfig < 0)
                disp(message);
            else
                % read in the string
                strConfiguration = '';
                while feof(fileConfig) == 0
                    tline = fgetl(fileConfig);
                    % concatenate the strings
                    strConfiguration = [strConfiguration, tline];
                end
              
                % send the configuration to the device
                disp('Sending configuration...')
                device.Configuration = strConfiguration;
                
                % grab some of the setup information: sample rates,
                % blockspersecond...
                gBlocksPerSecond = device.BlocksPerSecond;
                gTotalChannels = device.TotalChannels;
                %disp(['gBlocksPerSecond: ',num2str(gBlocksPerSecond)]);
                %disp(['gTotalChannels: ',num2str(gTotalChannels)]);
                
                % and finally, enable the data stream
                invoke(device, 'EnableData', true);
                
                 % close the file handle
                fclose(fileConfig);
            end
            disp('End configuration')
        case 4  % NOTIFY_IMPEDANCE_READY
            disp('NOTIFY_IMPEDANCE_READY')
        case 5 % NOTIFY_LOST_PKTS
            disp('NOTIFY_LOST_PKTS')
        otherwise   % error, don't know what to do with other types
    end
%end % OnNotify
    
    