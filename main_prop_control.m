clc;

%% CREATING EMG BUFFER AND FIGURE
fs = 200; % EMG sampling rate of the armband, 1 sample every 5 ms
win_update = 100; % update window in milliseconds, 80 is the minimum possible update frequency I've found.
win_update = win_update/1000*fs; % update window in samples
win_proc = 3*win_update; % processing window, a piece of the signal to be processed: feature extraction, etc.

debug_mode = 0;
control_mode = 'velocity';
%control_mode = 'position'; %Doesn't work for the moment

%% Configuring UI
hf = figure(100); clf;
set(hf, 'Position', [300, 300, 1000, 500]);
movegui(gcf, 'center');

mTextBox = uicontrol('style','text');
set(mTextBox,'String','Not yet started');
set(mTextBox,'Position',[750 15 150 20]);

stop_button = uicontrol('Style','togglebutton','String','Stop',...
                        'Position', [930 15 50 25], 'parent', hf);

win_disp = 10*win_proc; % display window, a piece of the signal to be shown on the graph;

n_chan = 8;
ch_min = min(used_chan);
ch_max = max(used_chan);
step = abs(ch_min-ch_max);
graph_divider = repmat(1:2,win_disp,1);

%% Signal processing parameters
prev_emav = zeros(1,n_chan);
alpha = 0.03;

%% Comminication
buf_emg = zeros(win_disp, n_chan);
buf_proc = zeros(win_disp, n_chan);
m1.startStreaming();
m1.clearLogs();

%% Control algorithm application parameters
command_blanking_timer = 0;
command_blanking_step = 1;
delta_t = win_update/fs*command_blanking_step; % Position increment 
if strcmp(control_mode,'position')
    mapping_evaluation = zeros(3,6);
    curr_interval = 0;
end

position = resting_position;

%% Main cycle
time_since_start = 0;
time_total = inf; % how long the script will be running, in seconds
time_total = round(time_total*fs); % to samples
cycle_time = 0;

profile clear; profile on;
while (time_since_start < time_total) && ~get(stop_button,'Value')
    if cycle_time <= win_update/fs
    %Wait until new data is acquired. Pause is never less than
    %win_update/fs. Originally pause in 80ms (aquiring around 16 emg
    %samples)
        pause(win_update/fs - cycle_time); % pause() takes seconds as argument.
    else if debug_mode
            disp(cycle_time-win_update/fs);
        end
    end
    tic;
    %Pulling new data from MYO
    batch_emg = m1.emg_log;
    m1.clearLogs(); %Free place for new data
    
    %Storing new data in buffers
    batch_len = size(batch_emg,1);
    buf_emg = [buf_emg(batch_len+1:end,:); batch_emg];
    
    %Selecting data for processing
    batch_proc = buf_emg(end-batch_len+1:end,:);
    
    %Send data to feature extractor
    batch_proc = emav(batch_proc, prev_emav, alpha);
    prev_emav = batch_proc(end,:);
    buf_proc = [buf_proc(batch_len+1:end,:); batch_proc];
    
    %% Decision-taking function, takes buf_proc as an argument
    [state, gesture, wait_cocontr, hyst_counter] = state_evaluation(buf_proc,win_update,used_chan,    noise_threshold,cocontr_hyst,wait_cocontr,activ_hyst,hyst_counter,    state,gesture,n_gesture);
    if debug_mode 
        disp(state);
    end;
    %% Proportional control  
    
    command_blanking_timer = command_blanking_timer+1;
    
    if ~mod(command_blanking_timer, command_blanking_step)
        if state == 0
            curr_interval = [0 min(range_close(1),range_open(1))];
        end
        if (state == 1 || state == 2)
                if strcmp(control_mode,'position')
                    %DERIVING POSITION
                    %         emav_diff = buf_proc(:,used_chan(1))-buf_proc(:,used_chan(2));
                    mean_mav = mean(buf_proc(end-win_update:end,used_chan(state)));
                    [position,curr_interval] = get_position(gesture,state,mean_mav,curr_interval,range_close,range_open,measured_pos);

                        if gesture == 1 && (measured_pos(4) <= 40000 || measured_pos(1) < 18000)
                            position(2) = 0;
                    end
                    close_motion_prop(position,s);
                    for motor = 1:6
                        measured_temp(motor)=lecture_position(s,motor-1);
                        if measured_temp(motor) <=43000 %discarding erroneous lectures
                            measured_pos(motor) = measured_temp(motor);
                        end
                    end
                    mapping_evaluation = [mapping_evaluation;[gesture,state,mean_mav,0,0,0;position;measured_pos]];
                
            elseif strcmp(control_mode,'velocity')
                %COMPUTING VELOCITY
                %mean_mav = mean(batch_proc(:,used_chan(state))); %I think that
                %taking mean of whole batch is a bit too much. EMAV is already
                %a sliding mean, so why not to take a bit shorter region? Can
                %start from the last value: an extreme case.
                %Tried extreme case: the motion became very jerky:
                %mean_mav = batch_proc(end,used_chan(state));
                %I'll try a win_update:
                mean_mav = mean(buf_proc(end-win_update:end, used_chan(state)));
                if state == 1
                    velocity_des = get_velocity(mean_mav,range_close);
                else
                    velocity_des = get_velocity(mean_mav,range_open);
                end
                
                delta_pos = velocity_des*cycle_time*1.5;
                
                %input to the hand
                gesture = 1;
                position(:) = command2hand_prop(gesture,state,delta_pos,position,s);
            end
        end
    end
    
    %% Plotting data
    emg_used = [buf_emg(:,used_chan(2)),buf_emg(:,used_chan(1))];
    emav_used = [buf_proc(:,used_chan(2)),buf_proc(:,used_chan(1))];
    plot(emg_used+graph_divider, 'k'); hold on;
    plot(emav_used+graph_divider, 'g'); hold off;
    axis([0 win_disp 0 3]);

    set(mTextBox,'string',sprintf('Gesture: %s',gesture_set{gesture}));
    drawnow
    
    time_since_start = time_since_start + batch_len;
    cycle_time = toc;
end

