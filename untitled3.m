[rir,fs] = audioread("GalbraithHall.wav");
rir = rir'; % transpose to get row vector
numpoints = length(rir); % this is the size of the vector
rir(1) = 0; % replace first point in vector
t = linspace(0,numpoints/22254,numpoints);
plot(t,rir), xlabel('elapsed time in seconds'), ylabel('pressure');

sound(rir);
N = 1000; % integration constant in RMS calculation
rir2 = rir.^2; % the S in RMS
for i = 1:numpoints % step through entire array and do M of RMS
if i<=(numpoints-N)
average(i) = mean(rir2(i:i+N)); % average the N points to the right
else
average(i) = average(numpoints-N); % keep same average for tail
end
end
RMS = sqrt(average); % do R of RMS
plot(t,RMS), xlabel('elapsed time in seconds'),ylabel('RMS'),grid;
largest = max(RMS);
dB = 20 * log(RMS/largest);
plot(t,dB), xlabel('elapsed time in seconds'), ylabel('dB'),grid;
slope = polyfit(t,dB,1); % fit first-order polynomial
sslope = num2str(slope(1));
disp(['Slope of the best fit line is: ',sslope])
RT = -60/slope(1); % minus sign to avoid negative RT
sRT = num2str(RT);
disp(['Reverberation time is therefore ',sRT,' seconds'])







