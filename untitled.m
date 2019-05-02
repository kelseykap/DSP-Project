% A Matlab script to calculate and plot the impulse response of
% Schroeder allpass sections.
%
% by Gary Scavone
% McGill University, 2004.
[x,fs2] = audioread("Anechoic.wav"); 

g = 0.7;
M = [113 337 1051];

b = [-g zeros(1,M(1)-1) 1];
a = [1 zeros(1,M(1)-1) -g];
freqz(b, a);

disp('Frequency Response of Allpass Section ... hit key');
pause

%x = [1 zeros(1, 4000)];
y = filter(b, a, x);
plot(y);
ylabel('Impulse Response');
xlabel('Time (samples)');

disp('Impulse Response of Allpass Section ... hit key');

y = x;
for n = 1:length(M),
  b = [-g zeros(1,M(n)-1) 1];
  a = [1 zeros(1,M(n)-1) -g];
  y = filter(b, a, y);
end

plot(y)
ylabel('Impulse Response');
xlabel('Time (samples)');
disp('Impulse Response of Cascaded Allpass Section');


soundsc(y,fs2)


