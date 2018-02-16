function used_chan = training_channels(m1)

%% Setting variables
fs = 200; % 1 sample every 5 ms

win_updt = 80; % update window in milliseconds, that's the minimum possible update frequency I've found.
win_updt = win_updt/1000*fs; % update window in samples
win_proc = 3*win_updt; % processing window, a part of the signal to be processed: feature extraction, etc.
win_disp = 10*win_proc; % display window, a part of the signal to be shown on graph;

n_chan = 8;
buf_emg = zeros(win_disp, n_chan);
buf_proc_min = ones(win_disp, n_chan)*2;
buf_proc_max = zeros(win_disp, n_chan);
prev_emav = zeros(1,n_chan);
alpha = 0.02;


%% Choosing Myo channels to use 
used_chan = zeros(1,2); % channels used to control the hand:
% used_chan(1) --> intrinstic muscles; used_chan(2) --> extrinsic muscles
graph_divider = repmat(1:n_chan,win_disp,1);
time_total = 5; % how long the script will be running, in seconds
time_total = round(time_total*fs); % to samples
time_since_start = 0;

text = ['Play with the bracelet for ',num2str(time_total/fs),'seconds'];
disp(text);
disp('then choose the two most active channels for intrinsic and extrinsic muscles.');
disp('3...'); pause(1); disp('2...'); pause(1); disp('1...'); pause(1);
hf = figure(2);
set(hf, 'Position', [200, 200, 1200, 500]);
movegui(gcf, 'center');
m1.startStreaming();
m1.clearLogs();
while time_since_start < time_total
    %Wait until new data is acquired
    pause(win_updt/fs); % wait until signal is acquired; pause() takes seconds as argument.
    %Pause is never less than 80ms.
    %Pulling new data from MYO
    batch_emg = m1.emg_log;
    m1.clearLogs(); %Free place for new data
    %Storing new data in buffers
    batch_len = size(batch_emg,1);
    buf_emg = [buf_emg(batch_len+1:end,:); batch_emg];
    %update time
    time_since_start = time_since_start + batch_len;
    %Plotting data
    try
        plot(buf_emg+graph_divider, 'k'); hold off; 
    catch ME
        if (strcmp(ME.identifier,'MATLAB:dimagree'))
            save('error_workspace_training');
        end
        throw(ME);    
    end
end
m1.clearLogs(); %Free place for new data
m1.stopStreaming();
prompt = 'Select channel for intrinsic muscles: ';
used_chan(1) = input(prompt); 
prompt = 'Select channel for extrinsic muscles: ';
used_chan(2) = input(prompt); 
clc;


end