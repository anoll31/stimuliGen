%device = serialport("COM9", 122880); % determine com port when connected
setDTR(device, false)               % mark low

% init dmd light source
%lights = ur.cvs.DMDLightSource();
lights.connect()

volts = 0.35;           % amplitude in volts
led = 4;             % which light
lights.Power_V = volts;
lights.Led = 4;
lights.Iterations = 1;
lights.On_s = 0.4;
lights.Off_s = 0.2;


for i = 1:25
    tic
    setDTR(device, true)                % mark high
    while toc < 0.5
    end
%     lights.start(0.4, 0.1, 1, volts, led)  % photodiode picks up this signal
    setDTR(device, false) 
    lights.start_with_defaults()
                  % mark low
    tic
    while toc < 2.2
    end
    
end