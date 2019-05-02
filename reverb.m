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
%


% load rir
a = audioinfo("GalbraithHall.wav"); 
[rir,fs] = audioread("GalbraithHall.wav");
%soundsc(rir, fs);

% make rir single channel
rirMono = mean(rir, 2);
%soundsc(irMono, fs);

% getting envelope of rir
rirHilbert = abs(hilbert(rirMono));

% smoothing envelope with moving average filter
width = 100;                % higher -> smoother
kernel = ones(width,1) / width;
rirFiltered = filter(kernel, 1, rirHilbert);

% energy curve (convert smoothed envelope to logarithmic scale)
e = 20*log10( rirHilbert / max(rirHilbert) );

% schroeder integral to get edc (smoother edc)
td = 30e3;      % this needs to be selected carefully to match e curve
edc(td:-1:1)=(cumsum(rirHilbert(td:-1:1))/sum(rirHilbert(1:td)));

% conversion to decibels
edc = 10*log10(edc);

% another method to get edc (function below)
[RT, slope] = rt(rir)
[RT, slope] = rt(rirMono)

% rir plots
% figure(1);
% plot(rirMono)
% title('Impulse Response of the Room');
% figure(2)
% hold on;
% plot(rirHilbert)
% plot(rirFiltered)
% hold off
% title('Filtered Impulse Response and Envelope');
% xlabel('Time [samples]')
% figure(3);
% hold on
% plot(e)
% plot(edc)
% hold off
% title('Energy Decay of Impulse Response');
% xlabel('Time [samples]')
%axis([-inf inf, -80 0]) 


% room frequency spectrum plot
% figure(4);
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


% load anechoic (echoless) sound
[x,fs2] = audioread("Anechoic.wav"); 
%soundsc(x,fs2)


% convolve with impulse response for idealised reverb - method 1
y = conv(x,rirMono); % convolution with FFT
%soundsc(y,fs2)

% plot convolved signal
% figure(5);
% plot(y,'b');
% hold on
% plot(x,'black');
% t = 0 : 1/fs : length(rir)/fs;
% title('Impulse Response Reverberated Signal');
% xlabel('time'),ylabel('Amplitude')
% legend('Convolved Signal', 'Original Signal')


% convolve with impulse response for idealised reverb - method 2
y2 = freqconv(x, rirMono);
% soundsc(y2, fs2);

% plot convolved signal
% figure(4);
% plot(y2,'b');
% hold on
% plot(x,'black');
% t = 0 : 1/fs : length(ir)/fs; % time point
% title('Impulse Response Reverberated Signal');
% xlabel('time'),ylabel('Amplitude')
% legend('Convolved Signal', 'Original Signal')


%% schroeder all pass filter
g = 0.7; % recommended by schroeder
M = [113 337 1051]; % not sure yet where these numbers actually come from

b = [-g zeros(1,M(1)-1) 1];
a = [1 zeros(1,M(1)-1) -g];

% figure(6)
% freqz(b, a);
% ylabel('Frequency Response of All Pass Filter');

x = [1 zeros(1, 4000)]; % comment out to get reverb on man talking
y = filter(b, a, x);

figure(7)
plot(y);
ylabel('Impulse Response');
xlabel('Time [samples]');

y = x;
for n = 1:length(M),
  b = [-g zeros(1,M(n)-1) 1];
  a = [1 zeros(1,M(n)-1) -g];
  y = filter(b, a, y);
end

figure(8)
plot(y)
ylabel('Impulse Response');
xlabel('Time [samples]');

soundsc(y, fs2);


%% functions

% function to convolve impulse response and anechoic sound 
% allows mixing direct sound back in
function y = freqconv(sig, ir)

[lenSig, chanSig] = size(sig);
[lenIR, chanIR] = size(ir);
    
sig = [sig; zeros(lenIR - 1, chanSig)];
ir = [ir; zeros(lenSig - 1, chanSig)];

% fast convolution
SIG = fft(sig);             
IR = fft(ir);
y = ifft(SIG .* IR);

% normalize signal
y = y / max(abs(y));        

% mixes in original signal - can alter percentages
y = (0.8 * y) + (0.2 * sig);
y = y / max(abs(y));

end


% function to get the edc
function [RT, slope] = rt(rir)

rir = rir';
numpoints = length(rir);
rir(1) = 0;
t = linspace(0,numpoints/22254,numpoints);
plot(t,rir);
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
plot(t,RMS), xlabel('elapsed time in seconds'),ylabel('RMS'),grid;
dB = 20 * log(RMS/max(RMS));
plot(t,dB), xlabel('elapsed time in seconds'), ylabel('dB'),grid;

% fit first-order polynomial
slope = polyfit(t,dB,1);
slope = slope(1)

% minus sign to avoid negative RT
RT = -60/slope(1);
end










