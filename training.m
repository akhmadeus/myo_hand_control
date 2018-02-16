
%% CREATING EMG BUFFER AND FIGURE
fs = 200; % EMG sampling rate of the armband, 1 sample every 5 ms
win_update = 100; % update window in milliseconds, 80 is the minimum possible update frequency I've found.
win_update = win_update/1000*fs; % update window in samples
win_proc = 3*win_update; % processing window, a piece of the signal to be processed: feature extraction, etc.


% Set acquisition and control parameters
[noise_threshold,activ_hyst,cocontr_hyst,wait_cocontr,hyst_counter,state,gesture,gesture_set,resting_position] = set_parameters(win_update);%,fs);
n_gesture = length(gesture_set);

%% TRAINING to set the channels to use and the EMG magnitude range
% input('Channel choice');
%used_chan = training_channels(m1);

used_chan = [1,4];

input('Noise level measure');
noise_level = training_noise_level(m1, used_chan);

input('Amplitude range training');
[range_close,range_open] = training_ampl_range(m1, used_chan);

range_close(1) = range_close(1) + noise_level(1);
range_close(2) = range_close(2) + noise_level(2);

