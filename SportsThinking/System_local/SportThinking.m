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

function ConnectDeviceDriver()
    global gDisplayData;
    gDisplayData = [];
    strSynamp2Device = 'CMSynamp2.CmpDevice';
    global gServer;         % global COM object
	gServer = actxserver(strSynamp2Device);
	registerevent(gServer, 'OnNotify')
	strSynamp2Connect = '';
    device = gServer.invoke('ICmpDevice');
	invoke(device, 'Connect', strSynamp2Connect);
    
% end FileMenu_Connect_Callback


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    ConnectDeviceDriver();
    set(handles.edit2,'string','设备通信成功');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('数据读取按钮激活')
    global data1s;    % global for storing current data to be displayed
    global gbDataReady;     % flag to stop re-display of same data, set to true after new data has arrived
    global strConfigFile;
    global count2;
    global fileopen_times;

    strConfigFile = 'Synamp2.xml';
    gbDataReady = false;
    fileopen_times = 1;
    
    
    CSPMatrix = handles.CSP;
    trainedClassifier = handles.Classifier;
    nbFilterPairs = 10;
    times = 10;
    test_res = zeros(times,6);
    
    if ( exist('dataFolder','dir') ~= 7)
        mkdir('dataFolder');%creat folder
    end
    index = count2;
    % 存储读取的数据
    saveName = strcat('dataFolder\IndexData.txt');
    fid = fopen(saveName,'w+');
    fwrite(fid,['文件打开次数： ', num2str(fileopen_times)]);
    readdata_times = 0;
    
    while(true)
        
        if readdata_times == times
            break;
        end
        
        if index == count2
            continue
        else
            index = count2;
            fwrite(fid,num2str(index));
            rawData = data1s;
            readdata_times = readdata_times + 1;
            rawData(63,:) = [];
            rawData(63,:) = [];
            for i = 1:6
                for j = (i+1):6
                    EEG_test.x = rawData;
                    test_features = extractCSP(EEG_test, CSPMatrix{i,j}, nbFilterPairs);
                    test_features(:,21) = [];
                    y = trainedClassifier{i,j}.predictFcn(test_features);
                    if y == 1
                        test_res(readdata_times,i) = test_res(readdata_times,i) + 1;
                    else
                        test_res(readdata_times,j) = test_res(readdata_times,j) + 1;
                    end
                end
            end    
        end
    end
    fwrite(fid,['数据读取了 ', num2str(readdata_times), ' 次']);
    fileopen_times = fileopen_times + 1;
    fclose(fid);
    
    
    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('数据读取按钮激活')
    global data1s;    % global for storing current data to be displayed
    global gbDataReady;     % flag to stop re-display of same data, set to true after new data has arrived
    global strConfigFile;
    global count2;
    global fileopen_times;

    strConfigFile = 'Synamp2.xml';
    gbDataReady = false;
    fileopen_times = 1;
    
    times = 5;
    data = zeros(64,times*1000);
    if ( exist('dataFolder','dir') ~= 7)
        mkdir('dataFolder');%creat folder
    end
    index = count2;
    % 存储读取的数据
    saveName = strcat('dataFolder\IndexData.txt');
    fid = fopen(saveName,'w+');
    fwrite(fid,['文件打开次数： ', num2str(fileopen_times)]);
    readdata_times = 0;
    
    while(true)
        
        if readdata_times == times
            break;
        end
        
        if index == count2
            continue
        else
            index = count2;
            fwrite(fid,num2str(index));
            rawData = data1s;
            readdata_times = readdata_times + 1;
            data(:,(readdata_times-1)*1000+1:readdata_times*1000) = rawData;
            
        end
    end
    fwrite(fid,['数据读取了 ', num2str(readdata_times), ' 次']);
    fileopen_times = fileopen_times + 1;
    fclose(fid);
    


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('断开通信按钮激活')
    global gServer;
    gServer.unregisterallevents;
    gServer.release;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('开始初始化')
    classifier = load('classifier56.mat');
    handles.CSP = classifier.CSPMatrix;
    handles.Classifier = classifier.trianedClassifier;
    guidata(hObject, handles);
    set(handles.edit2,'string','初始化完成');
    disp('初始化完成')



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
