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
%
%
%


% load room impulse response
a = audioinfo("GalbraithHall.wav"); 
[ir,fs] = audioread("GalbraithHall.wav");
%soundsc(ir, fs);


% make single channel
irMono = mean(ir, 2);
%soundsc(irMono, fs);


% room impulse response plot
figure(1);
plot(ir);
%axis([0 1e4, -inf inf]) 
title('Impulse Response of the Room');
xlabel('Time [samples]')


% room frequency spectrum plot
%figure(2);
%Y = fft(ir);
%plot(abs(Y))
N = fs; % number of FFT points
transform = fft(ir,N)/N;
magTransform = abs(transform);
%faxis = linspace(-fs/2,fs/2,N);
%plot(faxis,fftshift(magTransform));
%xlabel('Frequency [Hz]')
%axis([0 length(faxis)/2, 0 max(magTransform)])
xt = get(gca,'XTick');  
set(gca,'XTickLabel', sprintf('%.0f|',xt))


% load anechoic (echoless) sound
[x,fs2] = audioread("Anechoic.wav"); 
%soundsc(x,fs2)

% convolve with impulse response for idealised reverb - method 1
y = conv(x,irMono); % convolution with FFT
%soundsc(y,fs2)

% plot convolved signal
figure(3);
plot(y,'b');
hold on
plot(x,'black');
t = 0 : 1/fs : length(ir)/fs; % time point
title('Impulse Response Reverberated Signal');
xlabel('time'),ylabel('Amplitude')
legend('Convolved Signal', 'Original Signal')


% convolve with impulse response for idealised reverb - method 2
y2 = freqconv(x, irMono);
soundsc(y2, fs2);

% plot convolved signal
figure(4);
plot(y2,'b');
hold on
plot(x,'black');
t = 0 : 1/fs : length(ir)/fs; % time point
title('Impulse Response Reverberated Signal');
xlabel('time'),ylabel('Amplitude')
legend('Convolved Signal', 'Original Signal')


% function to convolve impulse response and anechoic sound
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











