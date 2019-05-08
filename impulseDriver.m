% REVERB Impulse Driver 


clear;clc;
%================================================================%
[input,Fs] = audioread('output.wav');
T = 1/Fs;           % Sampling period
L = length(input);          % Length of signal
t = (0:L-1)*T;      % Time vector
in = mean(input,2);
%================================================================%



[SchroederResponse,t1] = impulseResponse(in,Fs,"Schroeder",0.07);
[MoorerResponse,t2] = impulseResponse(in,Fs,"Moorer",0.07);
[FDNResponse,t3] = impulseResponse(in,Fs,"FDN",0.07);

subplot(3,1,1);
plot(t1, SchroederResponse);
title("Schroeder's Algorithm")
xlim([0 1]);
subplot(3,1,2);
plot(t2, MoorerResponse);
title("Moorer's Algorithm")
xlim([0 1]);
subplot(3,1,3);
plot(t3, FDNResponse);
title("Jot's Algorithm (FDN)")
xlim([0 1]);
