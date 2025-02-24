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
 
% call function for grayscale calibration

grayscaleStim
