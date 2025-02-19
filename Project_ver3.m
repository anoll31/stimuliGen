%% Anna Noll 
%DMD Code to project images from desktop onto DMD in optical system. 
%ver_1 notes: 
%Started ver_1 outline on 6/9/2024. %Being coded to only project one image at the moment.
% Will be fleshed out later
%added actual code to ver_1 on 6/26/2024. Code now projects a single image onto a
%screen. The image will cover the entire size of the screen. 
%ver_2 notes: 
%created ver_2 m.file 07/02/2024 
%Added code to use ui instead of user prompt functions. Now, a pop out
%occurs where user selects directory and image. 

%% How it works/How to use (Updated 07/02/2024)%% 
%The script uses ui to have the user select the Parent Folder to be used.
%In this case, the Parent Folder is the folder that contains Psychtoolbox
%and the images in it. Then, another ui allows the user to select the image
%they would like to display. A dialog box pops up where the user inputs the
%screen they would like to use (e.g a numerical value such as '1'). If
%unsure what screen value to use, one can open their display settings on
%their computer to find which screen number they want to use. After these inputs,
%the script will project the image. Then, once the image is projected, the user
% can press any key on their keyboard and the window will close (projection will stop).  
%% 
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference','VisualDebugLevel',3);
Screen('Preference','SuppressAllWarnings',1);
%% Prompts 

%User prompts for the code
    ParentFolder=uigetdir;
    Stimuli=uigetfile({'*.*'}); %ask what Kaitlin prefers for this 
    %create dialog box for screen value 
        inputpromptScreen='Please input which screen you would like to use (e.g a numerical value)'; 
        dlgtitleScreen='Input Screen Number';
        fieldsizeScreen=[1 45];
        definputScreen={'ex: 1'};
        optionsScreen.Resize = 'on'; 
        ScreenValueCell=inputdlg(inputpromptScreen,dlgtitleScreen,fieldsizeScreen,definputScreen,optionsScreen);
%% Extract ScreenValues from the input dialog box 
ScreenValue = str2double(ScreenValueCell{1});
%% Load Image Data 
StimuliPath=strcat(ParentFolder,'\',Stimuli); %creates image path from prompts 
StimuliMatrix=imread(StimuliPath); %reads image as a matrix
[WindowIndex,WindowRect] = Screen('OpenWindow', ScreenValue);

%% Define Size of Screen (DMD Res) 

%Get screen size
[Xpixels, Ypixels] = Screen('WindowSize', WindowIndex);
%Define destination rectangle to fill the screen
ScreenSizeRect = [0 0 Xpixels Ypixels];

%% Display Black Screen
 Black=BlackIndex(WindowIndex);
 Screen('FillRect',WindowIndex,Black)
 % BlackScreen=Screen('MakeTexture',WindowIndex,Black);
 % Screen('DrawTexture',WindowIndex,BlackScreen);
 Screen('Flip',WindowIndex);
KbReleaseWait;
KbWait; 
%% Start Projection Code 
StimuliTexture=Screen('MakeTexture', WindowIndex, StimuliMatrix); %refer to Screen help documentation
Screen('DrawTexture',WindowIndex,StimuliTexture,[],ScreenSizeRect)
Screen('Flip', WindowIndex);
KbReleaseWait; 
KbWait; 
%% Display Black Screen 
 Black=BlackIndex(WindowIndex);
 Screen('FillRect',WindowIndex,Black)
 % BlackScreen=Screen('MakeTexture',WindowIndex,Black);
 % Screen('DrawTexture',WindowIndex,BlackScreen);
 Screen('Flip',WindowIndex);
KbReleaseWait;
KbWait; 
%% End Script
KbReleaseWait;
KbWait; %pauses script until a key on keyboard is pressed
Screen('CloseAll') %closes window 
