
classdef MyDMD_movie_delayCorr < ur.cvs.DMDLightSource

    properties(Access=public)
        VideoReader;
        VideoFilePath;
        windowPtr;
        StimuliTexture;
    end

    methods

        function load_video(obj,filename)

            obj.VideoFilePath = filename;  % Store video file path
            obj.VideoReader = VideoReader(filename);  % Initialize VideoReader
            disp(['Video loaded: ', filename]);

            % Initialize pyschtoolbox window
            Screen('Preference', 'SkipSyncTests', 0);
            Screen('Preference','VisualDebugLevel',1);
            Screen('Preference','SuppressAllWarnings',0);

            screenNumber = 2;
            [WindowIndex,WindowRect] = Screen('OpenWindow', screenNumber,[0.2 0.2 0.2]);
            obj.windowPtr = WindowIndex;
        end

        function play_video(obj)

            obj.connect();  % Connect to the DMD light source

            if obj.Online
                disp('Starting DMD light source...');
                obj.start_with_defaults();  % Start the light source
            else
                disp('DMD light source is offline.');
                return;  % Exit if light source is not online
            end
%             WaitSecs(1.514);
            tic
            while toc < 1.016  % Wait until 1.514 seconds have passed
                
            end

            
            % Get the total number of frames in the video
%             tic
            totalFrames = obj.VideoReader.NumFrames;

            % Loop to play the video frame by frame
            %Get screen size
            [Xpixels, Ypixels] = Screen('WindowSize', obj.windowPtr);
            ScreenSizeRect = [0 0 Xpixels Ypixels];
            for frameIdx = 1:totalFrames
                % Read the next frame from the video
                videoFrame = read(obj.VideoReader, frameIdx);

                videoFrame = uint8(videoFrame);

                % Create a texture from the video frame
                obj.StimuliTexture = Screen('MakeTexture', obj.windowPtr, videoFrame);
                % Draw the texture (video frame) to the screen
                Screen('DrawTexture', obj.windowPtr, obj.StimuliTexture, [], ScreenSizeRect);

                % Flip the window to show the new frame
                Screen('Flip', obj.windowPtr);
                Screen('Close', obj.StimuliTexture);
                
                % Adjust playback speed based on frame rate
                pause(1 / obj.VideoReader.FrameRate);
%                 if frameIdx == 1
%                     toc
%                 end
            end

            % Close the Psychtoolbox window
            Screen('CloseAll');
        end
    end
end
