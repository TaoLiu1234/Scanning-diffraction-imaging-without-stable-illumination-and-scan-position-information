function [ hFig ]    = Sim_gview( frameset, bigstep, title, op )
%fs_view  Simple GUI based on a standard Figure that allows a 3D dataset
%         (aka a frameset) to be viewed as a sequence of 2D image frames.
% GRM: 31/01/13
% GRM: 07/06/13 Modified code to give correct operation for single frames
% GRM: 29/08/13 Added input parameter fsname, to allow the user to specify
%                the string that appears in the title bar of the figure.
%                The default title will be 'fs_view'
%               New figures will now show the standard toolbar by default.
%               Callback function SliderFrameDisplay() now correctly
%                updates the min and max values dsiplaed for the curent
%                frame of the frameset.
%   Detailed explanation goes here
if (nargin<2)
    bigstep          = 17;
end

if (nargin<4)
    op               = 'none';
end
if ~iscell(frameset)
    frameset         = mat2cell_fc(frameset);
end
fs_name              = title;
hFig                 = figure( 'Name', fs_name, ...
    'Toolbar', 'figure', ...
    'IntegerHandle', 'off', ...
    'NumberTitle', 'off');
% Get size of frameset
[ pin]               = length( frameset);

% Create axes and reposition them to accommodate the frameset slider panel
%  with the position specified in normalized units inside the Figure
axes_posn            = [0, 0.25, 1, 0.7];
hAx                  = axes('Units','normalized', ...
    'Position', axes_posn); % [left, bottom, width, height]

% iptsetpref( 'ImshowAxesVisible', 'on');
% Display the first frame of the frameset,
frameno=1;
% Scale image contrast to fill the available range, and display in Figure
frame                = frameset{frameno};
switch op
    case {'phase', 'angle', 'phs'}
    frame            = angle(frame);
    case {'amp', 'abs', 'amplitude'}
    frame            = abs(frame);
end

hImage = imagesc( 'Cdata', frame, 'Parent', hAx, ...
    'Interruptible', 'off', ...
    'BusyAction', 'cancel');
axis image; axis tight; 
colormap('gray');
% axis xy
% Set the default colormap (it can be changed using the menu bars)
% colormap('bone');

% Create a Slider with a Text box above it
%  and place them both below the axes,
%  with positions specified in normalized units inside the Figure
slider_posn          = [0.2, 0.05, 0.6, 0.04]; % [left, bottom, width, height]
frametext_offset     = [0, 0.05, 0, 0];

hFrameInfo           = uicontrol( hFig, 'Style', 'text', ...
    'String', sprintf('Frame: %0d of %0d', frameno, pin), ...
    'Units', 'normalized', ...
    'Position', slider_posn + frametext_offset);

% Add a Pixel Information tool, specifying image as parent
hPixInfo             = impixelinfo( hImage);

% Add  a Display Range tool, specifying image as parent
hDispRange           = imdisplayrange( hImage);

% Check whether the image dataq are part of a multi-frame set
if (pin > 1)
    slider_max       = pin;
    %    slider_step= [1/(pin-1), 1/(sqrt(pin-1))];
    slider_step      = [1/(pin-1), bigstep/(pin-1)];
    
    % Add a slider to allow access to all frames of the set
    hFrameSlider     = uicontrol( hFig, 'Style', 'slider', ...
        'Min', 1, 'Max', slider_max, 'Value', frameno, ...
        'SliderStep', slider_step, ...
        'Units', 'normalized', ...
        'Position', slider_posn, ...
        'Interruptible', 'off', ...
        'BusyAction', 'cancel', ...
        'Callback', {@SliderFrameDisplay});
    
    % The callback function SliderFrameDisplay() is called automatically
    %  by the uicontrol above.
    % Otherwise, it can be called manually by uncommenting the next line
    %   hImage= SliderFrameDisplay( hFrameSlider, {}, hFrameInfo, hAx, frameset);
    %
end
set(hFig, 'HandleVisibility', 'off');
h.hFrameSlider       = hFrameSlider;
h.hDispRange         = hDispRange;
h.hPixInfo           = hPixInfo;
h.hFrameInfo         = hFrameInfo;
h.hImage             = hImage;
h.op                 = op;
h.hAx                = hAx;
h.hFig               = hFig;
h.frameset           = frameset;
guidata(hFig, h);

%
end

% The callback for the slider is a local function in the same file,
%  and will be called automatically following any slider event.
function [hImage]    = SliderFrameDisplay( hObject, event)
% The is functin will display the frame selected
%  when user moves the slider control,
%  and will update the on-screen information associated with that frame
%
h=guidata(hObject);
% Get size of frameset
[ pin]               = length( h.frameset);
% Check what frame has to be displayed from the frameset
frameno              = round( get( hObject, 'Value'));
% Print this information on the Figure window
% set( h.hFig, 'name', sprintf('Frame: %0d of %0d', frameno, pin));
set( h.hFrameInfo, 'String', sprintf('Frame: %0d of %0d', frameno, pin));

% Manually check the range of image data in the selected frame
frame                = h.frameset{frameno};

switch h.op
    case {'phase', 'angle', 'phs'}
    frame            = angle(frame);
    case {'amp', 'abs', 'amplitude'}
    frame            = abs(frame);
end
% frame = -1*frame;
set(h.hImage,'Cdata', frame);

end

function [ dp_cell ] = mat2cell_fc( dpm )
% to convert a 3d array into a cell along the 3rd dimension 
% the data may be the diffraction pattern in my experiment 
% e.g a [512x512x30] dp will be converted to a array of 30 element each is
% a 512 x512 matrix. 
% fucai 
dp_cell              = mat2cell(dpm, size(dpm,1), size(dpm,2), ones(size(dpm,3),1));
dp_cell              = squeeze(dp_cell);

end

