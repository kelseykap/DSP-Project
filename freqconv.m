%
% function to convolve impulse response and anechoic sound 
% allows mixing direct sound back in
%
%

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