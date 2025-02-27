% FBCF
% This function creates a feedback comb filter by
% processing an individual input sample and updating
% a delay buffer used in a loop to index each sample
% in a signal. Fractional delay is implemented to make
% it possible to modulate the delay time.
%
% Input Variables
%n : current sample number of the input signal
%delay : samples of delay
%fbGain : feedback gain (linear scale)
%amp : amplitude of LFO modulation
%rate : frequency of LFO modulation
%
% See also FBCFNOMOD

function [out,buffer] = fbcf(in,buffer,Fs,n,delay,fbGain,amp,rate)
% Calculate time in seconds for the current sample
t = (n-1)/Fs;
fracDelay = amp * sin(2*pi*rate*t);
intDelay = floor(fracDelay);
frac = fracDelay - intDelay;
% Determine indexes for circular buffer
len = length(buffer);
indexC = mod(n-1,len) + 1; % Current index
indexD = mod(n-delay-1+intDelay,len) + 1; % Delay index


indexF = mod(n-delay-1+intDelay+1,len) + 1; % Fractional index
out = (1-frac)*buffer(indexD,1) + (frac)*buffer(indexF,1);
% Store the current output in appropriate index
buffer(indexC,1) = in + fbGain*out;
end