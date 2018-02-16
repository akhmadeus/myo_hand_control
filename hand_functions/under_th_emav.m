function [ok] = under_th_emav(emav,th)
%UNDER_TH_EMAV:
%   Evaluate if the signal goes below the threshold

if emav < th
    ok = 1;
else
    ok = 0;
end %if

end %function