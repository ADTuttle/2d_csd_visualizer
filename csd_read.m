function varargout = csd_read(varargin)
% CSD_READ MATLAB code for csd_read.fig
%      CSD_READ, by itself, creates a new CSD_READ or raises the existing
%      singleton
%
%      H = CSD_READ returns the handle to a new CSD_READ or the handle to
%      the existing singleton*.
%
%      CSD_READ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSD_READ.M with the given input arguments.
%
%      CSD_READ('Property','Value',...) creates a new CSD_READ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before csd_read_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to csd_read_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help csd_read

% Last Modified by GUIDE v2.5 26-Sep-2016 18:56:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @csd_read_OpeningFcn, ...
                   'gui_OutputFcn',  @csd_read_OutputFcn, ...
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


% --- Executes just before csd_read is made visible.
function csd_read_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to csd_read (see VARARGIN)

% Choose default command line output for csd_read
handles.output = hObject;

global stop_this;
stop_this=0;
set(handles.play,'Enable','off')
set(handles.Ions,'Enable','off')
set(handles.comparts,'Enable','off')
set(handles.stop,'Enable','off')
set(handles.progress,'Enable','off')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes csd_read wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = csd_read_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadf.
function loadf_Callback(hObject, eventdata, handles)
% hObject    handle to loadf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [FileName,PathName,~] = uigetfile('../*.txt');
[FileName,PathName,~] = uigetfile('../../C_Progs/2d_CSD/cmake-build-debug/*.txt');

f=fopen(strcat(PathName,FileName));
% f=fopen('/Users/Austin/Documents/MATLAB/2d_csd/test.txt');
header=textscan(f,'%d,%d,%d,%d,%d',1);
fclose(f);
[Nx,Ny,Nt,Nc,Ni]=header{1:5};
A=dlmread(strcat(PathName,FileName),',',1,0);

if(Nc==0 && Ni==0)
   one_var = true;
   Ni=1;
   Nc=1;
else
    one_var= false; 
end

c=zeros(Nx,Ny,Nc,Ni,Nt);
phi=zeros(Nx,Ny,Nc,Nt);
al=zeros(Nx,Ny,Nc-1,Nt);

if(one_var)
ind=1;
for t=1:Nt
    for j=1:Ni
        for i=1:Nc
            c(:,:,i,j,t)=reshape(A(ind,:),Nx,Ny);
            ind=ind+1;
        end
    end
    
    for j=1:Nc
        phi(:,:,j,t)=c(:,:,i,j,t);
    end
    for j=1:Nc-1
        al(:,:,j,t)=c(:,:,i,j,t);
    end
end
else
    ind=1;
for t=1:Nt
    for j=1:Ni
        for i=1:Nc
            c(:,:,i,j,t)=reshape(A(ind,:),Nx,Ny);
            ind=ind+1;
        end
    end
    
    for j=1:Nc
        phi(:,:,j,t)=reshape(A(ind,:),Nx,Ny);
        ind=ind+1;
    end
    for j=1:Nc-1
        al(:,:,j,t)=reshape(A(ind,:),Nx,Ny);
        ind=ind+1;
    end
end
end
% c=zeros(Nx,Ny,Nc,Ni,Nt);
% ind=1;
% for t=1:Nt
%     for j=1:Ni
%         for i=1:Nc
%             c(:,:,i,j,t)=reshape(A(ind,:),Nx,Ny);
%             ind=ind+1;
%         end
%     end
% end
% phi=zeros(Nx,Ny,Nc,Nt);
% for t=1:Nt
%     for j=1:Nc
%         phi(:,:,j,t)=reshape(A(ind,:),Nx,Ny);
%         ind=ind+1;
%     end
% end
% al=zeros(Nx,Ny,Nc-1,Nt);
% for t=1:Nt
%     for j=1:Nc-1
%         al(:,:,j,t)=reshape(A(ind,:),Nx,Ny);
%         ind=ind+1;
%     end
% end

set(handles.comparts,'String',1:Nc); %Load comparts
set(handles.Ions,'String',1:Ni); %Ions
set(handles.loadf,'UserData',{c,phi,al,header}); %Pass the data
%Enable buttons
set(handles.play,'Enable','on')
set(handles.Ions,'Enable','on')
set(handles.comparts,'Enable','on')
set(handles.stop,'Enable','on')
set(handles.progress,'Enable','on')


% --- Executes on selection change in cpal.
function cpal_Callback(hObject, eventdata, handles)
% hObject    handle to cpal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cpal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cpal


% --- Executes during object creation, after setting all properties.
function cpal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in comparts.
function comparts_Callback(hObject, eventdata, handles)
% hObject    handle to comparts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comparts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comparts


% --- Executes during object creation, after setting all properties.
function comparts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comparts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Ions.
function Ions_Callback(hObject, eventdata, handles)
% hObject    handle to Ions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Ions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Ions


% --- Executes during object creation, after setting all properties.
function Ions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop;
choice=get(handles.cpal,'Value');
data=get(handles.loadf,'UserData');
[Nx,Ny,Nt,Nc,Ni]=data{4}{1:5};
ion=get(handles.Ions,'Value');
comp=get(handles.comparts,'Value');
stop=0;
prog=get(handles.progress,'Value');
start_time=floor(Nt*prog);
if start_time<2
   start_time=2; 
end
if choice==1
    c=data{1};
    v=linspace(min(min(min(c(:,:,comp,ion,:)))),max(max(max(c(:,:,comp,ion,:)))),100);
    [~,cfig]=contourf(c(:,:,comp,ion,start_time),v,'linestyle','none');
    colormap jet
    caxis([min(v),max(v)])
    colorbar
    for i=start_time:Nt
        if mod(i,10)==0 %Make the progress bar move
            set(handles.progress,'Value',double(i)/double(Nt));
        end
        cfig.ZData=c(:,:,comp,ion,i);
        if stop %If they press stop, stop.
            break
        end
        guidata(hObject,handles);
        drawnow
        %Code to write to a gif called test.gif
%         frame = getframe;
%         im = frame2im(frame);
%         [imind,cm] = rgb2ind(im,256);
%         if i == start_time
%             imwrite(imind,cm,'test.gif','gif', 'Loopcount',inf,'DelayTime',.1);
%         else
%             imwrite(imind,cm,'test.gif','gif','WriteMode','append','DelayTime',.1);
%         end
        pause(.001)
    end
elseif choice==3
    al=data{3};
    v=linspace(min(min(min(al(:,:,comp,:)))),max(max(max(al(:,:,comp,:)))),100);
    [~,cfig]=contourf(al(:,:,comp,start_time),v,'linestyle','none');
    colormap jet
    caxis([min(v),max(v)])
    colorbar
    for i=start_time:Nt
        if mod(i,10)==0 %Make the progress bar move
           set(handles.progress,'Value',double(i)/double(Nt));
        end
        cfig.ZData=al(:,:,comp,i);
        if stop %If they press stop, stop.
            break
        end
        drawnow
        pause(.001)
    end
else
    phi=data{2};
    v=linspace(min(min(min(phi(:,:,comp,:)))),max(max(max(phi(:,:,comp,:)))),100);
    [~,cfig]=contourf(phi(:,:,comp,start_time),v,'linestyle','none');
    colormap jet
    caxis([min(v),max(v)])
    colorbar
    for i=start_time:Nt
        if mod(i,10)==0 %Make the progress bar move
           set(handles.progress,'Value',double(i)/double(Nt));
        end
        cfig.ZData=phi(:,:,comp,i);
        if stop %If they press stop, stop.
            break
        end
        drawnow
        pause(.001)
    end
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.stop,'Value',1);
global stop;
stop=1;
drawnow;
guidata(hObject,handles);


% --- Executes on slider movement.
function progress_Callback(hObject, eventdata, handles)
% hObject    handle to progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global stop;
stop=1;
drawnow;
guidata(hObject,handles);
play_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function progress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
