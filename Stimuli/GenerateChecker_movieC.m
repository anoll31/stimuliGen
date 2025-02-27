sca; clear all;
global wRectPTB
global windowPTB;

OpenScreen
screenWidth = wRectPTB(3);
screenHeight = wRectPTB(4);

squareSize = 10; % size of square in pixels
% Calculate number of squares along width and height
numSquaresX = ceil(screenWidth / squareSize);
numSquaresY = ceil(screenHeight / squareSize);

% Calculate the width and height of the checkerboard
checkerboardWidth = numSquaresX * squareSize;
checkerboardHeight = numSquaresY * squareSize;

% Define the center of the screen
[centerX, centerY] = RectCenter(wRectPTB);

% Define timing parameters
totalDuration = 10; % Total duration in seconds for checkerboard
frameDuration = 0.2; % Duration of each frame (200 ms)
numFramesCheckerboard = totalDuration / frameDuration; % Total frames for checkerboard (10 sec)
numFramesDark = totalDuration / frameDuration; % Total frames for dark (10 sec)

% Generate the checkerboard pattern for the frames
checkerboardPattern = zeros(numSquaresY, numSquaresX, numFramesCheckerboard); % Initialize a matrix
for frame = 1:numFramesCheckerboard
    for i = 1:numSquaresY
        for j = 1:numSquaresX
            if mod(i + j + frame, 2) == 0
                checkerboardPattern(i, j, frame) = 255; % White square
            else
                checkerboardPattern(i, j, frame) = 0; % Black square
            end
        end
    end
end

rectSize = size(checkerboardPattern, 1);
rectSize2 = size(checkerboardPattern, 2); 
if rectSize == rectSize2
    objRect = SetRect(0, 0, rectSize, rectSize);
else
    objRect = SetRect(0, 0, rectSize2, rectSize);
end

% Initialize videowriter to save the frames as a video
videoFilename = 'checkerboard_flicker200ms_10sON10sOFF5x.mp4';
videoWriter = VideoWriter(videoFilename, 'MPEG-4');
videoWriter.FrameRate = 1 / frameDuration;
open(videoWriter);
desiredResolution = [0, 0, 1280, 800]; 

% Start displaying the sequence
startTime = GetSecs;
nextFrameTime = startTime;  % Initialize the next frame time

for cycle = 1:5  % Repeat 5 times
    % Display checkerboard for 10 seconds
    for frame = 1:numFramesCheckerboard
        % Wait until the target time for the next frame
        while GetSecs < nextFrameTime
        end

        tex = Screen('MakeTexture', windowPTB, checkerboardPattern(:, :, frame));
        dstRect = CenterRectOnPoint(objRect * squareSize, centerX, centerY);
        Screen('DrawTexture', windowPTB, tex, [], dstRect, [], 0);
        vbl = Screen('Flip', windowPTB);  % Flip and wait for vertical sync

        % Capture the frame and write it to the video file
        img = Screen('GetImage', windowPTB, desiredResolution);
        writeVideo(videoWriter, img);

        % Update the target time for the next frame
        nextFrameTime = nextFrameTime + frameDuration;  % Next frame should be shown after frameDuration seconds

        Screen('Close', tex); 
    end
    
    % Display dark frame for 10 seconds
    for frame = 1:numFramesDark
        % Wait until the target time for the next frame
        while GetSecs < nextFrameTime
        end

       % Clear the screen to black (to avoid any default window color)
        Screen('FillRect', windowPTB, [0, 0, 0]);  % Fill the screen with black
        vbl = Screen('Flip', windowPTB);  % Flip and wait for vertical sync

        % Capture the dark frame and write it to the video file
        img = Screen('GetImage', windowPTB, desiredResolution);
        writeVideo(videoWriter, img);

        % Update the target time for the next frame
        nextFrameTime = nextFrameTime + frameDuration;  % Next frame should be shown after frameDuration seconds
    end
end

close(videoWriter); 
Screen('CloseAll');
