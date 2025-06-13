 % Stimulus 1: increasing intensity of lights 1s ON 1s OFF
% log scale, repeat the whole sequence 10 times
sca; 
clear all;
Screen('Preference', 'SkipSyncTests', 1)
%Initialize the screen
screenid = max(Screen('Screens')); % Use the external screen
[window, rect] = Screen('OpenWindow', screenid, [0, 0, 0]); 

% Get screen resolution
[scrX, scrY] = Screen('WindowSize', window);

white = 255;
black = 0;
gray = round((white + black) / 2);

load LUT_normalized.mat;  %REMEMBER TO LOAD THE GAMMA TABLE!!!!!!
originalCLUT = Screen('LoadNormalizedGammaTable', window, RGB_normalized);

nIntensities = 9;  % Number of different intensity levels
intensities = round(linspace(1, 255, nIntensities));  % Define the intensity levels
% intensities = round(logspace(log10(1),log10(255),nIntensities));
% intensities = [255,255,255,255,255,255,255,255,255];
bkgDuration = 1;  % Duration of background between intensities
frameDuration = 1;  % Duration of each frame (1 second)
repetitions = 8; % repeat the whole intensity sequence x times

stimulusSequence = [];
startTime = GetSecs;
nextFrameTime = startTime;  % Initialize the next frame time

grayscale_time = [];  
black_background_time = [];

 %DMD light source
dmd = ur.cvs.DMDLightSource;
dmd.On_s = 144; % this number depends on stimuli duration
dmd.Off_s = 1;
dmd.Power_V = 0.35;
dmd.Iterations = 1;
dmd.Led = 4;

%%
dmd.connect()
pause(5)
%%

ifi = Screen('GetFlipInterval', window);  % Inter-frame interval (e.g., ~0.0167 s for 60 Hz)
waitFrames = round(frameDuration / ifi);    % How many frames = 1 second

% vbl = Screen('Flip', window); 

% dmd.start()
dmd.start_with_defaults()
tic
while toc < 1.003  % Wait until 1.514 seconds have passed
end

% Outer loop for repeating the whole sequence
for rep = 1:repetitions
    % Loop through the intensities and display them with black screens in between
    for i = 1:nIntensities        
            grayscaleStartTime = GetSecs;
            Screen('FillRect', window, [intensities(i), intensities(i), intensities(i)]);  
            
            vbl = Screen('Flip', window);  % Initial flip
            whentime = vbl+(waitFrames) * ifi;
         
            % Wait for black screen duration
            WaitSecs('UntilTime', whentime);

            grayscaleEndTime = GetSecs;

            grayscale_time(end+1) = grayscaleEndTime - grayscaleStartTime;

            % Then, display a black screen
            blackStartTime = GetSecs; 
            Screen('FillRect', window, [0, 0, 0]);  % Black screen
            vbl = Screen('Flip', window);
            whentime2 = vbl+(waitFrames)*ifi;
%             % Capture the frame and write it to the video file
%             img = Screen('GetImage', windowPTB, desiredResolution);
%             writeVideo(videoWriter, img);
        
            WaitSecs('UntilTime',whentime2);
            bkg_endtime = GetSecs;

            % Log duration
            black_background_time(end+1) = bkg_endtime - blackStartTime;
    end
end

% close(videoWriter);
Screen('CloseAll');
