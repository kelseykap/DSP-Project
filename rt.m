%
% function to get the edc
% 
% RT: reverb time
% rir: room impulse response
%

function [RT, slope] = rt(rir)

rir = rir';
numpoints = length(rir);
rir(1) = 0;
t = linspace(0,numpoints/22254,numpoints);
%plot(t,rir);
xlabel('elapsed time in seconds');

% integration constant in RMS calculation
N = 1000;
rir2 = rir.^2;

% step through entire array and do M of RMS
for i = 1:numpoints
    if i<=(numpoints-N)
        % average the N points to the right
        average(i) = mean(rir2(i:i+N));
    else
        % keep same average for tail
        average(i) = average(numpoints-N);
    end
end

RMS = sqrt(average);
%plot(t,RMS), xlabel('elapsed time in seconds'),ylabel('RMS'),grid;
dB = 20 * log(RMS/max(RMS));
%plot(t,dB), xlabel('elapsed time in seconds'), ylabel('dB'),grid;

% fit first-order polynomial
slope = polyfit(t,dB,1);
slope = slope(1)

% minus sign to avoid negative RT
RT = -60/slope(1);
end