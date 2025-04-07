%Anna Noll
% code to create squaregrating Stimuli that moves and fills the screen.
% function movingfilledGrating
%% Suppress Screen Warning
clear;
Screen('Preference', 'SkipSyncTests', 0 );
Screen('Preference','VisualDebugLevel',1);
Screen('Preference','SuppressAllWarnings',0);
% Set basic parameters
repetitions=8;
screens=Screen('Screens');
ScreenValue=max(screens);

%Define the full-screen rectangle
[WindowIndex,WindowRect] = Screen('OpenWindow', ScreenValue,[0 0 0],[]);
[Xpixels Ypixels]=Screen('WindowSize',WindowIndex);

% % Initialize videowriter to save the frames as a video
% videoFilename = 'Stim6_driftGratinglog.mp4';
% OutputVideo = VideoWriter(videoFilename, 'MPEG-4');
% OutputVideo.FrameRate = 60;
% open(OutputVideo);
% desiredResolution = [0, 0, 1280, 800];

% Create Grating Function
width=2.5*Xpixels;
height=2.5*Ypixels;
bgColorOffset=[0,0,0,0];

spatialFreq=1 /40; %1 cycles per 100 pixels
contrast=1;
% orientation=[0 45 30 60 90 270 360 180];
orientation = [0 90 180 270];
contrastMultiplicator=1;
[gratingid, gratingrect] =CreateProceduralSquareWaveGrating(WindowIndex, width, height, bgColorOffset,[], contrastMultiplicator);

% Define phase limits
minPhase=0;
maxPhase=360;
stepPhase=10;
repPhase=5 ;
%% DMD light source
dmd = ur.cvs.DMDLightSource;
dmd.On_s = 195;
dmd.Off_s = 1;
dmd.Power_V = 0.35;
dmd.Iterations = 1;
%%
dmd.connect()
%%
dmd.start()
tic
while toc < 1.003  % Wait until 1.514 seconds have passed
end
% for loop to animate
all_time = [];
black_background_time = [];
for i=1:repetitions
    for j=1:length(orientation)
        startTime = GetSecs;

        numrep = 1;
        if i == 1 && j == 1
            numrep = 2;
        end
        for m = 1:numrep
            for k=1:repPhase
                for phase=minPhase:stepPhase:maxPhase
                    shiftedGratingRect= gratingrect + [-1000, -1600, -1300, -1000];
                    Screen('DrawTexture', WindowIndex, gratingid, [], shiftedGratingRect,orientation(j), [], [], [], [], [], [phase, spatialFreq, contrast, 0])
                    Screen('Flip',WindowIndex);

                    %                 % elapsedTime = GetSecs - startTime;
                    %                 img = Screen('GetImage', WindowIndex, desiredResolution);
                    %                 writeVideo(OutputVideo, img);
                end
                if k == repPhase
                    elapsedTime = GetSecs - startTime;
                    all_time = [all_time elapsedTime];
                end
            end

            % After the grating, show the dark background for 3 seconds
            backgroundStartTime = GetSecs;
            Screen('FillRect', WindowIndex, [0 0 0]);  % Fill screen with dark
            Screen('Flip', WindowIndex);
            startDarkTime = GetSecs;

            WaitSecs(3);  % Wait for 3 seconds with dark background
            %         while GetSecs - startDarkTime < 3
            %             frame = Screen('GetImage', WindowIndex, desiredResolution);
            %             writeVideo(OutputVideo, frame); % Add the dark background frame to the video
            %             Screen('Flip', WindowIndex); % Flip the screen again to create next frame
            %         end
        end
    end
end
% KbWait;
% close(OutputVideo);
Screen('CloseAll');
% end