%Anna Noll 
%Varying contrast 

function varyingContrastStimuli
global ScreenValue
global WindowIndex
global windowRect
global Xpixels 
global Ypixels
global movie
global fps
% %% Suppress Screen Warning
% % Screen('Preference', 'SkipSyncTests', 0);  
% % Screen('Preference','VisualDebugLevel',1);  
% % Screen('Preference','SuppressAllWarnings',0);
% %% Set basic parameters
% ScreenValue=0;
% [WindowIndex,WindowRect] = Screen('OpenWindow', ScreenValue,[0 0 0],[]);

%% Specifications of Stimuli 
durationsBlack=[1 0.5 2]; %durations in seconds

durationsWhite=[1 0.5 2]; %durations in seconds

intensityFactors=[0 100 255]; %values between 0 to 255 

repetitions= 3; %repeat projection how many times 

%% For Loops to start Stimuli Projection 
for j=1:length(repetitions)
    for i=1:length(durationsWhite)
        Screen('FillRect',WindowIndex,[intensityFactors(i) intensityFactors(i) intensityFactors(i)]);
        Screen('Flip', WindowIndex);
        WaitSecs(durationsWhite(i));
        Screen('AddFrameToMovie', WindowIndex, [],'frontBuffer', movie,fps*durationsWhite(i));
        
        Screen('FillRect',WindowIndex,[0 0 0])
        Screen('Flip', WindowIndex);
        WaitSecs(durationsBlack(i));
        Screen('AddFrameToMovie', WindowIndex,[],'frontBuffer', movie),fps*durationsBlack(i);
    end 
end 

% Screen('CloseAll')
end
