%Anna Noll 
% code to create squaregrating Stimuli (i.e stationary repeating bars of
% dark contrast)
function movingGrating_fpsSpeed
%% Suppress Screen Warning
Screen('Preference', 'SkipSyncTests', 2 ); 
Screen('Preference','VisualDebugLevel',1);  
Screen('Preference','SuppressAllWarnings',0);
%% Global Values
% global ScreenValue
% global WindowIndex
% global windowRect
% global Xpixels 
% global Ypixels
% global movie 
% global fps 
%% Set basic parameters
repetitions=1; 
ScreenValue=0;
% %Define the full-screen rectangle 
[WindowIndex,WindowRect] = Screen('OpenWindow', ScreenValue,[0 0 0],[]);
[Xpixels Ypixels]=Screen('WindowSize',WindowIndex)
Duration=2;
%% Create Grating Function 
width=Xpixels; 
height=Ypixels; 
bgColorOffset=[0,0,0,0];

spatialFreq=1 /100; %1 cycles per 100 pixels 
contrast=1;
orientation=[0 90];
contrastMultiplicator=1;
[gratingid, gratingrect] =CreateProceduralSquareWaveGrating(WindowIndex, width, height, bgColorOffset,[], contrastMultiplicator);

%% Define phase limits
minPhase=0; 
maxPhase=360; 
stepPhase=10; 
repPhase=1 ;
%Storage for FPS and Speed Values 
fps_values=[]; 
speed_values=[];
orientation_duration=[];
%% for loop to animate
totalStartTime=GetSecs;
for i=1:repetitions
    for j=1:length(orientation)
        orientationStartTime=GetSecs;
        for k=1:repPhase

            timestamps=[];

            for phase=minPhase:stepPhase:maxPhase

            tstart=GetSecs;
            
            Screen('DrawTexture', WindowIndex, gratingid, [], gratingrect, orientation(j), [], [], [], [], [], [phase, spatialFreq, contrast, 0])
            Screen('Flip',WindowIndex);
            timestamps(end+1)=tstart;
             %Screen('AddFrameToMovie', WindowIndex, [],'frontBuffer', movie);
            end

            %fps calculation and speed calculation 
            if length(timestamps)>1
                frameIntervals=diff(timestamps); 
                avgFrameInterval=mean(frameIntervals); 
                current_fps=1/avgFrameInterval
            else
                current_fps=NaN; 
            end 
            pixels_cycle=1/spatialFreq;
            pixels_frame=(stepPhase/360)*pixels_cycle;
            speed_pixels_sec=pixels_frame*current_fps;
            speed_values(end+1)=speed_pixels_sec
        end
   Screen('FillRect',WindowIndex,[0 0 0])
   Screen('Flip', WindowIndex);
   
  % Screen('AddFrameToMovie', WindowIndex, [],'frontBuffer', movie,current_fps*Duration);
   WaitSecs(Duration) 
   orientationEndTime=GetSecs;
   orientationElapsed=orientationEndTime-orientationStartTime
   orientation_duration(end+1).orientation = orientation(j);
   orientation_duration(end).fps = current_fps;
   orientation_duration(end).speed_pixels_sec = speed_pixels_sec;
   orientation_duration(end).duration_sec = orientationElapsed;
   fprintf('Orientation %d completed in %.3f seconds\n', orientation(j), orientationElapsed)'; 
    end
end 
totalEndTime=GetSecs; 
totalElapsed=totalEndTime-totalStartTime;
fprintf('Total stimulation duration: %.3f seconds\n', totalElapsed);
save('grating_results.mat', 'orientation_duration');
Screen('CloseAll')
end

