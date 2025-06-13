% Setup Psychtoolbox
clear 
Screen('Preference', 'SkipSyncTests', 1);  % For debugging, remove in real experiment
screenid = max(Screen('Screens'));
[win, rect] = PsychImaging('OpenWindow', screenid, 0); % Grey background

load LUT_normalized.mat;  %REMEMBER TO LOAD THE GAMMA TABLE!!!!!!
originalCLUT = Screen('LoadNormalizedGammaTable', win, RGB_normalized);

% Parameters (same as your Python dict p)
p.nTrials = 5;
p.chirpDur_s = 8.0;
p.chirpMaxFreq_Hz = 8.0;
p.ContrastFreq_Hz = 2.0;
p.tSteadyOFF_s = 3.0;
p.tSteadyOFF2_s = 2.0; 
p.tSteadyON_s = 3.0;
p.tSteadyMID_s = 2.0;
p.IHalf = 127;
p.IFull = 254;
p.dxStim_um = 1000;  % Will convert to pixels below
p.StimType = 1;      % 1=Box, 2=Circle
p.durFr_s = 1/60;    % Assume 60 Hz monitor
p.nFrPerMarker = 3;

nPntChirp = round(p.chirpDur_s / p.durFr_s);
K_HzPerSec = p.chirpMaxFreq_Hz / p.chirpDur_s;
durMarker_s = p.durFr_s * p.nFrPerMarker;

%% DMD light source
dmd = ur.cvs.DMDLightSource;
dmd.On_s = 160; % each chirp trial is 32 seconds long
dmd.Off_s = 1;
dmd.Power_V = 0.35;
dmd.Iterations = 1;
dmd.Led = 4;

%%
dmd.connect()
%%
% dmd.start()
dmd.start_with_defaults()
tic
while toc < 1.003  % Wait until 1.514 seconds have passed
end

% Main experiment loop
for trial = 1:p.nTrials

    % --- Steady steps ---
    % % Marker ON (white)
    % DrawStimulus(win, p.StimType, stimRect, p.IFull);
    % Screen('Flip', win);
    % WaitSecs(durMarker_s);

    % OFF period
    Screen('FillRect', win, 0);
    Screen('Flip', win);
    % WaitSecs(p.tSteadyOFF2_s - durMarker_s);
    WaitSecs(p.tSteadyOFF2_s);

    % Steady ON
    DrawStimulus(win, p.StimType, p.IFull);
    Screen('Flip', win);
    WaitSecs(p.tSteadyON_s);

    % % Marker ON
    % DrawStimulus(win, p.StimType, p.IFull);
    % Screen('Flip', win);
    % WaitSecs(durMarker_s);

    % OFF period
    Screen('FillRect', win, 0);
    Screen('Flip', win);
    WaitSecs(p.tSteadyOFF_s);

    % Steady MID (gray level)
    DrawStimulus(win, p.StimType, p.IHalf);
    Screen('Flip', win);
    WaitSecs(p.tSteadyMID_s);
    
    % --- Frequency chirp ---
    freq_chirp = []; freq_int = [];
    for iT = 0:nPntChirp-1
        t_s = iT * p.durFr_s; 
        freq_chirp = [freq_chirp t_s];
        intensity = sin(pi * K_HzPerSec * t_s^2) * p.IHalf + p.IHalf;
        freq_int = [freq_int intensity];
        DrawStimulus(win, p.StimType, round(intensity));
        Screen('Flip', win);
        WaitSecs(p.durFr_s);
    end

    % Gap between chirps
    DrawStimulus(win, p.StimType, p.IHalf);
    Screen('Flip', win);
    WaitSecs(p.tSteadyMID_s);

    % --- Contrast chirp ---
    con_chirp = []; con_int = [];
    for iPnt = 0:nPntChirp-1
        t_s = iPnt * p.durFr_s;
        con_chirp = [con_chirp t_s];
        IRamp = p.IHalf * t_s / p.chirpDur_s;
        intensity = sin(2*pi * p.ContrastFreq_Hz * t_s) * IRamp + p.IHalf;
        con_int = [con_int intensity];
        DrawStimulus(win, p.StimType, round(intensity));
        Screen('Flip', win);
        WaitSecs(p.durFr_s);
    end

    % Gap after contrast chirp
    DrawStimulus(win, p.StimType, p.IHalf);
    Screen('Flip', win);
    WaitSecs(p.tSteadyMID_s);

    % OFF period at end
    Screen('FillRect', win, 0);
    Screen('Flip', win);
    WaitSecs(p.tSteadyOFF_s);

end

sca; % Close screen

% --- Helper function to draw stimulus ---
function DrawStimulus(win, stimType, intensity)
    % intensity = scalar 0-255 grayscale
    color = [intensity intensity intensity];

    switch stimType
        case 1 % Box
            Screen('FillRect', win, color);
        case 2 % Circle
            % Draw filled circle in rect bounds
            [xCenter, yCenter] = RectCenter(rect);
            radius = rect(3)/2 - rect(1)/2;
            Screen('FillOval', win, color, CenterRectOnPointd([0 0 radius*2 radius*2], xCenter, yCenter));
    end
end