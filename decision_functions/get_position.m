function [new_pos,curr_emav_interval] = get_position(motion,state,emav,curr_emav_interval,range_close,range_open,curr_pos)


%Defining the finger position range. Each row corresponds to a different
%motion, each column corresponds to an actuator.
finger_pos = [18000 13823 43000 43000 43000 43000;... %cylindrical grasp
               9200 19000 43000 43000 43000 43000;... %lateral grasp
              16300  6900 23000     0     0     0;... %precision grip
                  0     0     0     0     0     0;... %opening motion
               4800  9400  7400  9200  9300 11000];   %resting motion 

%these variables are to index the correct rows in the finger_pos matrix
%when needed
open = 4;
rest = 5;

%Setting the width of the emav neighbourhood
interval_width = 5/100; % percentual of the maximum range value
n_levels = floor(1/interval_width)-1;
if state == 1 %close
    interval_width = interval_width*(range_close(2)-range_close(1));
    %defining the magnitude levels in which the magnitude range is divided
    levels = (1:n_levels).*(interval_width);
    levels = range_close(1) + levels;
elseif state == 2 %open
    interval_width = interval_width*(range_open(2)-range_open(1));
    %defining the magnitude levels in which the magnitude range is divided
    levels = (1:n_levels).*(interval_width);
    levels = range_open(1) + levels;
end


%if the emav is inside the current emav interval, the position does not
%have to change
if emav < max(curr_emav_interval) && emav > min(curr_emav_interval)
    new_pos = curr_pos;
    return
end

%% DETERMINING THE NEW INTERVAL TO WHICH THE CURRENT EMAV BELONGS
if emav > max(levels)
    curr_level = find(levels == max(levels));
else
    curr_level = find(levels>emav,1,'first');
end
curr_emav_interval = [levels(curr_level)-interval_width,levels(curr_level)+interval_width];

%% COMPUTING THE NEW FINGER POSITIONS, ACCORDING TO THE CURRENT EMAV INTERVAL 
switch state
    case 1 %close
        range_pos = finger_pos(motion,:)-finger_pos(rest,:);
        new_pos = finger_pos(rest,:) + floor((range_pos)./n_levels*curr_level);
        %if cylidrical motion, wait because the thumb have to be positioned over the fingers
        if motion == 1 && (curr_pos(4) <= 40000 || curr_pos(1) < 18000)
            new_pos(2) = 0;
        end
    case 2 %open
        range_pos = finger_pos(motion,:)-finger_pos(rest,:);
        new_pos = floor((range_pos)./n_levels*(n_levels-curr_level));
        %wait because the thumb is positioned over the fingers
%       if curr_pos(2) > 0
%           new_pos(1) = curr_pos(1);
%           new_pos(3:end) = curr_pos(3:end);
%       end
end %elseif

end %function