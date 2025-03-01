%% Supress tests 
function annulusStim
global WindowIndex
global windowRect
global ScreenValue
global Xpixels 
global Ypixels
global fps
global movie
% Screen('Preference', 'SkipSyncTests', 2 ); 
% Screen('Preference','VisualDebugLevel',1);  
% Screen('Preference','SuppressAllWarnings',0);
% ScreenValue=0;
% [window, windowRect] = Screen('OpenWindow', ScreenValue, [0 0 0]); % Gray background
stimDuration=2;
% Define annulus parameters
centerX = windowRect(3)/2;
centerY = windowRect(4)/2;
outerRadius = 10;
% innerRadius = 95;
color = [255 255 255]; % White

% Draw the annulus using FrameOval
penWidth = 5; % Thickness of the annulus
for i=0:50 
    newRadius=outerRadius+penWidth*2*i;
% Screen('FrameOval', window, color, ...
%     [centerX - outerRadius, centerY - outerRadius, centerX + outerRadius, centerY + outerRadius], ...
%     penWidth);
Screen('FrameOval', WindowIndex, color, ...
    [centerX - newRadius, centerY - newRadius, centerX + newRadius, centerY + newRadius], ...
    penWidth);
end 
Screen('Flip', WindowIndex);
WaitSecs(stimDuration);
Screen('AddFrameToMovie', WindowIndex,[],'frontBuffer', movie,fps*stimDuration)
% Wait for key press
% KbWait;
% Screen('CloseAll');
end 