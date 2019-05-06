%%%%%%%%%%%%%%%%%%%%%%%
% EEE4114F PROJECT                                     %
% Artificial Reverberation                               %
%                                                                             %
% Kevin Murning                                                %
% Kelsey Kaplan                                                 %
%                                                                             %
% May 2019                                                         %
%%%%%%%%%%%%%%%%%%%%%%%



% load room impulse response
a = audioinfo("SteinmanHall.wav"); 
[ir,fs] = audioread("SteinmanHall.wav");



% make single channel
irMono = mean(ir, 2);



% room impulse response plot
figure(1);
plot(ir);

title('Impulse Response of the Room');
xlabel('Time [samples]')



% load anechoic (echoless) sound
[x,fs2] = audioread("drySpeech.wav"); 

xmono = mean(x,2);

% convolve with impulse response for idealised reverb - method 1
y = conv(xmono,irMono); % convolution with FFT
soundsc(y,fs2)

% plot convolved signal


% figure(3);
% plot(y,'b');
% hold on
% plot(x,'black');
% t = 0 : 1/fs : length(ir)/fs; % time point
% title('Impulse Response Reverberated Signal');
% xlabel('time'),ylabel('Amplitude')
% legend('Convolved Signal', 'Original Signal')


% convolve with impulse response for idealised reverb - method 2
y2 = freqconv(x, irMono);
%soundsc(y2, fs2);

% plot convolved signal


% figure(4);
% plot(y2,'b');
% hold on
% plot(x,'black');
% t = 0 : 1/fs : length(ir)/fs; % time point
% title('Impulse Response Reverberated Signal');
% xlabel('time'),ylabel('Amplitude')
% legend('Convolved Signal', 'Original Signal')


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











