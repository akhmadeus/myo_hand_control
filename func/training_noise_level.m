function [noise_level] = training_noise_level(m1, used_chan)

%% Setting variables
fs = 200; % 1 sample every 5 ms

win_updt = 80; % update window in milliseconds, that's the minimum possible update frequency I've found.
win_updt = win_updt/1000*fs; % update window in samples
win_proc = 3*win_updt; % processing window, a part of the signal to be processed: feature extraction, etc.
win_disp = 10*win_proc; % display window, a part of the signal to be shown on graph;



hf = figure(2);
set(hf, 'Position', [200, 200, 1200, 500]);
movegui(gcf, 'center');

ch_min = min(used_chan);
ch_max = max(used_chan);
step = abs(ch_min-ch_max);
graph_divider = repmat(ch_min:step:ch_max,win_disp,1);
time_total = 2; %how long the script will be running, in seconds
time_total = round(time_total*fs); % to samples
time_since_start = 0;

m1.startStreaming();
m1.clearLogs();

n_chan = 8;
buf_emg = zeros(win_disp, n_chan);
buf_proc = zeros(win_disp, n_chan);
prev_emav = zeros(1,n_chan);
alpha = 0.02;

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
    
    %Selecting data for processing
    batch_proc = buf_emg(end-batch_len+1:end,:);
    
    %Sending data to feature extractor
    if batch_len
        batch_proc = emav(batch_proc, prev_emav, alpha);
        prev_emav = batch_proc(end,:);
        buf_proc = [buf_proc(batch_len+1:end,:); batch_proc];
        
        %Plotting data
        emg_used = [buf_emg(:,ch_min),buf_emg(:,ch_max)];
        emav_used = [buf_proc(:,ch_min),buf_proc(:,ch_max)];
        plot(emg_used+graph_divider, 'k'); hold on;
        plot(emav_used+graph_divider, 'g');
        axis([0 win_disp 0 9]);  hold off;
        %updating time
        time_since_start = time_since_start + batch_len;
        
    else %If no batch_len == 1, which means no packages received
        disp('Weak connection, zero packages received');
    end
end
m1.clearLogs(); %Free place for new data
m1.stopStreaming();

noise_level = mean(buf_proc(:, used_chan));

close(hf);
% mapping_mav_pos(range_close,range_open);
end %function