function [res] = emav(input, prev, alpha)

% Calculates eMAV of input signal with smoothing coefficient alpha
% function [res] = emav(input, prev, alpha)
% - input is a matrix 'time X channels';
% - prev is a vector '1 X channels' of previous value of eMAV
% - alpha is smoothing parameter 0 > alpha > 1;

input_len = size(input,1);
res = zeros(size(input)+[1,0]);

res(1,:) = prev;
for i = 2:input_len+1
    res(i,:) = (1-alpha)*abs(res(i-1,:)) + alpha*abs(input(i-1,:));
end

res = res(2:end,:);