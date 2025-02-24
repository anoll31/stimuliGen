%Anna Noll 
%GrayScale Stimulus Code 
%This code creates white screens with various grayscale values in order to
%calibrate the grayscale and resulting intensity 
%tested on personal device 

lights = ur.cvs.DMDLightSource();
lights.connect()

lights.Power_V = 0.35;
lights.Led = 4;
lights.Iterations = 1;
lights.On_s = 10;
lights.Off_s = 0.2;

lights.start_with_defaults()

tic
while toc < 1.003 % this is the delay we measured for teensy light source

end

 function grayscaleStim
%% Suppress Screen Warning
Screen('Preference', 'SkipSyncTests', 0);  
Screen('Preference','VisualDebugLevel',1);  
Screen('Preference','SuppressAllWarnings',0);
%% Set basic parameters
ScreenValue=2;
[WindowIndex,WindowRect] = Screen('OpenWindow', ScreenValue);

    

%% Define Grayscale Value Array
nValues=15;
grayValues=round(linspace(0,255,nValues));

%% Display White Intensity Screens
for i=1:length(grayValues)
Screen('FillRect',WindowIndex,[grayValues(i) grayValues(i) grayValues(i)]);
Screen('Flip', WindowIndex);
     KbWait([], 2); 
end 
Screen('CloseAll')
end  
