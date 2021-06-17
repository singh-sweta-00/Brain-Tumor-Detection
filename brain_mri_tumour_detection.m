



function varargout = brain_mri_tumour_detection(varargin)
% BRAIN_MRI_TUMOUR_DETECTION MATLAB code for brain_mri_tumour_detection.fig
%      BRAIN_MRI_TUMOUR_DETECTION, by itself, creates a new BRAIN_MRI_TUMOUR_DETECTION or raises the existing
%      singleton*.
%
%      H = BRAIN_MRI_TUMOUR_DETECTION returns the handle to a new BRAIN_MRI_TUMOUR_DETECTION or the handle to
%      the existing singleton*.
%
%      BRAIN_MRI_TUMOUR_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRAIN_MRI_TUMOUR_DETECTION.M with the given input arguments.
%
%      BRAIN_MRI_TUMOUR_DETECTION('Property','Value',...) creates a new BRAIN_MRI_TUMOUR_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before brain_mri_tumour_detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to brain_mri_tumour_detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brain_mri_tumour_detection

% Last Modified by GUIDE v2.5 16-May-2021 10:23:42

% Begin initialization code - DO NOT EDIT
clc;

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @brain_mri_tumour_detection_OpeningFcn, ...
                   'gui_OutputFcn',  @brain_mri_tumour_detection_OutputFcn, ...
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


% --- Executes just before brain_mri_tumour_detection is made visible.
function brain_mri_tumour_detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to brain_mri_tumour_detection (see VARARGIN)

% Choose default command line output for brain_mri_tumour_detection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes brain_mri_tumour_detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = brain_mri_tumour_detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (sev e GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browsemriimage.
function browsemriimage_Callback(hObject, eventdata, handles)
% hObject    handle to browsemriimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1 img2

[path, nofile] = imgetfile();

if nofile
    msgbox(sprintf('Image not found!!!'),'Error','Warning');
    return
end

img1=imread(path);
img1=im2double(img1);
img2=img1;

axes(handles.axes2);
imshow(img1)

title('\fontsize{20}\color[rgb]{1,0,1} Brain MRI')



% --- Executes on button press in medianfiltering.
function medianfiltering_Callback(hObject, eventdata, handles)
% hObject    handle to medianfiltering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1
axes(handles.axes3)
if size(img1,3)==3
    img1=rgb2gray(img1);
end
K=medfilt2(img1);
axes(handles.axes3);
imshow(K);
title('\fontsize{20}\color[rgb]{1,0,1} Med Filter');


% --- Executes on button press in edgedetection.
function edgedetection_Callback(hObject, eventdata, handles)
% hObject    handle to edgedetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1
axes(handles.axes6);

if size(img1,3)==3
    img1=rgb2gray(img1);
end
K=medfilt2(img1);
C=double(K);

for i=1:size(C,1)-2
    for j=1:size(C,2)-2
        %Sobel mask for x-direction
        Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
        %Sobel mask for y-direction
        Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
        
        %The Gradient of the image
        %B(i,j)=abs(Gx)+abs(Gy)
        B(i,j)=sqrt(Gx.^2+Gy.^2);
        
    end
end
axes(handles.axes6)
imshow(B);title('\fontsize{20}\color[rgb]{1,0,1} Edge Detection');     


% --- Executes on button press in segmentation.
function segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1
axes(handles.axes7)

if size(img1,3)==3
    img1=rgb2gray(img1);
    img1=medfilt2(img1);
    
end

imData=reshape(img1,[],1);
imData=double(imData);
[IDX nn]=kmeans(imData,4);
imIDX=reshape(IDX,size(img1));

% 
% figure,
% subplot(3,2,1), imshow(imIDX==1,[]);
% subplot(3,2,2), imshow(imIDX==2,[]);
% subplot(3,2,3), imshow(imIDX==3,[]);
% subplot(3,2,4), imshow(imIDX==4,[]);

% model={'Choose Image which is showing accurate segmented area'};
% data=inputdlg(model);
% % codata=char(data);
% 
% bw=(imIDX==char(data));
bw=(imIDX==1);
se=ones(5);
bw=imopen(bw,se);
bw=bwareaopen(bw,400);
axes(handles.axes7)
imshow(bw);title('\fontsize{20}\color[rgb]{1,0,1} Segmentation'); 


% --- Executes on button press in tumourdetection.
function tumourdetection_Callback(hObject, eventdata, handles)
% hObject    handle to tumourdetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1
axes(handles.axes8);
K=medfilt2(img1);
bw=im2bw(K, 0.7);
label=bwlabel(bw);

stats=regionprops(label,'Solidity','Area');
density=[stats.Solidity];
area=[stats.Area];
high_dense_area=density>0.5;
max_area=max(area(high_dense_area));
tumour_label=find(area==max_area);
tumour=ismember(label,tumour_label);

if max_area>500
   se=strel('square',5);
tumour=imdilate(tumour,se);
tumour=imopen(tumour,se);

Bound=bwboundaries(tumour,'noholes');

imshow(K);
hold on

for i=1:length(Bound)
    plot(Bound{i}(:,2),Bound{i}(:,1),'y','linewidth',1.75)
end

title('\fontsize{20}\color[rgb]{1,0,1} Tumor Detected !!!');
else
    h = msgbox('No Tumor!!','status');
    %disp('no tumor');
    return;
end


hold off
axes(handles.axes8)


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2,'reset');
cla(handles.axes3,'reset');
cla(handles.axes6,'reset');
cla(handles.axes7,'reset');
cla(handles.axes8,'reset');
