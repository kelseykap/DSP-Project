% MOORERREVERB
% This script implements the Moorer reverb algorithm
% by modifying the Schroeder reverb script. First,
% an additional step to add early reflections is included.
% Second, a simple low–pass filter is included in the feedback
% path of the comb filters.
%
% See also EARLYREFLECTIONS, LPCF
clear;clc;
[input,Fs] = audioread('output.wav');

in = mean(input,2);

in = [in;zeros(Fs*3,1)]; % Add zero–padding for reverb tail

% Max delay of 70 ms
maxDelay = ceil(.07*Fs);
% Initialize all buffers
buffer1 = zeros(maxDelay,1); buffer2 = zeros(maxDelay,1);
buffer3 = zeros(maxDelay,1); buffer4 = zeros(maxDelay,1);
buffer5 = zeros(maxDelay,1); buffer6 = zeros(maxDelay,1);
% Early reflections tapped delay line
bufferER = zeros(maxDelay,1);
% Delay and gain parameters
d1 = fix(.0297*Fs); g1 = 0.9;
d2 = fix(.0371*Fs); g2 = -0.9;
d3 = fix(.0411*Fs); g3 = 0.9;
d4 = fix(.0437*Fs); g4 = -0.9;
d5 = fix(.005*Fs); g5 = 0.7;
d6 = fix(.0017*Fs); g6 = 0.7;
% LFO parameters
rate1 = 0.6; amp1 = 8;
rate2 = 0.71; amp2 = 8;
rate3 = 0.83; amp3 = 8;
rate4 = 0.95; amp4 = 8;
rate5 = 1.07; amp5 = 8;
rate6 = 1.19; amp6 = 8;
% Variables used as delay for a simple LPF in each comb filter function
fbLPF1 = 0; fbLPF2 = 0; fbLPF3 = 0; fbLPF4 = 0;
% Initialize output signal
N = length(in);
out = zeros(N,1);
for n = 1:N
% Early reflections TDL
[w0 , bufferER] = earlyReflections(in(n,1),bufferER,Fs,n);


% Four parallel LPCFs
[w1,buffer1,fbLPF1] = lpcf(w0,buffer1,Fs,n,...
    d1,g1,amp1,rate1,fbLPF1);

[w2,buffer2,fbLPF2] = lpcf(w0,buffer2,Fs,n,...
d2,g2,amp2,rate2,fbLPF2);
[w3,buffer3,fbLPF3] = lpcf(w0,buffer3,Fs,n,...
d3,g3,amp3,rate3,fbLPF3);
[w4,buffer4,fbLPF4] = lpcf(w0,buffer4,Fs,n,...
d4,g4,amp4,rate4,fbLPF4);
% Combine parallel paths
combPar = 0.25*(w1 + w2 + w3 + w4);
% Two series all–pass filters
[w5,buffer5] = apf(combPar,buffer5,Fs,n,...
d5,g5,amp5,rate5);
[out(n,1),buffer6] = apf(w5,buffer6,Fs,n,...
d6,g6,amp6,rate6);
end
sound(out,Fs);
