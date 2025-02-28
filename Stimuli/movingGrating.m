%Anna Noll 
% code to create squaregrating Stimuli (i.e stationary repeating bars of
% dark contrast)
function movingGrating
%% Suppress Screen Warning
Screen('Preference', 'SkipSyncTests', 2 ); 
Screen('Preference','VisualDebugLevel',1);  
Screen('Preference','SuppressAllWarnings',0);
%% Set basic parameters
repetitions=1; 
ScreenValue=0;
%Define the full-screen rectangle 
[WindowIndex,WindowRect] = Screen('OpenWindow', ScreenValue,[0 0 0],[]);
[Xpixels Ypixels]=Screen('WindowSize',WindowIndex)

%% Create Grating Function 
width=Xpixels; 
height=Ypixels; 
bgColorOffset=[0,0,0,0];

spatialFreq=1 /100; %1 cycles per 100 pixels 
contrast=1;
orientation=[0 45 90];
contrastMultiplicator=1;
[gratingid, gratingrect] =CreateProceduralSquareWaveGrating(WindowIndex, width, height, bgColorOffset,[], contrastMultiplicator);

%% Define phase limits
minPhase=0; 
maxPhase=360; 
stepPhase=10; 
repPhase=10 ;
%% for loop to animate
for i=1:repetitions
    for j=1:length(orientation)
        for k=1:repPhase
            for phase=minPhase:stepPhase:maxPhase
            Screen('DrawTexture', WindowIndex, gratingid, [], gratingrect, orientation(j), [], [], [], [], [], [phase, spatialFreq, contrast, 0])
            Screen('Flip',WindowIndex);
            end
        end
    end
end 
 KbWait;
 Screen('CloseAll')
end
