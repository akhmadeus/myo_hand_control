function [noise_threshold,activ_hyst,cocontr_hyst,wait_cocontr,hyst_counter,state,gesture,gesture_set,position] = set_parameters(win_update)%,fs)

%threshold to avoid noise induced amplitudes. One for each channel
noise_threshold = [0.07;... % flexors channel 
      0.07];   % extensors channel    

%Co-contraction hysteresis delay
cocontr_hyst = ceil(1/3*win_update); %samples
wait_cocontr = ceil(cocontr_hyst/win_update);

%Activation hysteresis delay
activ_hyst = win_update*1; %samples

%Hysteresis counter for both channels
hyst_counter = [0,0];


%variable to set the current state: 0 --> rest; 1 --> channel 1 active; 
%                                   2 --> channel 2 active ; 3 --> co-contraction
state = 0;
%Initial gesture: 1 --> cylindrical grasp; 2 --> lateral grasp; 3 --> precision grip
gesture = 1;
gesture_set = {'Cylindrical Grasp','Lateral Grasp','Pinch'};

%Finger (?) position array
position = zeros(1,6);

end %function