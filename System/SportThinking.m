<<<<<<< HEAD
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('开始TCP/IP通信')
    global tcpipClient;
    tcpipClient = tcpip('192.168.1.21',30000,'NetworkRole','Client');
    set(tcpipClient,'InputBufferSize',64*1000*8);
    set(tcpipClient,'OutputBufferSize',8);
    fopen(tcpipClient);
    while(1)
        rawData = fread(tcpipClient,64*1000,'double');
        if length(rawData) == 64*1000
            break;
        end
    end
    
    set(handles.edit2,'String',['TCP/IP通信成功','  当前索引为：',num2str(rawData(1))])
    % fclose(tcpipClient);
    


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('读取10s长数据进行判断按钮激活')
    global tcpipClient;
    %fopen(tcpipClient);

    datas = zeros(64,10000);
    tic
    for i = 1:1
        % fwrite(tcpipClient,flag,'double');
        rawData = fread(tcpipClient,64*1000,'double');
        disp(i)
        data = reshape(rawData,64,1000);
        datas(:,(i-1)*1000+1:i*1000) = data;
    end
    toc
    set(handles.edit2,'String',num2str(rawData(1)));
%     figure(1)
%     for i = 1:64
%         subplot(8,8,i)
%         plot(datas(i,:));
%     end
    %fclose(tcpipClient);
    
    
    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clc;
    disp('开始初始化')
    classifier = load('classifier56.mat');
    handles.CSP = classifier.CSPMatrix;
    handles.Classifier = classifier.trainedClassifier;
    guidata(hObject, handles);
    set(handles.edit2,'string','初始化成功，可以进行状态识别')
    

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('断开通信按钮激活')
    global tcpipClient;
    fclose(tcpipClient);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    CSPMatrix = handles.CSP;
    trainedClassifier = handles.Classifier;
    nbFilterPairs = 10;
    test_res = zeros(20,6);
    flag = 0;
    
    global tcpipClient;
    for ii = 1:20
        fwrite(tcpipClient,flag,'double');
        rawData = fread(tcpipClient,64*1000,'double');
        rawData(63,:) = [];
        rawData(63,:) = [];
        for i = 1:6
            for j = (i+1):6
                EEG_test.x = rawData;
                test_features = extractCSP(EEG_test, CSPMatrix{i,j}, nbFilterPairs);
                test_features(:,21) = [];
                y = trainedClassifier{i,j}.predictFcn(test_features);
                if y == 1
                    test_res(ii,i) = test_res(ii,i) + 1;
                else
                    test_res(ii,j) = test_res(ii,j) + 1;
                end
            end
        end    
    end
    [~, res] = max(test_res');
    set(handles.edit2,'string',num2str(res'));




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
=======
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('开始TCP/IP通信')
    global tcpipClient;
    tcpipClient = tcpip('192.168.1.21',30000,'NetworkRole','Client');
    set(tcpipClient,'InputBufferSize',64*1000*8);
    set(tcpipClient,'OutputBufferSize',8);
    fopen(tcpipClient);
    while(1)
        rawData = fread(tcpipClient,64*1000,'double');
        if length(rawData) == 64*1000
            break;
        end
    end
    
    set(handles.edit2,'String',['TCP/IP通信成功','  当前索引为：',num2str(rawData(1))])
    % fclose(tcpipClient);
    


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('读取10s长数据进行判断按钮激活')
    global tcpipClient;
    %fopen(tcpipClient);

    datas = zeros(64,10000);
    tic
    for i = 1:1
        % fwrite(tcpipClient,flag,'double');
        rawData = fread(tcpipClient,64*1000,'double');
        disp(i)
        data = reshape(rawData,64,1000);
        datas(:,(i-1)*1000+1:i*1000) = data;
    end
    toc
    set(handles.edit2,'String',num2str(rawData(1)));
%     figure(1)
%     for i = 1:64
%         subplot(8,8,i)
%         plot(datas(i,:));
%     end
    %fclose(tcpipClient);
    
    
    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    clc;
    disp('开始初始化')
    classifier = load('classifier56.mat');
    handles.CSP = classifier.CSPMatrix;
    handles.Classifier = classifier.trainedClassifier;
    guidata(hObject, handles);
    set(handles.edit2,'string','初始化成功，可以进行状态识别')
    

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    disp('断开通信按钮激活')
    global tcpipClient;
    fclose(tcpipClient);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    CSPMatrix = handles.CSP;
    trainedClassifier = handles.Classifier;
    nbFilterPairs = 10;
    test_res = zeros(20,6);
    flag = 0;
    
    global tcpipClient;
    for ii = 1:20
        fwrite(tcpipClient,flag,'double');
        rawData = fread(tcpipClient,64*1000,'double');
        rawData(63,:) = [];
        rawData(63,:) = [];
        for i = 1:6
            for j = (i+1):6
                EEG_test.x = rawData;
                test_features = extractCSP(EEG_test, CSPMatrix{i,j}, nbFilterPairs);
                test_features(:,21) = [];
                y = trainedClassifier{i,j}.predictFcn(test_features);
                if y == 1
                    test_res(ii,i) = test_res(ii,i) + 1;
                else
                    test_res(ii,j) = test_res(ii,j) + 1;
                end
            end
        end    
    end
    [~, res] = max(test_res');
    set(handles.edit2,'string',num2str(res'));




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
>>>>>>> first
