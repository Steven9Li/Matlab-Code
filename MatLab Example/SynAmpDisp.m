%====================================================================
%
%           Compumedics Device Driver Example
%
%   Simple MatLab program to connect to Compumedics Device Drivers
%
%   Matlab versions below 7.0.1 could not register events for COM servers
%   (actxserver) but they could register for COM controls (actxcontrol)
%
%   "Registering Events for COM Servers and Controls
%   With MATLAB 7.0.1, you can register events for COM servers as well as for
%   COM controls."
%====================================================================

function varargout = SynAmpDisp(varargin)
    % SYNAMPDISP M-file for SynAmpDisp.fig
    %      SYNAMPDISP, by itself, creates a new SYNAMPDISP or raises the existing
    %      singleton*.
    %
    %      H = SYNAMPDISP returns the handle to a new SYNAMPDISP or the handle to
    %      the existing singleton*.
    %
    %      SYNAMPDISP('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in SYNAMPDISP.M with the given input arguments.
    %
    %      SYNAMPDISP('Property','Value',...) creates a new SYNAMPDISP or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before SynAmpDisp_OpeningFunction gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to SynAmpDisp_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help SynAmpDisp

    % Last Modified by GUIDE v2.5 29-Mar-2006 11:34:52

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @SynAmpDisp_OpeningFcn, ...
                       'gui_OutputFcn',  @SynAmpDisp_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});

    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
% End initialization code - DO NOT EDIT


% --- Executes just before SynAmpDisp is made visible.
function SynAmpDisp_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to SynAmpDisp (see VARARGIN)

    % Choose default command line output for SynAmpDisp
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes SynAmpDisp wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    % initial setup of graphs
    global NUMBER_CHANNELS;
    global gXWidth;
    gXWidth = 3000;
    for iChan = 1:NUMBER_CHANNELS
        gap = 0.0005;     %gap between plots (relative to total window height)
        subplot('Position', [.1 (1+gap - iChan/NUMBER_CHANNELS) .86 .9*(1/NUMBER_CHANNELS - gap)]);
        plot(1, 0, '-', 'EraseMode', 'none', 'LineWidth', 1);
        hold on
        set(gca, 'XTick', []);
        set(gca, 'XTickLabel', []);
        set(gca, 'XLimMode', 'manual');
        xlim([0 gXWidth]);
        set(gca, 'YLimMode', 'manual');
        ylim([-150 150]);
        ylabel('mV');
    end       


% --- Outputs from this function are returned to the command line.
function varargout = SynAmpDisp_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;

 

% --------------------------------------------------------------------
function ConnectDeviceDriver()
    % hObject    handle to FileMenu_Connect (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    global gDisplayData;
    gDisplayData = [];
    
    % the Device Interface to connect to:
    strSiestaDevice = 'CMSiestaDev.CmpDevice';
    strESeriesDevice = 'CMThunda.CmpDevice';
    strSynamp2Device = 'CMSynamp2.CmpDevice';
    strSimulatorDevice = 'CMSimDev.CmpDevice';

	% instantiate the device object - make global so event Notify can use
	% it
    global gServer;         % global COM object
	gServer = actxserver(strSynamp2Device);

	% register for event notifications
	registerevent(gServer, 'OnNotify')
	
	% Connect to the specific device, but only if a connect string has been supplied.
	% The connection String is different for different device types, example:
	
	% Siesta: IP address serial no. (space separated)
	strSiestaConnect = '10.255.0.102 2146';

	% E-Series: Serial no.
	strESeriesConnect = '397';

	% Synamp2 - no connection string required
	strSynamp2Connect = '';

    % connect
    device = gServer.invoke('ICmpDevice');
	invoke(device, 'Connect', strSynamp2Connect);
% end FileMenu_Connect_Callback
    

% --- Executes on button press in SynampDisp_DispStop.
function SynampDisp_DispStop_Callback(hObject, eventdata, handles)
    % hObject    handle to SynampDisp_DispStop (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    global gServer;         % global pointer to the COM device interface
    global gDisplayData;    % global for storing current data to be displayed
    global gbDataReady;     % flag to stop re-display of same data, set to true after new data has arrived
    gbDataReady = false;

	button_state = get(hObject,'Value');
 	if button_state == get(hObject,'Max')
      	% toggle button is pressed, display data

        % disable the channels and config UI
        set(handles.popupmenu1, 'Enable', 'off');
        set(handles.editConfigFile, 'Enable', 'off');
        
        % connect to device driver
        % release any previous one
        ConnectDeviceDriver();
        
        set(hObject,'String','Stop');
        set(hObject,'ForegroundColor',[1 0 0]);
        
        if ( exist('dataFolder') ~= 7)
            mkdir('dataFolder');%creat folder
        end

        %open file for recording the captured data 
        saveName = strcat('dataFolder\SynampData.txt');
        fid = 0;
        fid = fopen(saveName,'w');
        
        maxPoint = 11;
     	samp = 100;
      	dur  = 30;
        curtime = 0;
        bNewRow = true; % flag for the first data on a new row (used for simple DC offset correction)
            
     	i1 = 1:maxPoint;
      	x_point(i1) = floor(dur*samp*(i1-1)/(maxPoint-1));
       	x_label(i1) = curtime+floor(dur*(i1-1)/(maxPoint-1));

        % initial setup of graphs
        global NUMBER_CHANNELS;
        for iChan = 1:NUMBER_CHANNELS
            gap = 0.0005;     %gap between plots (relative to total window height)
            subplot('Position', [.1 (1+gap - iChan/NUMBER_CHANNELS) .86 .9*(1/NUMBER_CHANNELS - gap)]);
            cla;
            plots(iChan) = plot(1, 0, '-', 'EraseMode', 'none', 'LineWidth', 1);
            hold on
            set(gca, 'XTick', []);
            set(gca, 'XTickLabel', []);
            set(gca, 'XLimMode', 'manual');
            xlim([0 gXWidth]);
            set(gca, 'YLimMode', 'manual');
            ylim([-150 150]);
            ylabel('mV');
            previousPageSum(iChan) = 0;
            previousPageCounter(iChan) = 1;
        end       
        i = 1;
    
        curtime = 0;
        while(1)
            % check that we actually have new data to display
            if gbDataReady == true
                % roll-over the axis to next screen
                if i >= gXWidth
                    bNewRow = true;
                    t = i-gXWidth;
                    i = i-gXWidth;
                    curtime = curtime+3;

                    x_point(i1) = floor(dur*samp*(i1-1)/(maxPoint-1));
                    x_label(i1) = curtime+floor(dur*(i1-1)/(maxPoint-1));

                    % label the bottom graph
                    gap = 0.0005;     %gap between plots (relative to total window height)
                    subplot('Position', [.1 (1+gap - iChan/NUMBER_CHANNELS) .86 .9*(1/NUMBER_CHANNELS - gap)]);
                    hold on
                    set(gca,'XTick',[x_point(i1)]);
                    set(gca,'XTickLabel',[x_label(i1)]);
                    set(gca, 'XLimMode', 'manual');
                    xlim([0 gXWidth]);
                    set(gca, 'YLimMode', 'manual');
                    ylim([-150 150]);
                    ylabel('mV');
                end

                % loop through channels, adding new data
                for iChan = 1:NUMBER_CHANNELS
                    % if this is the start of a new row, save the current
                    % value and use this for the simple DC offset
                    % correction
                    % better option would be to use an average of the
                    % previous page's data, instead of a single point
                    if(bNewRow)
                        DCCorrection(iChan) = previousPageSum(iChan)/previousPageCounter(iChan);
                        previousPageSum(iChan) = 0;
                        previousPageCounter(iChan) = 0;
                    end
                    % plot, if there is data
                    if(size(gDisplayData,1) >= iChan)
                        y = (gDisplayData(iChan, :) * 1000) - DCCorrection(iChan);  % convert to mV (from V) for display
                        dataLength = size(y, 2);

                        % fill in the gap between the last point of the previous
                        % block, and the first point of the new block
                        if(i-1 > 1)
                            set(plots(iChan), 'XData', i-1:i, 'YData', [previous(iChan) y(1)]);
                        end
                        previous(iChan) = y(dataLength);
                        
                        previousPageSum(iChan) = previousPageSum(iChan) + sum(gDisplayData(iChan, :) * 1000);
                        previousPageCounter(iChan) = previousPageCounter(iChan) + dataLength;

                        % plot the new data block
                        set(plots(iChan), 'XData', i:(i+dataLength-1), 'YData', y);
                    end
                end

                if(bNewRow)
                    bNewRow = false;
                end
                
                % update the figures
                drawnow 
                
                %recording the captured data
                leng = length(gDisplayData(1,:));
                if leng >= 1 & NUMBER_CHANNELS >= 1
                
                    for k = 1:leng
                        for k1 = 1:NUMBER_CHANNELS
                            fprintf(fid,'%f\t',gDisplayData(k1,k));
                        end
                    fprintf(fid,'\n');
                    end
                
                end
                

                i = i + dataLength;
                if get(hObject, 'Value') == 0 % stop-position
                    if fid >= 0
                        fclose(fid);
                    end
                    break;
                end
                
                t = i;
                
                % set data ready to false so we don't re-display the same
                % data
                gbDataReady = false;
            else
                if get(hObject, 'Value') == 0 % stop-position
                    ReleaseDeviceDriver();
                    % enable the channels and config UI
                    set(handles.popupmenu1, 'Enable', 'on');
                    set(handles.editConfigFile, 'Enable', 'on');
                    break;
                end
                % pause to allow the other 'thread' to gain access and
                % retrieve the data.  pause must be less than the time
                % between data blocks (100 ms for Synamp2, 0.1 secs)
                pause(0.01);    % pause for 10 ms
            end % if data is ready
        end % while infinite loop
    
    elseif button_state == get(hObject,'Min')
      	% toggle button is back to un-pressed, stop to display data
      	set(hObject,'String','Start');
        set(hObject,'ForegroundColor',[0 1 0]);
        
        % release COM events and object
        ReleaseDeviceDriver();
        % ensable the channels and config UI
        set(handles.popupmenu1, 'Enable', 'on');
        set(handles.editConfigFile, 'Enable', 'on');
  	end    





% --------------------------------------------------------------------
% release COM events and object
function ReleaseDeviceDriver()
    global gServer;
    gServer.unregisterallevents;
    gServer.release;





% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
    % hObject    handle to popupmenu1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popupmenu1
    global NUMBER_CHANNELS;
    index = get(hObject, 'Value');
    strings = get(hObject,'String');
    NUMBER_CHANNELS = str2num(char(strings(index)));

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to popupmenu1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    global NUMBER_CHANNELS;
    index = get(hObject, 'Value');
    strings = get(hObject,'String');
    NUMBER_CHANNELS = str2num(char(strings(index)));



function editConfigFile_Callback(hObject, eventdata, handles)
    % hObject    handle to editConfigFile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of editConfigFile as text
    %        str2double(get(hObject,'String')) returns contents of editConfigFile as a double
    global strConfigFile;
    strConfigFile = get(hObject, 'String');


% --- Executes during object creation, after setting all properties.
function editConfigFile_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to editConfigFile (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    global strConfigFile;
    strConfigFile = get(hObject, 'String');


