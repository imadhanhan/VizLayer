%VizLayer  Visualizes two sets of 3D data.
%   VizLayer(volume1, volume2, ...) opens the VizLayer tool with volume1, a
%   3D matrix, as stacked images on the left, and volume2, a 3D matrix, as 
%   stacked images on the right. 
%
%   VizLayer(volume1, volume2, 'title', Title1, 'title', Title2) opens the VizLayer 
%   tool with volume1, a 3D matrix, as stacked images on the left titled 
%   with the string defined in Title1, and volume2, a 3D matrix, as 
%   stacked images on the right titled with the string defined in Title2. 
%
%   VizLayer( __ , 'colormap', colormap) opens the VizLayer 
%   tool with volume1, a 3D matrix, as stacked images on the left titled 
%   with the colormap defined in string colormap.
%
%   Written by Imad Hanhan, 2019.

function varargout = VizLayer(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VizLayer_OpeningFcn, ...
    'gui_OutputFcn',  @VizLayer_OutputFcn, ...
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

% --- Executes just before VizLayer is made visible.
function VizLayer_OpeningFcn(hObject, eventdata, handles, varargin)
% set(gcf, 'units', 'normalized', 'position', [0.05 0.15 1 1]); %this sets the window aspect ratio
% daspect(handles.axes1, [1 1 1]); %this sets the aspect ratio of axes1
% daspect(handles.axes2, [1 1 1]); %this sets the aspect ratio of axes2
% global name1 name2
% 
% set(handles.text4, 'String', name1);
% set(handles.text8, 'String', name2);

z=1; %intializes as slice = first slice


data1=varargin{1}; %asigns the first window data1
data2=varargin{2}; %asigns the second window data2

% if length(varargin)>2 %check if user specified title input
%     if length(varargin)>3
%         string2=varargin{4};
%         set(handles.text8, 'String', string2);
%     end
%     string1=varargin{3};
%     set(handles.text4, 'String', string1);
% end
options={'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', ... 
                         'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'jetwhite'};
                     
if length(varargin)>2 %check if user specified title input
            t_inp=strcmp(varargin,'title'); %vector with 1's where title is
            if any(t_inp)
                t_pos=find(t_inp==1)+1;
                string1=varargin{t_pos(1)};
                set(handles.text4, 'String', string1);
                if length(t_pos)>1 %user defined second name
                    string2=varargin{t_pos(2)};
                    set(handles.text8, 'String', string2);
                end
            end
            
            c_inp=strcmp(varargin,'colormap'); %vector with 1's where title is
            if any(c_inp)
                c_pos=find(c_inp==1)+1;
                color_choice=varargin{c_pos};
                option2num=find( strcmp(options, color_choice) == 1);
            end
end

if exist('option2num','var')==0
    option2num=10;
end

handles.data1=data1;
handles.data2=data2;
handles.data1min=double(min(data1(:)));
handles.data2min=double(min(data2(:)));
handles.data1max=double(max(data1(:)));
handles.data2max=double(max(data2(:)));

imagesc(handles.axes1, data1(:,:,z)); %visualize the data
colormap(handles.axes1, 'gray') %set the colormap for tomography
if option2num<18
    colormap(handles.axes1, options{option2num}); %set the colormap for tomography
elseif option2num==18
    myColorMap = jet(256); %colormap used for indexing, where 0 is white
    myColorMap(1,:) = 1;
    colormap(handles.axes1,myColorMap);
end
caxis(  handles.axes1, [handles.data1min handles.data1max]);

imagesc(handles.axes2, data2(:,:,z)); %visualize the data
colormap(handles.axes2, 'gray') %set the colormap for tomography
caxis(  handles.axes2, [handles.data2min handles.data2max]);
if option2num<18
    colormap(handles.axes2, options{option2num}); %set the colormap for tomography
elseif option2num==18
    myColorMap = jet(256); %colormap used for indexing, where 0 is white
    myColorMap(1,:) = 1;
    colormap(handles.axes2,myColorMap);
end

% linkaxes([handles.axes1,handles.axes2],'xy')
% Choose default command line output for VizLayer
handles.output = hObject;

s1=size(data1);
s2=size(data2);

if size(s1)<3 %if it's a 2D image
    s1(3)=1; %set the third dimension to 1
    slider_step1=0; %set the slider step to 0, will make slider bar not do anything
else
    slider_step1=1/(s1(3)-1); %otherwise, set the slider bar to a correct stepsize
end

if size(s2)<3 %if data_modify is a 2D image
    s2(3)=1; %set the third dimension to 1
    slider_step2=0;%set the slider step to 0, will make slider bar not do anything
else
    slider_step2=1/(s2(3)-1);%otherwise, set the slider bar to a correct stepsize
end

handles.size1=s1;
handles.size2=s2;

set(handles.slider1, 'min',1);
set(handles.slider1, 'max',s1(3));
set(handles.slider1, 'Value', 1);
set(handles.slider1, 'SliderStep', [slider_step1 , slider_step1 ]);
set(handles.text2, 'String', num2str(s1(3)))
set(handles.text3, 'String', num2str(1))

set(handles.slider2, 'min',1);
set(handles.slider2, 'max',s2(3));
set(handles.slider2, 'Value', 1);
set(handles.slider2, 'SliderStep', [slider_step2 , slider_step2 ]);
set(handles.text9, 'String', num2str(s2(3)))
set(handles.text10, 'String', num2str(1))


%Colormapr options
set(handles.popupmenu1, 'Value', option2num)
set(handles.popupmenu2, 'Value', option2num)



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VizLayer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VizLayer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider 1 movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

popmv1=get(handles.popupmenu1,'Value'); %pop menu value popmv
popmv2=get(handles.popupmenu2,'Value'); %pop menu value popmv
options={'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', ... 
    'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'jetwhite'};

z1=get(handles.slider1,'Value');

xlim = get(handles.axes1, 'XLim');
ylim = get(handles.axes1, 'YLim');

%get the data
data1=handles.data1;
data2=handles.data2;

%plot image1
imagesc(handles.axes1, data1(:,:,floor(z1)));
caxis(  handles.axes1, [handles.data1min handles.data1max]);
set(handles.edit1, 'String', num2str(floor(z1)));
if popmv1<18
    colormap(handles.axes1, options{popmv1}); %set the colormap for tomography
elseif popmv1==18
    myColorMap = jet(256); %colormap used for indexing, where 0 is white
    myColorMap(1,:) = 1;
    colormap(handles.axes1,myColorMap);
end

%plot image 2
if get(handles.checkbox2, 'Value') == 0 %if NOT linking z axes
    %do nothing
elseif get(handles.checkbox2, 'Value') == 1 %if linking z axes
    set(handles.slider2, 'Value', z1);
    set(handles.edit2, 'String', num2str(floor(z1)));
    imagesc(handles.axes2, data2(:,:,floor(z1)));
    caxis(  handles.axes2, [handles.data2min handles.data2max]);
    if popmv2<18
        colormap(handles.axes2, options{popmv2}); %set the colormap for tomography
    elseif popmv2==18
        myColorMap = jet(256); %colormap used for indexing, where 0 is white
        myColorMap(1,:) = 1;
        colormap(handles.axes2,myColorMap);
    end
end

if get(handles.checkbox1, 'Value') == 0 %if NOT linking xy axes
    linkaxes([handles.axes1,handles.axes2],'off')
elseif get(handles.checkbox1, 'Value') == 1 %if  linking xy axes
    set(handles.axes1, 'XLim', xlim);
    set(handles.axes1, 'YLim', ylim);
    set(handles.axes2, 'XLim', xlim);
    set(handles.axes2, 'YLim', ylim);
    linkaxes([handles.axes1,handles.axes2],'xy')
end





% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);

end


% --- Executes on slider 2 movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%plot image 2

popmv1=get(handles.popupmenu1,'Value'); %pop menu value popmv
popmv2=get(handles.popupmenu2,'Value'); %pop menu value popmv
options={'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', ... 
    'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'jetwhite'};

xlim = get(handles.axes1, 'XLim');
ylim = get(handles.axes1, 'YLim');

if get(handles.checkbox2, 'Value') == 0 %if NOT linking z axes
    data2=handles.data2;
    z2=get(handles.slider2,'Value');
    imagesc(handles.axes2, data2(:,:,floor(z2)));
    caxis(  handles.axes2, [handles.data2min handles.data2max]);
    if popmv2<18
        colormap(handles.axes2, options{popmv2}); %set the colormap for tomography
    elseif popmv2==18
        myColorMap = jet(256); %colormap used for indexing, where 0 is white
        myColorMap(1,:) = 1;
        colormap(handles.axes2,myColorMap);
    end
    set(handles.edit2, 'String', num2str(floor(z2)));
elseif get(handles.checkbox2, 'Value') == 1 %if linking z axes
    data1=handles.data1;
    data2=handles.data2;
    z2=get(handles.slider2,'Value');
    imagesc(handles.axes1, data1(:,:,floor(z2)));
    caxis(  handles.axes1, [handles.data1min handles.data1max]);
    if popmv1<18
        colormap(handles.axes1, options{popmv1}); %set the colormap for tomography
    elseif popmv1==18
        myColorMap = jet(256); %colormap used for indexing, where 0 is white
        myColorMap(1,:) = 1;
        colormap(handles.axes1,myColorMap);
    end
    imagesc(handles.axes2, data2(:,:,floor(z2)));
    caxis(  handles.axes2, [handles.data2min handles.data2max]);
    if popmv2<18
        colormap(handles.axes2, options{popmv2}); %set the colormap for tomography
    elseif popmv2==18
        myColorMap = jet(256); %colormap used for indexing, where 0 is white
        myColorMap(1,:) = 1;
        colormap(handles.axes2,myColorMap);
    end
    set(handles.edit1, 'String', num2str(floor(z2)));
    set(handles.edit2, 'String', num2str(floor(z2)));
    set(handles.slider1, 'Value', z2);
end

if get(handles.checkbox1, 'Value') == 0 %if NOT linking xy axes
    linkaxes([handles.axes1,handles.axes2],'off')
elseif get(handles.checkbox1, 'Value') == 1 %if  linking xy axes
    set(handles.axes1, 'XLim', xlim);
    set(handles.axes1, 'YLim', ylim);
    set(handles.axes2, 'XLim', xlim);
    set(handles.axes2, 'YLim', ylim);
    linkaxes([handles.axes1,handles.axes2],'xy')
end



% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox1 Link XY
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%gets the xlim and ylim of image 1
if get(handles.checkbox1, 'Value') == 0 %if NOT linking xy axes
    linkaxes([handles.axes1,handles.axes2],'off')
elseif get(handles.checkbox1, 'Value') == 1 %if linking xy axes
    xlim = get(handles.axes1, 'XLim');
    ylim = get(handles.axes1, 'YLim');
    %links the axes
    set(handles.axes1, 'XLim', xlim);
    set(handles.axes1, 'YLim', ylim);
    set(handles.axes2, 'XLim', xlim);
    set(handles.axes2, 'YLim', ylim);
    linkaxes([handles.axes1,handles.axes2],'xy')
end


% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2 Link Z
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z1=str2double(get(handles.edit1,'string'));
data2=handles.data2;
popmv2=get(handles.popupmenu2,'Value'); %pop menu value popmv
options={'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', ... 
    'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'jetwhite'};

imagesc(handles.axes2, data2(:,:,floor(z1)));
caxis(  handles.axes2, [handles.data2min handles.data2max]);
if popmv2<18
        colormap(handles.axes2, options{popmv2}); %set the colormap for tomography
    elseif popmv2==18
        myColorMap = jet(256); %colormap used for indexing, where 0 is white
        myColorMap(1,:) = 1;
        colormap(handles.axes2,myColorMap);
end

set(handles.slider1, 'Value', z1);
set(handles.slider2, 'Value', z1);
set(handles.edit2, 'String', num2str(floor(z1)));
    


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
popmv=get(hObject,'Value'); %pop menu value popmv
options={'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', ... 
    'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'jetwhite'};
if popmv<18
    colormap(handles.axes1, options{popmv}); %set the colormap for tomography
elseif popmv==18
    myColorMap = jet(256); %colormap used for indexing, where 0 is white
    myColorMap(1,:) = 1;
    colormap(handles.axes1,myColorMap);
end

    






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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popmv=get(hObject,'Value'); %pop menu value popmv
options={'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', ... 
    'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'jetwhite'};
if popmv<18
    colormap(handles.axes2, options{popmv}); %set the colormap for tomography
elseif popmv==18
    myColorMap = jet(256); %colormap used for indexing, where 0 is white
    myColorMap(1,:) = 1;
    colormap(handles.axes2,myColorMap);
end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popmv1=get(handles.popupmenu1,'Value'); %pop menu value popmv
popmv2=get(handles.popupmenu2,'Value'); %pop menu value popmv
options={'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', ... 
    'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'jetwhite'};

z1=str2double(get(handles.edit1,'string'));
set(handles.slider1, 'Value', z1);

xlim = get(handles.axes1, 'XLim');
ylim = get(handles.axes1, 'YLim');

%get the data
data1=handles.data1;
data2=handles.data2;

%plot image1
imagesc(handles.axes1, data1(:,:,floor(z1)));
caxis(  handles.axes1, [handles.data1min handles.data1max]);
set(handles.edit1, 'String', num2str(floor(z1)));
if popmv1<18
    colormap(handles.axes1, options{popmv1}); %set the colormap for tomography
elseif popmv1==18
    myColorMap = jet(256); %colormap used for indexing, where 0 is white
    myColorMap(1,:) = 1;
    colormap(handles.axes1,myColorMap);
end

%plot image 2
if get(handles.checkbox2, 'Value') == 0 %if NOT linking z axes
    %do nothing
elseif get(handles.checkbox2, 'Value') == 1 %if linking z axes
    set(handles.slider2, 'Value', z1);
    set(handles.edit2, 'String', num2str(floor(z1)));
    imagesc(handles.axes2, data2(:,:,floor(z1)));
    caxis(  handles.axes2, [handles.data2min handles.data2max]);
    if popmv2<18
        colormap(handles.axes2, options{popmv2}); %set the colormap for tomography
    elseif popmv2==18
        myColorMap = jet(256); %colormap used for indexing, where 0 is white
        myColorMap(1,:) = 1;
        colormap(handles.axes2,myColorMap);
    end
end

if get(handles.checkbox1, 'Value') == 0 %if NOT linking xy axes
    linkaxes([handles.axes1,handles.axes2],'off')
elseif get(handles.checkbox1, 'Value') == 1 %if  linking xy axes
    set(handles.axes1, 'XLim', xlim);
    set(handles.axes1, 'YLim', ylim);
    set(handles.axes2, 'XLim', xlim);
    set(handles.axes2, 'YLim', ylim);
    linkaxes([handles.axes1,handles.axes2],'xy')
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popmv1=get(handles.popupmenu1,'Value'); %pop menu value popmv
popmv2=get(handles.popupmenu2,'Value'); %pop menu value popmv
options={'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', ... 
    'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag', 'jetwhite'};

xlim = get(handles.axes1, 'XLim');
ylim = get(handles.axes1, 'YLim');

if get(handles.checkbox2, 'Value') == 0 %if NOT linking z axes
    data2=handles.data2;
    z2=str2double(get(handles.edit2,'string'));
    set(handles.slider2, 'Value', z2);
    imagesc(handles.axes2, data2(:,:,floor(z2)));
    caxis(  handles.axes2, [handles.data2min handles.data2max]);
    if popmv2<18
        colormap(handles.axes2, options{popmv2}); %set the colormap for tomography
    elseif popmv2==18
        myColorMap = jet(256); %colormap used for indexing, where 0 is white
        myColorMap(1,:) = 1;
        colormap(handles.axes2,myColorMap);
    end
    set(handles.edit2, 'String', num2str(floor(z2)));
elseif get(handles.checkbox2, 'Value') == 1 %if linking z axes
    data1=handles.data1;
    data2=handles.data2;
    z2=str2double(get(handles.edit2,'string'));
    imagesc(handles.axes1, data1(:,:,floor(z2)));
    caxis(  handles.axes1, [handles.data1min handles.data1max]);
    if popmv1<18
        colormap(handles.axes1, options{popmv1}); %set the colormap for tomography
    elseif popmv1==18
        myColorMap = jet(256); %colormap used for indexing, where 0 is white
        myColorMap(1,:) = 1;
        colormap(handles.axes1,myColorMap);
    end
    imagesc(handles.axes2, data2(:,:,floor(z2)));
    caxis(  handles.axes2, [handles.data2min handles.data2max]);
    if popmv2<18
        colormap(handles.axes2, options{popmv2}); %set the colormap for tomography
    elseif popmv2==18
        myColorMap = jet(256); %colormap used for indexing, where 0 is white
        myColorMap(1,:) = 1;
        colormap(handles.axes2,myColorMap);
    end
    set(handles.edit1, 'String', num2str(floor(z2)));
    set(handles.edit2, 'String', num2str(floor(z2)));
    set(handles.slider1, 'Value', z2);
    set(handles.slider2, 'Value', z2);
end

if get(handles.checkbox1, 'Value') == 0 %if NOT linking xy axes
    linkaxes([handles.axes1,handles.axes2],'off')
elseif get(handles.checkbox1, 'Value') == 1 %if  linking xy axes
    set(handles.axes1, 'XLim', xlim);
    set(handles.axes1, 'YLim', ylim);
    set(handles.axes2, 'XLim', xlim);
    set(handles.axes2, 'YLim', ylim);
    linkaxes([handles.axes1,handles.axes2],'xy')
end
