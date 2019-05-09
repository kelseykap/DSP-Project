%
% function to plot the edc
% returns the RT 
%
% EDC: energy decay curve
% RT: reverberation time
%

%function [RT, irFiltered, irHilbert, EDC] = edc2(ir)
function [RT, EDC] = edc2(ir)

ircopy = ir;

% method one - smooth by finding rms 
ir = ir';
numpoints = length(ir);
ir(1) = 0;
t = linspace(0,numpoints/22254,numpoints);
N = 1000;
ir2 = ir.^2;

for i = 1:numpoints
    if i<=(numpoints-N)
        average(i) = mean(ir2(i:i+N));
    else
        average(i) = average(numpoints-N);
    end
end

RMS = sqrt(average);
dB1 = 20 * log(RMS/max(RMS));

% method 2 - smoothing with filter and envelope
irHilbert = abs(hilbert(ircopy));
width = 500;
kernel = ones(width,1) / width;
irFiltered = filter(kernel, 1, irHilbert);
dB2 = 20*log(irFiltered / max(irFiltered));

% method 3 - using schroeder integral
td = 30e3;
dB3(td:-1:1)=(cumsum(irHilbert(td:-1:1))/sum(irHilbert(1:td)));
dB3 = 10*log(dB3);
%dB3 = 20*log(dB3);

EDC = dB3;

% figure(3)
hold on;
%plot(dB1)
%plot(dB2)
dt=1/44100;
t = 0:dt:(length(dB3)*dt)-dt;
plot(t,dB3)
hold off;
xlabel('Time [s]'), ylabel('Magnitude [dB]'),grid;
%title('Energy Decay Curve');
axis([-inf inf, -80 0]) 
legend('Room Impulse', 'Schroeder', 'Moorer', 'FDN');

% getting RT
t = linspace(0,numpoints/22254,numpoints);
slope = polyfit(t,dB1,1);
slope = slope(1);
RT = -60/slope(1)

end








