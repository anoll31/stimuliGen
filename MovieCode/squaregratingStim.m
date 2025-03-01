%Anna Noll 
% code to create squaregrating Stimuli (i.e stationary repeating bars of
% dark contrast)
function squaregratingStim
global ScreenValue
    ScreenValue=0;
global WindowIndex
global windowRect
global Xpixels 
global Ypixels
global movie
global fps
%% Suppress Screen Warning
% Screen('Preference', 'SkipSyncTests', 0); 
% Screen('Preference','VisualDebugLevel',1);  
% Screen('Preference','SuppressAllWarnings',0);
% %% Set basic parameters
%  ScreenValue=0;
% %Define the full-screen rectangle 
% [WindowIndex,WindowRect] = Screen('OpenWindow', ScreenValue,[0 0 0],[]);
% [Xpixels Ypixels]=Screen('WindowSize',WindowIndex)
%%
%% Create Grating Function 
width= Xpixels; 
height=Ypixels; 
bgColorOffset=[0,0,0,0];

spatialFreq=1/100; %1 cycles per 100 pixels 
contrast=[1, 0, 0.25] ;
phase=0; 
orientation=0;
contrastMultiplicator=1;
stimDurations=[2,2,2];
Duration=2;
[gratingid, gratingrect] =CreateProceduralSquareWaveGrating(WindowIndex, width, height, bgColorOffset,[], contrastMultiplicator);

%% Animation
for i=1:length(contrast)
Screen('DrawTexture', WindowIndex, gratingid, [], gratingrect, orientation, [], [], [], [], [], [phase, spatialFreq, contrast(i) , 0])
Screen('Flip',WindowIndex);
WaitSecs(stimDurations(i))
Screen('AddFrameToMovie', WindowIndex, [],'frontBuffer', movie,fps*stimDurations(i))
Screen('FillRect',WindowIndex,[0 0 0])
Screen('Flip', WindowIndex);
Screen('AddFrameToMovie', WindowIndex, [],'frontBuffer', movie,fps*Duration)
WaitSecs(Duration)
end 

end 
