%
% function to plot the edr
%
% EDR: energy decay relief
%

function edr(signal, fs)

frameSizeMS = 30;
overlap = 0.75;
windowType = 'hann';

bits = size(signal);

% calculate STFT frames
minFrameLen = fs*frameSizeMS/1000; 
frameLenPow = nextpow2(minFrameLen);
frameLen = 2^frameLenPow; % frame length = fft size
eval(['frameWindow = ' windowType '(frameLen);']);
[B,F,T] = spectrogram(signal,frameWindow,overlap*frameLen,[],fs);

[nBins,nFrames] = size(B);

B_energy = B.*conj(B);
B_EDR = zeros(nBins,nFrames);
for i=1:nBins
    B_EDR(i,:) = fliplr(cumsum(fliplr(B_energy(i,:))));
end
B_EDRdb = 10*log10(abs(B_EDR));

% normalize EDR to 0 dB and truncate the plot below a given dB threshold
offset = max(max(B_EDRdb));
B_EDRdbN = B_EDRdb-offset;

B_EDRdbN_trunc = B_EDRdbN;
for i=1:nFrames
  I = find(B_EDRdbN(:,i) < -70);
  if (I)
    B_EDRdbN_trunc(I,i) = -70;
  end
end

figure(3);clf;
mesh(T,F/1000,B_EDRdbN_trunc);
view(130,30);
%title('Energy Decay Relief');
xlabel('Time [s]');ylabel('Frequency (kHz)');zlabel('Magnitude (dB)');
axis tight; zoom on;
axis([0 2 -inf inf -inf inf]);
end







