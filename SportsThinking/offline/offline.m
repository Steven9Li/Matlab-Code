function varargout = offline(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @offline_OpeningFcn, ...
                   'gui_OutputFcn',  @offline_OutputFcn, ...
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


% --- Executes just before offline is made visible.
function offline_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axes(handles.axes1);
I = imread('test.jpg');
imshow(I);
% UIWAIT makes offline wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = offline_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_open.
% label: open
% ����EEG�ļ���֧��CNT��SET��DAP�ļ���ʽ
function pushbutton_open_Callback(hObject, eventdata, handles)
    [file,path,FilterIndex] = uigetfile({'*.cnt';'*.set';'*.dap';'*.*'});
    if FilterIndex == 0
        disp('�û�ѡ����ȡ��')
        return;
    end
    file_abs_path = strrep([path,file],'\','\\');
    disp(file_abs_path)
    % �ж��ļ���׺��ѡ��ͬ�Ĵ򿪺���
    clear EEG;
    if contains(file,'.cnt') || contains(file,'.CNT')
        EEG = pop_loadcnt(file_abs_path, 'dataformat', 'auto', 'memmapfile', '');
    elseif contains(file,'.set') || contains(file,'.SET')
        EEG = pop_loadset('filename',file,'filepath',path);
    elseif contains(file,'.dap') || contains(file,'.DAP')
        EEG = loadcurry(file_abs_path, 'CurryLocations', 'False');
    else
        disp('����֧�ֵ��ļ���������ѡ��')
        return;
    end
    % ��ȡ�缫��Ϣ
    channal = cell(1,length(EEG.chanlocs));
    for i = 1:length(EEG.chanlocs)
        channal{i} = EEG.chanlocs(i).labels;
    end
    set(handles.popupmenu1,'string',channal,'value',1);
    
    % ����ת���ο�
    ref = {'ʹ��˫����ͻ��Ϊ�ο�';'ʹ�����е缫��ֵ��Ϊ�ο�'};
    set(handles.popupmenu3,'string',ref,'value',2);
    
    % �Ӵ��ڹ���EEG
    handles.EEG = EEG;
    handles.Fs = EEG.srate;
    handles.channals = channal;
    filename = strsplit(file,'.');
    handles.filename = filename{1};
    guidata(hObject, handles);
    set(handles.edit2, 'String', '�ļ���ȡ�ɹ�');
    set(handles.edit5, 'String', num2str(EEG.srate));
    clear EEG


% --- Executes on button press in pushbutton_paint.
% label: plot
% ����eegplot��ͼ
function pushbutton_paint_Callback(hObject, eventdata, handles)
    eegplot(handles.EEG.data)
    
% --- Executes on button press in pushbutton3.
% label" delete channal
% �缫ɾ��
function pushbutton3_Callback(hObject, eventdata, handles)
    del_channal = get(handles.edit1,'string');
    
    del = strsplit(del_channal);
    EEG = pop_select(handles.EEG,'nochannel', del);
    
    % ���µ缫��Ϣ
    channal = cell(1,length(EEG.chanlocs));
    for i = 1:length(EEG.chanlocs)
        channal{i} = EEG.chanlocs(i).labels;
    end
    set(handles.popupmenu1,'string',channal,'value',1);
    
    % ����EEG��channal
    handles.EEG = EEG;
    handles.filename = [handles.filename '-dc'];
    handles.channals = channal;
    guidata(hObject, handles);
    set(handles.edit2, 'String', [del_channal ' �缫ɾ���ɹ�']);
    clear EEG;

% --- Executes on button press in pushbutton4.
% label: filter
% �˲�����
function pushbutton4_Callback(hObject, eventdata, handles)
    highpass = get(handles.edit3,'string');
    lowpass = get(handles.edit4,'string');
    low_cutoff = str2double(lowpass);
    high_cutoff = str2double(highpass);
    
    EEG = handles.EEG;
    if ~isempty(low_cutoff) && low_cutoff ~= 0
        EEG.data = eegfilt(EEG.data, EEG.srate, low_cutoff, 0, 0, 300);
        set(handles.edit2, 'String', [lowpass 'Hz��ͨ�˲�����']);
    end
    
    if ~isempty(high_cutoff) && high_cutoff ~= 0
        EEG.data = eegfilt(EEG.data, EEG.srate, 0, high_cutoff, 0, []);
        tmp = get(handles.edit2,'string');
        set(handles.edit2, 'String', [tmp 10 highpass 'Hz��ͨ�˲�����']);
    end
    
    handles.EEG = EEG;
    guidata(hObject, handles);
    handles.filename = [handles.filename '-f'];
    set(handles.edit2, 'String', '�˲�����');
    clear EEG;

% --- Executes on button press in pushbutton6.
% label: clean_rawdata
% ����ȥ��
function pushbutton6_Callback(hObject, eventdata, handles)
    EEG = handles.EEG;
    EEG = clean_rawdata(EEG, -1, [0.25 0.75], -1, -1, 5, 'off');
    handles.EEG = EEG;
    handles.filename = [handles.filename '-c'];
    guidata(hObject, handles);
    set(handles.edit2, 'String', '����Ԥ����ȫ����ɣ��뱣�����ݻ��߻���ѵ����');
    clear EEG;


% --- Executes on button press in pushbutton7.
% lable: save
% �������ݼ�
function pushbutton7_Callback(hObject, eventdata, handles)
    selpath = uigetdir();
    pop_saveset( handles.EEG, 'filename',handles.filename,'filepath',selpath);


% --- Executes on button press in pushbutton8.
% label: create
% ��EEG����ȡ����
function pushbutton8_Callback(hObject, eventdata, handles)
    data = CreateDatasets(handles.EEG, handles.Fs, 1);
    rand_data = cell(1,7);
    [~, ~, x] = size(data{1});
    trials_num = x;
    for i = 1:7
        rA = randperm(trials_num);
        rand_data{i} = data{i}(:,:,rA);
    end
    per = cell(1,9);
    for i = 1:9
        per{i} = num2str(i*10);
    end
    set(handles.popupmenu2,'string',per,'value',8);
    
    handles.data = rand_data;
    guidata(hObject, handles);
    set(handles.edit2, 'String', '���ݼ�������ϣ���ָ��ѵ������ģ');


% --- Executes on button press in pushbutton9.
% label:train
% ѵ������
function pushbutton9_Callback(hObject, eventdata, handles)
    [~, ~, x] = size(handles.data{1});
    trials_num = x;
    Index = get(handles.popupmenu2,'Value');
    set(handles.edit2, 'String', [num2str(Index*10) '%����������ѵ��']);
    train_num = trials_num*Index/10;
    [CSPMatrix, trainedClassifier] = Train(handles.data,handles.Fs,trials_num,train_num);
    handles.CSPMatrix = CSPMatrix;
    handles.trainedClassifier = trainedClassifier;
    handles.train_num = train_num;
    handles.trials_num = trials_num;
    handles.test_num = trials_num-train_num;
    guidata(hObject, handles);
    set(handles.edit2, 'String', 'ѵ������');

% --- Executes on button press in pushbutton10.
% label:test
% ��������
function pushbutton10_Callback(hObject, eventdata, handles)
    acc = Test(handles.data,handles.Fs,handles.trials_num,handles.test_num,handles.CSPMatrix,handles.trainedClassifier);
    res = '';
    for i = 1:7
        for j = i+1:7
            res = [res num2str(i),',',num2str(j),' ʶ����Ϊ�� ', num2str(acc(i,j)),10];
        end
    end
    set(handles.edit2, 'String', res);

% --- Executes on button press in pushbutton11.
% label:ref
% �ο��缫����
function pushbutton11_Callback(hObject, eventdata, handles)
    Index = get(handles.popupmenu3,'Value');
    EEG = handles.EEG;
    if Index == 1
        EEG = pop_reref( EEG, [42 59] );
        set(handles.edit2, 'String', 'ʹ��˫����ͻ��Ϊ�ο�');
    else
        EEG = pop_reref( EEG, []);
        set(handles.edit2, 'String', 'ʹ�����е缫��ֵ��Ϊ�ο�');
    end
    handles.EEG = EEG;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton12.
% label: sample
% ����������
function pushbutton12_Callback(hObject, eventdata, handles)
    new_sample = get(handles.edit5,'string');
    ns = str2double(new_sample);
    EEG = handles.EEG;
    EEG = pop_resample(EEG, ns);
    handles.EEG = EEG;
    handles.Fs = ns;
    guidata(hObject, handles);
    set(handles.edit2, 'String', ['���ݲ����ʱ�Ϊ�� ', num2str(ns)]);


function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
    chanIndex = get(handles.popupmenu1,'Value');
    del_channal = get(handles.edit1,'string');
    del_channal = [del_channal ' ' handles.channals{chanIndex}];
    set(handles.edit1, 'String', del_channal);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)

function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
