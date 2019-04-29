%---------------------------------------------------% load room impulse response
a = audioinfo("GalbraithHall.wav");               % a = info on signal
[ir,fs] = audioread("GalbraithHall.wav");         % read in signal
%soundsc(ir, fs);                               
irMono = sum(ir, 2) / size(ir, 2);
%soundsc(irMono, fs);

%---------------------------------------------------% load singing
[x,fs2] = audioread("Anechoic.wav"); 
%soundsc(x,fs2)
y = conv(x,irMono); % convolution with FFT
soundsc(y,fs2)


%---------------------------------------------------% plot impulse response
figure(1);
plot(ir);
%axis([0 1e4, -inf inf]) 
title('Impulse Response of the Room');
xlabel('Time [samples]')


%---------------------------------------------------% plot frequency spectrum
%figure(2);

%Y = fft(ir);
%plot(abs(Y))

N = fs; % number of FFT points
transform = fft(ir,N)/N;
magTransform = abs(transform);

%faxis = linspace(-fs/2,fs/2,N);
%plot(faxis,fftshift(magTransform));
%xlabel('Frequency [Hz]')

% view frequency content up to half the sampling rate:
%axis([0 length(faxis)/2, 0 max(magTransform)]) 

% change the tick labels of the graph from scientific notation to floating point: 
xt = get(gca,'XTick');  
set(gca,'XTickLabel', sprintf('%.0f|',xt))










