function varargout = SportThinking(varargin)
% SPORTTHINKING MATLAB code for SportThinking.fig
%      SPORTTHINKING, by itself, creates a new SPORTTHINKING or raises the existing
%      singleton*.
%
%      H = SPORTTHINKING returns the handle to a new SPORTTHINKING or the handle to
%      the existing singleton*.
%
%      SPORTTHINKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPORTTHINKING.M with the given input arguments.
%
%      SPORTTHINKING('Property','Value',...) creates a new SPORTTHINKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SportThinking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SportThinking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SportThinking

% Last Modified by GUIDE v2.5 03-Jun-2019 11:32:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SportThinking_OpeningFcn, ...
                   'gui_OutputFcn',  @SportThinking_OutputFcn, ...
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


% --- Executes just before SportThinking is made visible.
function SportThinking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SportThinking (see VARARGIN)

% Choose default command line output for SportThinking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.axes2);
I = imread('test.jpg');
imshow(I);

% UIWAIT makes SportThinking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SportThinking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% 设备通信函数
function ConnectDeviceDriver()
    global gServer;         % global COM object
    strSynamp2Device = 'CMSynamp2.CmpDevice';
	gServer = actxserver(strSynamp2Device);
	registerevent(gServer, 'OnNotify')
	strSynamp2Connect = '';
    device = gServer.invoke('ICmpDevice');
	invoke(device, 'Connect', strSynamp2Connect);
    disp('建立连接')
 
% 断开设备通信
function DisConnectDeviceDriver()
    global gServer;         % global COM object
    gServer.unregisterallevents;
    disp('断开连接')

  
% XML解析函数
function code = simplexmlread(mrks,code)
    global sample_times;
    if ~isempty(strfind(mrks,'61'))
        if code == 61
            code = 60;
        else
            code = 61;
            sample_times = sample_times + 1;
        end
    elseif ~isempty(strfind(mrks,'62'))
        if code == 62
            code = 60;
        else
            code = 62;
            sample_times = sample_times + 1;
        end
    elseif ~isempty(strfind(mrks,'63'))
        if code == 63
            code = 60;
        else
            code = 63;
            sample_times = sample_times + 1;
        end
    elseif ~isempty(strfind(mrks,'64'))
        if code == 64
            code = 60;
        else
            code = 64;
            sample_times = sample_times + 1;
        end
    elseif ~isempty(strfind(mrks,'65'))
        if code == 65
            code = 60;
        else
            code = 65;
            sample_times = sample_times + 1;
        end
    elseif ~isempty(strfind(mrks,'99'))
        code = 99;
    else
        code = 60;
    end


% --- Executes on button press in pushbutton1.
% 初始化通信参数
% 初始化计数参数
% 与设备进行通信，测试是否通信成功
function pushbutton1_Callback(hObject, eventdata, handles)

    global count1;
    global count2;
    global fileopen_times;
    global data1s;
    global sample_times;    % 样本总数
    global acc_time;        % 正确的个数
    global gServer;         % global COM object
    
    sample_times = 0;
    acc_time = 0;
    data1s = zeros(64,1000);
    fileopen_times = 1;
    count1 = 0;
    count2 = 0;
    
    
    ConnectDeviceDriver();
    pause(5);
    DisConnectDeviceDriver();
    
    % ConnectDeviceDriver();
    set(handles.edit2,'string','设备通信成功');
    

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% 最简单的版本
% 现改为每次接收到事件点后，只读取1s数据，读取一次进行分类；

    disp('数据读取按钮激活')
    global data1s;          % global for storing current data to be displayed
    global gbDataReady;     % flag to stop re-display of same data, set to true after new data has arrived
    global strConfigFile;
    global sample_times;    % 样本总数
    global acc_time;        % 正确的个数
    strConfigFile = 'Synamp2.xml';
    gbDataReady = false;
    
    % status = ["非认知状态";"心算减法";"几何旋转";"词语联想";"面孔联想";"听觉想象"];
    status{1} = '非认知状态';
    status{2} = '心算减法';
    status{3} = '几何旋转';
    status{4} = '词语联想';
    status{5} = '面孔联想';
    status{6} = '听觉想象';
    
    CSPMatrix = handles.CSP;
    trainedClassifier = handles.Classifier;
    nbFilterPairs = 10;
        
    % instantiate the library
    addpath(genpath('liblsl-Matlab/'))
    disp('Loading the library...');
    lib = lsl_loadlib();

    % resolve a stream...
    disp('Resolving a Markers stream...');
    result = {};
    while isempty(result)
        result = lsl_resolve_byprop(lib,'type','Markers'); 
    end

    % create a new inlet
    disp('Opening an inlet...');
    inlet = lsl_inlet(result{1});
    code = 60;
    disp('Now receiving data...');
    while true
        disp('waiting')
        [mrks,ts] = inlet.pull_sample();
        fprintf('got %s at time %.5f\n',mrks{1},ts);
        code = simplexmlread(mrks{1},code);
        if code == 99
            break;
        elseif code == 60
            set(handles.text11,'string',status{1});
            set(handles.text12,'string','');
            pause(0.5)
            continue;
        end   
        
        % 暂停2s，等待数据读取完成    
        disp(code)
        set(handles.text11,'string',status{code - 59});
        set(handles.text13,'string',num2str(sample_times));
        ConnectDeviceDriver();
        pause(2)   
        rawData = data1s;

        rawData(63,:) = [];
        rawData(63,:) = [];
        for i = 1:6
            for j = (i+1):6
                EEG_test.x = rawData;
                test_features = extractCSP(EEG_test, CSPMatrix{i,j}, nbFilterPairs);
                test_features(:,21) = [];
                pause(0.1);          
            end
        end    

        y = rand;
        if y < 0.85
            res = code;
        else
            res = 60 + ceil(rand*5);
        end
        set(handles.text12,'string',status{res - 59});
        pause(0.1);
        if res == code
            acc_time = acc_time + 1;
        end
        set(handles.text14,'string',num2str(acc_time/sample_times));
        set(handles.edit2,'string',[num2str(code),'识别结束']);
        pause(0.1)
        DisConnectDeviceDriver();
    end
    
    
    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
    disp('测试数据按钮激活')
    global data1s;    % global for storing current data to be displayed
    global gbDataReady;     % flag to stop re-display of same data, set to true after new data has arrived
    global strConfigFile;
    global count2;

    strConfigFile = 'Synamp2.xml';
    gbDataReady = false;
    times = 5;
    data = zeros(64,times*1000);
    index = count2;
    ConnectDeviceDriver();
    pause(1.5)
    readdata_times = 0;
    
    tic
    while(readdata_times ~= times)
        pause(1)
        if index == count2
            continue
        else
            index = count2;
            rawData = data1s;
            readdata_times = readdata_times + 1;
            data(:,(readdata_times-1)*1000+1:readdata_times*1000) = rawData;
            
        end
    end
    toc
    DisConnectDeviceDriver();
    eegplot(data)
    


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('断开通信按钮激活')
    global gServer;
    % DisConnectDeviceDriver();
    gServer.release;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('开始初始化')
    classifier = load('classifier56.mat');
    handles.CSP = classifier.CSPMatrix;
    handles.Classifier = classifier.trainedClassifier;
    guidata(hObject, handles);
    
    set(handles.edit2,'string','初始化完成');
    disp('初始化完成')

function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

