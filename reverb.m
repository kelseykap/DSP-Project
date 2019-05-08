%
% EEE4114F PROJECT
% Artificial Reverberation
% 
% Kevin Murning
% Kelsey Kaplan
%
% May 2019
%
%
% RIR: Room impulse response
% EDC: Energy decay curve
% RT: Reverberation decay time
% EDR: Energy decay relief
%

% LOAD RIR
a = audioinfo("GalbraithHall.wav");
[rir,fs] = audioread("GalbraithHall.wav");
rir = mean(rir, 2);

% LOAD ANECHOIC SOUND
[input,Fs] = audioread('drySpeech.wav');
T = 1/Fs;                                       % Sampling period
L = length(input);                              % Length of signal
t = (0:L-1)*T;                                  % Time vector
in = mean(input,2);

% CONVOLUTION WITH ROOM IMPULSE RESPONSE
y2 = freqconv(in, rir);

% IMPULSE RESPONSE OF ALLPASS
y3 = allpass();

% IMPLEMENT ALGORITHMS WITH DIRAC
% [SchroederResponse,t1] = impulseResponse(in,Fs,"Schroeder",0.07);
% [MoorerResponse,t2] = impulseResponse(in,Fs,"Moorer",0.07);
% [FDNResponse,t3] = impulseResponse(in,Fs,"FDN",0.07);

% IMPLEMENT ALGORITHMS WITH INPUT
% [SchroederResponse] = SchroederReverb(in, Fs, 0.07);
% [MoorerResponse] = MoorerReverb(in,Fs,0.07);
% [FDNResponse] = FDNReverb(in,Fs,0.07);

% EDC and RT 
% [RTir, EDCir] = edc2(rir); 
% [RTschroeder, EDCschroeder] = edc2(SchroederResponse);
% [RTmoorer, EDCmoorer] = edc2(MoorerResponse);
% [RTfdn, EDCfdn] = edc2(FDNResponse);

% EDR
% edr(rir, Fs)
% edr(SchroederResponse, Fs)
% edr(MoorerResponse, Fs)
% edr(FDNResponse, Fs)

% ECHO DENSITY
% [theta,t] = echodensity(rirMono,Fs);
% [theta,t] = echodensity(SchroederResponse,Fs);
% [theta1,t1] = echodensity(FDNResponse,Fs);
% [theta2,t2]= echodensity(MoorerResponse,Fs);

% CLARITY
rir2 = power(rir,2);
int = cumsum(rir2(1:0.8*fs))
%/cumsum(rir2(0.8*fs:end))




%% PLOTS

% RIR PLOT
% dt = 1/fs;
% t = 0:dt:(length(rirMono)*dt)-dt;
% figure(1);
% plot(t,rirMono)
% title('Impulse Response of Galbraith Hall');
% xlabel('Time [s]')

% ALLPASS RESPONSE
% dt = 1/fs;
% t = 0:dt:(length(y3)*dt)-dt;
% figure(1);
% plot(t, y3)
% %title('Impulse Response of Allpass Filter');
% xlabel('Time [s]')
% axis([0 inf, -0.6 0.6])

% FREQUENCY SPECTRUM
% figure(2);
% Y = fft(rir);
% plot(abs(Y))
% N = fs; % number of FFT points
% transform = fft(rir,N)/N;
% magTransform = abs(transform);
% faxis = linspace(-fs/2,fs/2,N);
% plot(faxis,fftshift(magTransform));
% xlabel('Frequency [Hz]')
% axis([0 length(faxis)/2, 0 max(magTransform)])
% xt = get(gca,'XTick');  
% set(gca,'XTickLabel', sprintf('%.0f|',xt))

% CONVOLUTIONAL REVERB
% figure(4);
% dt = 1/fs;
% t1 = 0:dt:(length(y2)*dt)-dt;
% plot(t1, y2,'b');
% hold on
% t2 = 0:dt:(length(input)*dt)-dt;
% plot(t2, input,'black');
% t = 0 : 1/fs : length(rir)/fs; % time point
% title('Convolutional Reverberation Signal');
% xlabel('Time [s]'),ylabel('Amplitude')
% legend('Convolved Signal', 'Original Signal')
% axis([0 0.7, -inf inf])

% cCONVOLUTIONAL REVERB 2
% figure(4);
% dt = 1/fs;
% subplot(2,1,1)
% t2 = 0:dt:(length(input)*dt)-dt;
% plot(t2, input,'black');
% xlabel('Time [s]'),ylabel('Amplitude')
% title('Original Anechoic Signal');
% axis([0 7, -1 1])
% subplot(2,1,2)
% t1 = 0:dt:(length(y2)*dt)-dt;
% plot(t1, y2);
% title('Convolved Anechoic Signal');
% xlabel('Time [s]'),ylabel('Amplitude')
% axis([0 7, -1 1])

% ALGORITHMIC REVERB IMPULSE RESPONSES
% subplot(3,1,1);
% t1 = 0:dt:(length(SchroederResponse)*dt)-dt;
% plot(t1, SchroederResponse);
% title("Schroeder's Algorithm")
% xlim([0 7]);
% subplot(3,1,2);
% t2 = 0:dt:(length(MoorerResponse)*dt)-dt;
% plot(t2, MoorerResponse);
% title("Moorer's Algorithm")
% xlim([0 7]);
% subplot(3,1,3);
% t3 = 0:dt:(length(FDNResponse)*dt)-dt;
% plot(t3, FDNResponse);
% title("FDN Algorithm")
% xlim([0 7]);

% EDC - ROOM IMPULSE RESPONSE
% figure(1)
% subplot(3,1,1);
% t = 0:dt:(length(irHilbert)*dt)-dt;
% plot(t, irHilbert)
% xlabel('Time [s]'), ylabel('Amplitude'),grid;
% axis([-inf 0.8, -inf inf]) 
% title('Filtered Impulse Response');
% subplot(3,1,2);
% t = 0:dt:(length(irFiltered)*dt)-dt;
% plot(t, irFiltered)
% xlabel('Time [s]'), ylabel('Amplitude'),grid;
% axis([-inf 0.8, -inf inf]) 
% title('Impulse Response Envelope');
% subplot(3,1,3);
% t = 0:dt:(length(EDCir)*dt)-dt;
% plot(t, EDCir)
% xlabel('Time [s]'), ylabel('Magnitude [dB]'),grid;
% axis([-inf inf, -80 0]) 
% title('Energy Decay Curve');

% ALGORITHMIC EDC
% figure(1)
% subplot(3,1,1);
% plot(EDCschroeder)
% xlabel('Time [s]'), ylabel('Magnitude [dB]'),grid;
% title('Energy Decay Curve');
% axis([-inf inf, -60 0]) 
% subplot(3,1,2);
% plot(EDCmoorer)
% xlabel('Time [s]'), ylabel('Magnitude [dB]'),grid;
% title('Energy Decay Curve');
% axis([-inf inf, -60 0]) 
% subplot(3,1,3);
% plot(EDCfdn)
% xlabel('Time [s]'), ylabel('Magnitude [dB]'),grid;
% title('Energy Decay Curve');
% axis([-inf inf, -60 0]) 

% ECHO DENSITY
% hold on
% plot(t,theta(t));
% xlim([300 5E4])
% plot(t2,theta2(t2));
% xlim([300 5E4])
% plot(t1,theta1(t1));
% xlim([300 5E4])
% legend('Schroeder', 'Moorer', 'FDN')
% set(gca,'XScale','log')
% grid;







