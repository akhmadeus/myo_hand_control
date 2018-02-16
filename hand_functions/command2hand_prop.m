function [measured_pos] = command2hand_prop(motion,direction,delta_pos,previous_position,s)

%PROP_POSITION:
%   
%Input:
%   motion - it specify the motion to execute. It can assume the values:
%                   1 --> cylindrical grasp;
%                   2 --> lateral grasp;
%                   3 --> precision grip.
%
%   direction - it specify the direction of the motion. It can assume the
%               values:
%                   1 --> close
%                   2 --> open 

%Author: Elena Rampone
%Date: 06/04/2016
%Modified: 25/04/2016

%-------------------------------------------------------------------------------------------------%
%Set the final position (in dec) of each finger(motor) for each desired motion. 

motor_max_position = [18500 10800 23208 25208 27208 28208;... %cylindrical grasp
                       9200 19000 43000 43000 43000 43000;... %lateral grasp
                      20000  10050 29000 29000 000 000;... %precision grip
                  0     0     0     0     0     0;... %opening motion
               4800  9400  7400  9200  9300 11000];   %resting motion 



%% Getting current positions of motors
measure = read_all_positions(s,1);

measured_pos = previous_position;
measured_pos(measure <= motor_max_position(motion, :)) = measure(measure <= motor_max_position(motion, :));

if sum(measured_pos) < 95/100*previous_position
    return;
    disp('returned from command2hand_prop');
end
    
if direction == 1
    for motor = 1:6
        next_position(motor) = max(0,ceil(measured_pos(motor) + delta_pos*sign(motor_max_position(motion,motor)-measured_pos(motor))));  
        next_position(motor) = min(motor_max_position(motion,motor),next_position(motor));
    end %for
    
    %wait because the thumb have to be positioned over the fingers
    if motion == 1 && (next_position(4) <= 25000 || next_position(1) < 18000) 
        next_position(2) = 0;
    end  
    
elseif direction == 2 %open the hand
    for motor = 1:6
        next_position(motor) = round(measured_pos(motor) - delta_pos);
        next_position(motor) = max(0,next_position(motor));     
    end %for
    
    if measured_pos(2) > 0  %wait because the thumb is positioned over the fingers
        next_position(1) = measured_pos(1);
        next_position(3:end) = measured_pos(3:end);
    end
end %elseif

close_motion_prop(next_position,s);

end %function move_hand_prop