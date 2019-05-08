% schroeder all pass filter

function allpass(signal)
g = 0.7; % recommended by schroeder
M = [113 337 1051]; % not sure yet where these numbers actually come from

b = [-g zeros(1,M(1)-1) 1];
a = [1 zeros(1,M(1)-1) -g];

% figure(6)
% freqz(b, a);
% ylabel('Frequency Response of All Pass Filter');

%x = signal
x = [1 zeros(1, 4000)]; % comment out to get reverb on man talking
y = filter(b, a, x);

% figure(7)
% plot(y);
% ylabel('Impulse Response');
% xlabel('Time [samples]');

y = x;
for n = 1:length(M),
  b = [-g zeros(1,M(n)-1) 1];
  a = [1 zeros(1,M(n)-1) -g];
  y = filter(b, a, y);
end

% figure(8)
% plot(y)
% ylabel('Impulse Response');
% xlabel('Time [samples]');
soundsc(y, fs2);
end