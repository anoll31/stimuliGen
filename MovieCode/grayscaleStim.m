%Anna Noll 
%GrayScale Stimulus Code 
%This code creates white screens with various grayscale values in order to
%calibrate the grayscale and resulting intensity 
%not tested yet! 

 % function grayscaleStim
%% Suppress Screen Warning
Screen('Preference', 'SkipSyncTests', 0);  
Screen('Preference','VisualDebugLevel',1);  
Screen('Preference','SuppressAllWarnings',0);
%% Set basic parameters
ScreenValue=2;


% Define the full-screen rectangle explicitly
% ScreenSizeRect = [0 0 screenXpixels screenYpixels];

[WindowIndex,WindowRect] = Screen('OpenWindow', ScreenValue,[0 0 0],[]);
% [screenXpixels, screenYpixels] = Screen('WindowSize', WindowIndex);

%% Define Grayscale Value Array
nValues=15;
grayValues=round(linspace(0,255,nValues));

%% Display White Intensity Screens
for i=1:length(grayValues)
Screen('FillRect',WindowIndex,[grayValues(i) grayValues(i) grayValues(i)]);
Screen('Flip', WindowIndex);
     KbWait([], 2); 
end 
Screen('CloseAll')
% end 