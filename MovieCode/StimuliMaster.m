%Master code for all stimuli projection options
%Started 02/28/2025 by Anna Noll 
%Purpose of code is to compile all stimuli options into one easily
%controllable master code
%% Code setup 
%% Sync Test and Visual Bug settings 
Screen('Preference', 'SkipSyncTests', 2 ); 
Screen('Preference','VisualDebugLevel',1);  
Screen('Preference','SuppressAllWarnings',0);
%% Overall choice parameters 
global ScreenValue
    ScreenValue=0;
global WindowIndex
global windowRect
global Xpixels 
global Ypixels
global movie
global fps

[WindowIndex, windowRect] = Screen('OpenWindow', ScreenValue, [0 0 0]);
[Xpixels, Ypixels]=Screen('WindowSize',WindowIndex);
%% Movie parameters
fps=Screen('FrameRate',WindowIndex);
if fps==0
   fps=30;
end
movie=Screen('CreateMovie',WindowIndex,'movie_test_allStim2.mp4',[],[],fps);
%% all Stimuli
ContrastScreens=true;
Annulus=true;
MovingGrating=true; 
StationaryGrating=true; 

if ContrastScreens==true 
varyingContrastStimuli
end

if Annulus==true
annulusStim
end 

if MovingGrating==true
movingGrating 
end

if StationaryGrating==true
squaregratingStim
end 
Screen('FinalizeMovie', movie);
Screen('CloseAll')

%% End Stimulation and create mp4
