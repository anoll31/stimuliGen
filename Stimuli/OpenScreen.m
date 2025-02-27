function OpenScreen
sca;

global windowPTB;
global wRectPTB;

Screen('Preference', 'SkipSyncTests', 1);  
screens = Screen('Screens');
screenNumber = max(screens);
[windowPTB, wRectPTB] = Screen('OpenWindow',screenNumber);

%load Xphase2_phot120_tv_012820.mat;
% originalCLUT=Screen('LoadNormalizedGammaTable',windowPTB,inverseCLUT);

priorityLevel=MaxPriority(windowPTB); 
Priority(priorityLevel);

Screen('BlendFunction',windowPTB , GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

end

