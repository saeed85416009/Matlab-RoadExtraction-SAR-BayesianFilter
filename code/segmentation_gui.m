% 
% damage_analysis - A GUI for Matlab that interfaces with EDISON to
% aid the analysis of shell dissolutions.
% Copyright (C) 2009  Roberto Montagna
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 

function varargout = segmentation_gui(varargin)
% SEGMENTATION_GUI M-file for segmentation_gui.fig
%      SEGMENTATION_GUI, by itself, creates a new SEGMENTATION_GUI or raises the existing
%      singleton*.
%
%      H = SEGMENTATION_GUI returns the handle to a new SEGMENTATION_GUI or the handle to
%      the existing singleton*.
%
%      SEGMENTATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTATION_GUI.M with the given input arguments.
%
%      SEGMENTATION_GUI('Property','Value',...) creates a new SEGMENTATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segmentation_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmentation_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segmentation_gui

% Last Modified by GUIDE v2.5 22-Apr-2009 21:37:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segmentation_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @segmentation_gui_OutputFcn, ...
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


% --- Executes just before segmentation_gui is made visible.
function segmentation_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmentation_gui (see VARARGIN)

% Choose default command line output for segmentation_gui
handles.output = hObject;

startup;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segmentation_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = segmentation_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in damType0.
function damType0_Callback(hObject, eventdata, handles)
% hObject    handle to damType0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of damType0

global lab areas segm hseg dam0area;

status = get(hObject,'Value');

if (status == 1)
	set(handles.damType1,'Value',0);
	set(handles.damType2,'Value',0);
	set(handles.damType3,'Value',0);
	set(handles.noDam,'Value',0);
	
	% Select the points from the figure.
	figure(hseg);
	[x y] = ginput;
	
	nsel = length(x);
	
	if (nsel == 0)
		return;
	end
	
	% Labels of the selected pixels.
	sel_lab = zeros(nsel,1);
	
	for i=1:nsel
		sel_lab(i) = lab(round(y(i)),round(x(i)));
	end
	
	% Avoid multiple selections of the same label.
	sel_lab = unique(sel_lab);
	nsel = length(sel_lab);
	
	% Get the largest area of the selected ones. That will give the label
	% and the colour for all the other that have been selected.
	largestarea = max(areas(sel_lab+1));
	maxind = find(areas == largestarea);
	
	% Get the grey value.
	%gval = unique(segm(lab == maxind(1)-1));
	% Split the image in rgb
	rsegm = segm(:,:,1);
	gsegm = segm(:,:,2);
	bsegm = segm(:,:,3);
	
	for i=1:nsel
		% if the area has been set to 0, it means that the region has been selected already
		if (areas(sel_lab(i)+1) == 0)
			continue;
		end
		dam0area = dam0area + areas(sel_lab(i)+1);
		areas(sel_lab(i)+1) = 0;
		dam0lab = lab == sel_lab(i);
		rsegm(dam0lab) = 0;
		gsegm(dam0lab) = 1;
		bsegm(dam0lab) = 1;
	end
	
	segm = cat(3,rsegm,gsegm,bsegm);
	imshow(segm);
	
elseif (status == 0)
	set(hObject,'Value',1);
end


% --- Executes on button press in damType1.
function damType1_Callback(hObject, eventdata, handles)
% hObject    handle to damType1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of damType1

global lab areas segm hseg dam1area;

status = get(hObject,'Value');

if (status == 1)
	set(handles.damType0,'Value',0);
	set(handles.damType2,'Value',0);
	set(handles.damType3,'Value',0);
	set(handles.noDam,'Value',0);
	figure(hseg);
	[x y] = ginput;
	
	nsel = length(x);
	
	if (nsel == 0)
		return;
	end
	
	sel_lab = zeros(nsel,1);
	
	for i=1:nsel
		sel_lab(i) = lab(round(y(i)),round(x(i)));
	end
	
	sel_lab = unique(sel_lab);
	nsel = length(sel_lab);
	
	largestarea = max(areas(sel_lab+1));
	maxind = find(areas == largestarea);
	
	%gval = unique(segm(lab == maxind(1)-1));
	rsegm = segm(:,:,1);
	gsegm = segm(:,:,2);
	bsegm = segm(:,:,3);
	
	for i=1:nsel
		if (areas(sel_lab(i)+1) == 0)
			continue;
		end
		dam1area = dam1area + areas(sel_lab(i)+1);
		areas(sel_lab(i)+1) = 0;
		dam1lab = lab == sel_lab(i);
		rsegm(dam1lab) = 1;
		gsegm(dam1lab) = 1;
		bsegm(dam1lab) = 0;
	end
	
	segm = cat(3,rsegm,gsegm,bsegm);
	imshow(segm);
elseif (status == 0)
	set(hObject,'Value',1);
end


% --- Executes on button press in damType2.
function damType2_Callback(hObject, eventdata, handles)
% hObject    handle to damType2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of damType2

global lab areas segm hseg dam2area;

status = get(hObject,'Value');

if (status == 1)
	set(handles.damType0,'Value',0);
	set(handles.damType1,'Value',0);
	set(handles.damType3,'Value',0);
	set(handles.noDam,'Value',0);
	figure(hseg);
	[x y] = ginput;
	
	nsel = length(x);
	
	if (nsel == 0)
		return;
	end
	
	sel_lab = zeros(nsel,1);
	
	for i=1:nsel
		sel_lab(i) = lab(round(y(i)),round(x(i)));
	end
	
	sel_lab = unique(sel_lab);
	nsel = length(sel_lab);
	
	largestarea = max(areas(sel_lab+1));
	maxind = find(areas == largestarea);
	
	%gval = unique(segm(lab == maxind(1)-1));
	rsegm = segm(:,:,1);
	gsegm = segm(:,:,2);
	bsegm = segm(:,:,3);
	
	for i=1:nsel
		if (areas(sel_lab(i)+1) == 0)
			continue;
		end
		dam2area = dam2area + areas(sel_lab(i)+1);
		areas(sel_lab(i)+1) = 0;
		dam2lab = lab == sel_lab(i);
		rsegm(dam2lab) = 1;
		gsegm(dam2lab) = 0.5;
		bsegm(dam2lab) = 0;
	end
	
	segm = cat(3,rsegm,gsegm,bsegm);
	imshow(segm);
elseif (status == 0)
	set(hObject,'Value',1);
end


% --- Executes on button press in damType3.
function damType3_Callback(hObject, eventdata, handles)
% hObject    handle to damType3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of damType3

global lab areas segm hseg dam3area;

status = get(hObject,'Value');

if (status == 1)
	set(handles.damType0,'Value',0);
	set(handles.damType1,'Value',0);
	set(handles.damType2,'Value',0);
	set(handles.noDam,'Value',0);
	figure(hseg);
	[x y] = ginput;
	
	nsel = length(x);
	
	if (nsel == 0)
		return;
	end
	
	sel_lab = zeros(nsel,1);
	
	for i=1:nsel
		sel_lab(i) = lab(round(y(i)),round(x(i)));
	end
	
	sel_lab = unique(sel_lab);
	nsel = length(sel_lab);
	
	largestarea = max(areas(sel_lab+1));
	maxind = find(areas == largestarea);
	
	%gval = unique(segm(lab == maxind(1)-1));
	rsegm = segm(:,:,1);
	gsegm = segm(:,:,2);
	bsegm = segm(:,:,3);
	
	for i=1:nsel
		if (areas(sel_lab(i)+1) == 0)
			continue;
		end
		dam3area = dam3area + areas(sel_lab(i)+1);
		areas(sel_lab(i)+1) = 0;
		dam3lab = lab == sel_lab(i);
		rsegm(dam3lab) = 1;
		gsegm(dam3lab) = 0;
		bsegm(dam3lab) = 0;
	end
	
	segm = cat(3,rsegm,gsegm,bsegm);
	imshow(segm);
elseif (status == 0)
	set(hObject,'Value',1);
end


% --- Executes on button press in noDam.
function noDam_Callback(hObject, eventdata, handles)
% hObject    handle to noDam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noDam

global lab areas segm hseg nodamarea;

status = get(hObject,'Value');

if (status == 1)
	set(handles.damType0,'Value',0);
	set(handles.damType1,'Value',0);
	set(handles.damType2,'Value',0);
	set(handles.damType3,'Value',0);
	figure(hseg);
	[x y] = ginput;
	
	nsel = length(x);
	
	if (nsel == 0)
		return;
	end
	
	sel_lab = zeros(nsel,1);
	
	for i=1:nsel
		sel_lab(i) = lab(round(y(i)),round(x(i)));
	end
	
	sel_lab = unique(sel_lab);
	nsel = length(sel_lab);
	
	largestarea = max(areas(sel_lab+1));
	maxind = find(areas == largestarea);
	
	%gval = unique(segm(lab == maxind(1)-1));
	rsegm = segm(:,:,1);
	gsegm = segm(:,:,2);
	bsegm = segm(:,:,3);
	
	for i=1:nsel
		if (areas(sel_lab(i)+1) == 0)
			continue;
		end
		nodamarea = nodamarea + areas(sel_lab(i)+1);
		areas(sel_lab(i)+1) = 0;
		nodamlab = lab == sel_lab(i);
		rsegm(nodamlab) = 0;
		gsegm(nodamlab) = 1;
		bsegm(nodamlab) = 0;
	end
	
	segm = cat(3,rsegm,gsegm,bsegm);
	imshow(segm);
elseif (status == 0)
	set(hObject,'Value',1);
end


% --- Executes on button press in nextButton.
function nextButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global imgdir tiffiles ltif i_counter lab areas segm hseg him imarea dam0area dam1area dam2area dam3area nodamarea alltogether;

set(hObject,'Enable','off');

try
	close(hseg);
catch
end

try
	close(him);
catch
end

if (i_counter > 1)
	fid = fopen([fullfile(imgdir,tiffiles(i_counter-1).name), '.csv'],'w');
	fprintf(fid,'No damage,Damage type 0,Damage type 1,Damage type 2, Damage type 3\n');
	alltogether(i_counter-1,1) = nodamarea/imarea;
	alltogether(i_counter-1,2) = dam0area/imarea;
	alltogether(i_counter-1,3) = dam1area/imarea;
	alltogether(i_counter-1,4) = dam2area/imarea;
	alltogether(i_counter-1,5) = dam3area/imarea;
	%disp(sprintf('"%g","%g","%g","%g","%g"\n',nodamarea/imarea,dam0area/imarea,dam1area/imarea,dam2area/imarea,dam3area/imarea));
	fprintf(fid,'"%g","%g","%g","%g","%g"\n',nodamarea/imarea,dam0area/imarea,dam1area/imarea,dam2area/imarea,dam3area/imarea);
	fclose(fid);
end

if (i_counter > ltif)
	close(handles.seg_gui);
	fid = fopen(fullfile(imgdir, 'thisfolder.csv'),'w');
	fprintf(fid,' ,No damage,Damage type 0,Damage type 1,Damage type 2, Damage type 3\n');
	for i=1:ltif
		fprintf(fid,'"%s",%g,%g,%g,%g,%g\n',tiffiles(i).name,alltogether(i,1),alltogether(i,2),alltogether(i,3),alltogether(i,4),alltogether(i,5));
	end
	fclose(fid);
	display('****** Every image has been processed!');
	clear global imgdir tiffiles ltif i_counter lab areas segm hseg him imarea dam0area dam1area dam2area dam3area nodamarea;
	disp('Type:');
	disp('global alltogether');
	disp('in order to access the data collected.');
	return;
end

nodamarea = 0;
dam0area = 0;
dam1area = 0;
dam2area = 0;
dam3area = 0;

set(handles.minarea,'String','0');
set(handles.edgetresh,'String','0.3');
set(handles.resegment,'Enable','off');
set(handles.damType0,'Enable','off');
set(handles.damType1,'Enable','off');
set(handles.damType2,'Enable','off');
set(handles.damType3,'Enable','off');
set(handles.noDam,'Enable','off');
snail = imread(fullfile(imgdir, tiffiles(i_counter).name));
im = repmat(double(snail)/255,[1 1 3]);
fprintf('Segmenting image %s... ', tiffiles(i_counter).name);
[imseg lab mod areas] = edison_wrapper(im,@RGB2Luv);
fprintf('done.\n');
areas = double(areas);
segm = Luv2RGB(imseg);
%segm = segm(:,:,1);
imarea = sum(areas);
him = figure;
imshow(im);
hseg = figure;
imshow(segm);
set(handles.resegment,'Enable','on');
set(handles.damType0,'Enable','on');
set(handles.damType1,'Enable','on');
set(handles.damType2,'Enable','on');
set(handles.damType3,'Enable','on');
set(handles.noDam,'Enable','on');

set(hObject,'Enable','on');

i_counter = i_counter + 1;



function startup

global imgdir tiffiles ltif i_counter alltogether;

imgdir = uigetdir;

if (imgdir == 0)
	error('You need to select a directory containing tif files to process.');
end

tiffiles = dir(fullfile(imgdir, '*.tif'));
ltif = length(tiffiles);

alltogether = zeros(ltif, 5);

disp(sprintf('Processing %d files in folder %s.', ltif, imgdir));

if (ltif < 1)
	error('No TIF files found in the selected directory!');
end

i_counter = 1;



function minarea_Callback(hObject, eventdata, handles)
% hObject    handle to minarea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minarea as text
%        str2double(get(hObject,'String')) returns contents of minarea as a double

minareasize = str2double(get(hObject,'String'));

if (isnan(minareasize) || minareasize < 0)
	set(hObject, 'String', '0');
	minareasize = 0;
end

% --- Executes during object creation, after setting all properties.
function minarea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minarea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edgetresh_Callback(hObject, eventdata, handles)
% hObject    handle to edgetresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edgetresh as text
%        str2double(get(hObject,'String')) returns contents of edgetresh as a double

threshold = str2double(get(hObject,'String'));

if (isnan(threshold) || threshold < 0)
	set(hObject, 'String', '0.3');
	threshold = 0.3;
end


% --- Executes during object creation, after setting all properties.
function edgetresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edgetresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resegment.
function resegment_Callback(hObject, eventdata, handles)
% hObject    handle to resegment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global imgdir tiffiles ltif i_counter lab areas segm hseg him imarea dam0area dam1area dam2area dam3area nodamarea alltogether;

set(hObject,'Enable','off');

try
	close(hseg);
catch
end

try
	close(him);
catch
end

nodamarea = 0;
dam0area = 0;
dam1area = 0;
dam2area = 0;
dam3area = 0;

set(handles.nextButton,'Enable','off');
set(handles.damType0,'Enable','off');
set(handles.damType1,'Enable','off');
set(handles.damType2,'Enable','off');
set(handles.damType3,'Enable','off');
set(handles.noDam,'Enable','off');
snail = imread(fullfile(imgdir, tiffiles(i_counter-1).name));
im = repmat(double(snail)/255,[1 1 3]);
threshold = getThreshold(handles.edgetresh);
minareasize = getMinArea(handles.minarea);
fprintf('Re-segmenting image %s... ', tiffiles(i_counter-1).name);
[imseg lab mod areas] = edison_wrapper(im,@RGB2Luv,'MinimumRegionArea',minareasize,'EdgeStrengthThreshold',threshold);
fprintf('done.\n');
areas = double(areas);
segm = Luv2RGB(imseg);
%segm = segm(:,:,1);
imarea = sum(areas);
him = figure;
imshow(im);
hseg = figure;
imshow(segm);
set(handles.nextButton,'Enable','on');
set(handles.damType0,'Enable','on');
set(handles.damType1,'Enable','on');
set(handles.damType2,'Enable','on');
set(handles.damType3,'Enable','on');
set(handles.noDam,'Enable','on');

set(hObject,'Enable','on');


function thresh = getThreshold(object)

thresh = str2double(get(object,'String'));

if (isnan(thresh) || thresh < 0)
	thresh = 0.3;
end

function minsize = getMinArea(object)

minsize = str2double(get(object,'String'));

if (isnan(minsize) || minsize < 0)
	minsize = 0;
end
