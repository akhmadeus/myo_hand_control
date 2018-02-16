function new_vel = get_velocity(emav,range_mav)
%GET_VELOCITY:
%   It compute the position increment corresponding to the mean signal amplitude
%   in input. The velocity is scaled according to a range defined during
%   training:
%   MAX_MAV corresponds to a maximum contraction and it maps the maximum
%   velocity; MIN_MAV corresponds to the muscle resting state and it maps
%   the minimum velocity.
%INPUT:
%   emav - current mean amplitude value
%OUTPUT:
%   vel - new velocity that should be applied to the hand motors

%Author: Elena Rampone
%Date: 06/04/2016

MAX_MAV = range_mav(2); %mean amplitude value corresponding to a maximum contraction
MIN_MAV = range_mav(1);  %mean amplitude value corresponding to a minimum contraction

%maximal velocity
max_vel = 40000; %positions/sec 
%minimal velocity
min_vel = 1000; %positions/sec

new_vel = min_vel + (emav-MIN_MAV)/(MAX_MAV - MIN_MAV)*(max_vel-min_vel);
if new_vel < 0
    new_vel = 0;
end

end %function