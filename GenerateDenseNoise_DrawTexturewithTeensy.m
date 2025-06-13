% Generate binary dense noise
clear;
Screen('Preference', 'SkipSyncTests', 1)
%Initialize the screen
screenid = max(Screen('Screens')); % Use the external screen
[window, rect] = Screen('OpenWindow', screenid, [0, 0, 0]); % Black background

% Get screen resolution
[scrX, scrY] = Screen('WindowSize', window);

% Define the size of each square (adjustable)
squareSize = 10; % Increase for bigger squares, decrease for finer noise

% Calculate number of squares along width and height
numSquaresX = ceil(scrX / squareSize);
numSquaresY = ceil(scrY / squareSize);

load LUT_normalized.mat;  %REMEMBER TO LOAD THE GAMMA TABLE!!!!!!
originalCLUT = Screen('LoadNormalizedGammaTable', window, RGB_normalized);

% Define timing parameters
totalDuration = 20; % Total duration in seconds
frameDuration = 0.1; % Duration of each noise frame (100 ms)
numFrames = totalDuration / frameDuration; % Total frames in 1 minute
numRepeats = 1;

% Preallocate matrix to store noise frames
noiseSequence = zeros(numSquaresY, numSquaresX, numFrames, 'uint8');

% Generate noise sequence beforehand
rng(42); % Set random seed for reproducibility
for frame = 1:numFrames
    noiseSequence(:, :, frame) = randi([0, 1], numSquaresY, numSquaresX) * 255;
end
upscaledSize = [scrY, scrX];
%% DMD light source
dmd = ur.cvs.DMDLightSource;
dmd.On_s = 20; % this number depends on stimuli duration
dmd.Off_s = 1;
dmd.Power_V = 0.35;
dmd.Iterations = 1;
dmd.Led = 4;

%%
dmd.connect()
pause(5)
%%
% dmd.start()
dmd.start_with_defaults()
tic
while toc < 1.003  % Wait until 1.514 seconds have passed
end

% Start displaying the sequence
for repeat = 1:numRepeats
    startTime = GetSecs;

    for frame = 1:numFrames


        img = imresize(noiseSequence(:,:,frame),upscaledSize,'nearest');
        tex = Screen('MakeTexture',window,img);
        Screen('DrawTexture',window,tex);

        % Flip the screen to update the displayed noise
        Screen('Flip', window);

        % Wait until it's time for the next frame
        while GetSecs - startTime < frame * frameDuration
            % Do nothing, just wait
        end
    end

    Screen('FillRect',window,0);
    Screen('Flip',window);
    WaitSecs(frameDuration);
end

% KbWait;
% Close everything after sequence ends
Screen('CloseAll');