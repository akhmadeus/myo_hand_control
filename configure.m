
dependencies_path = ['..' filesep 'dependancies']; %Relative or absolute
addpath('decision_functions');
addpath('hand_functions');
addpath('func');

%% Hand configuration
com_port_name = 'COM6';  %Win: Go to Control Panel -> Devices -> Check the port name for the FT232 USB UART
                         %OSX:, open terminal, go to /dev and find the
                         %file named usb-modemXXXX, copy it's name here
s = configure_hand(dependencies_path, com_port_name, 0); %Last parameter - whether to force the initialization or not (Boolean)
ecriture_limite_courant_tous_doigts(700,s);
%% Myo Mex configuration
[mm,m1] = configure_myo(dependencies_path);
onCleanup1 = onCleanup(@()mm.delete);

%% Setting the initial position of the hand
resting_position = [11000, 7000, 8000, 9000, 10000, 11000];
close_motion_prop(resting_position,s);
