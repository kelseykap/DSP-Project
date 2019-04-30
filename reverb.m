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

% schroeder integral (smoother edc)
td = 30e3;      % this needs to be selected carefully to match e curve
edc(td:-1:1)=(cumsum(rirHilbert(td:-1:1))/sum(rirHilbert(1:td)));

% conversion to decibels
edc = 10*log10(edc);

% rir plots
figure(1);
hold on;
plot(e)
plot(edc)
hold off
%axis([-inf inf, -80 0]) 
%title('Impulse Response of the Room');
%xlabel('Time [samples]')


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
% figure(3);
% plot(y,'b');
% hold on
% plot(x,'black');
% t = 0 : 1/fs : length(ir)/fs; % time point
% title('Impulse Response Reverberated Signal');
% xlabel('time'),ylabel('Amplitude')
% legend('Convolved Signal', 'Original Signal')
% 
% 
% % convolve with impulse response for idealised reverb - method 2
% y2 = freqconv(x, irMono);
% soundsc(y2, fs2);
% 
% 
% % plot convolved signal
% figure(4);
% plot(y2,'b');
% hold on
% plot(x,'black');
% t = 0 : 1/fs : length(ir)/fs; % time point
% title('Impulse Response Reverberated Signal');
% xlabel('time'),ylabel('Amplitude')
% legend('Convolved Signal', 'Original Signal')
% 
% 
% % function to convolve impulse response and anechoic sound
% function y = freqconv(sig, ir)
% 
% [lenSig, chanSig] = size(sig);
% [lenIR, chanIR] = size(ir);
%     
% sig = [sig; zeros(lenIR - 1, chanSig)];
% ir = [ir; zeros(lenSig - 1, chanSig)];
% 
% % fast convolution
% SIG = fft(sig);             
% IR = fft(ir);
% y = ifft(SIG .* IR);
% 
% % normalize signal
% y = y / max(abs(y));        
% 
% % mixes in original signal - can alter percentages
% y = (0.8 * y) + (0.2 * sig);
% y = y / max(abs(y));
% 
% end











