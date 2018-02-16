function [ok] = above_th_emav(emav,th)
%ABOVE_TH_EMAV:
%   Evaluate if the signal exceeds the threshold

if emav > th
    ok = 1;
else
    ok = 0;
end %if

end %function