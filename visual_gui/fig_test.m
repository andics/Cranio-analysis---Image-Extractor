function varargout = fig_test(varargin)
% FIG_TEST MATLAB code for fig_test.fig
%      FIG_TEST, by itself, creates a new FIG_TEST or raises the existing
%      singleton*.
%
%      H = FIG_TEST returns the handle to a new FIG_TEST or the handle to
%      the existing singleton*.
%
%      FIG_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIG_TEST.M with the given input arguments.
%
%      FIG_TEST('Property','Value',...) creates a new FIG_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fig_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fig_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fig_test

% Last Modified by GUIDE v2.5 12-Oct-2018 23:41:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fig_test_OpeningFcn, ...
                   'gui_OutputFcn',  @fig_test_OutputFcn, ...
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


% --- Executes just before fig_test is made visible.
function fig_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fig_test (see VARARGIN)

% Choose default command line output for fig_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fig_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fig_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
