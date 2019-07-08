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
    global gSamplesPerChannelPerBlock;  % array of samples per channel per data block
    global gDisplayData;                % global for storing current data to be displayed
    global gbDataReady;                 % flag to stop re-display of same data, set to true after new data has arrived

	switch varargin{3}  % nEvent
        case 1  % NOTIFY_CONNECTED
             disp('NOTIFY_CONNECTED');
           % not used yet
        case 2  % NOTIFY_DATA
            % only get new data if we've finished processing teh previous
            % lot
            if gbDataReady == false
                % data is ready to be retrieved from the device
                device = gServer.invoke('ICmpDeviceExtensions');
                deviceData = invoke(device, 'ReadDataEx');

                % data is an array of floats.
                % The array contains one 'block' of data.  Each block
                % represents a fraction of a second, the call BloackPerSecond
                % tells how many of these blocks make up one second's worth of
                % data.
                % All channels with a sample rate greater than 0 are present
                % sequentially in the array, ie: all the samples representing
                % Channel 1 are at the start of the array, followed by all the
                % samples for channel 2, ...
                % the number of samples for each channel is determined by:
                % Sample_rate_of_channel / blocks_per_second

                % split the array into individual channel components
                nIndex = 2;     % starting at 1 based index, but the first element is the duration of the array (not always implemented as it's not very necessary, so start at index 2)
                for m = 1:gTotalChannels
                    if nIndex < size(deviceData, 2)
                        if(gSamplesPerChannelPerBlock(m) > 0)
                            gDisplayData(m,:) = deviceData(nIndex:(nIndex + gSamplesPerChannelPerBlock(m) - 1));
                            nIndex = nIndex + gSamplesPerChannelPerBlock(m);
                        end
                    end
                end

                % new data is now ready for display
                gbDataReady = true;
            end
            
       case 3  % NOTIFY_CONNECT_NO_CONFIG
            % device has connected, but needs to be configured.
            % send it a configuration XML string or loop through all the
            % Channel objects and configure them individually
            device = gServer.invoke('ICmpDevice');
            
            % open the configuration file - should add a GUI to allow user
            % to select file
            global strConfigFile;
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
                gDisplayData = [];
                for m = 0:(gTotalChannels-1)
                    channel = get(device, 'Channel', m);
                    gSamplesPerChannelPerBlock(m+1) = channel.SampleRate / gBlocksPerSecond;
                end
                
                % and finally, enable the data stream
                invoke(device, 'EnableData', true);
                
                 % close the file handle
                fclose(fileConfig);
            end
        case 4  % NOTIFY_IMPEDANCE_READY
            disp('NOTIFY_IMPEDANCE_READY')
        case 5 % NOTIFY_LOST_PKTS
            disp('NOTIFY_LOST_PKTS')
        otherwise   % error, don't know what to do with other types
    end
%end % OnNotify
    
    