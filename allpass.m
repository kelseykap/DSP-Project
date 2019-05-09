% 
% function to implement the a single 
% schroeder all pass filter
%
%

function [y] = allpass(signal)

g = 0.7;
M = [113 337 1051];

b = [-g zeros(1,M(1)-1) 1];
a = [1 zeros(1,M(1)-1) -g];

x2 = signal;
x = [1 zeros(1, 4000)]; % comment out to get reverb on man talking
%y = filter(b, a, x);

y = x;
for n = 1:length(M),
  b = [-g zeros(1,M(n)-1) 1];
  a = [1 zeros(1,M(n)-1) -g];
  y = filter(b, a, y);
end

y2 = x2;
for n = 1:length(M),
  b = [-g zeros(1,M(n)-1) 1];
  a = [1 zeros(1,M(n)-1) -g];
  y2 = filter(b, a, y2);
end

figure()
subplot(2,1,1)
plot(y);
xlabel('Time [samples]');
title('Cascaded Allpass Response');
subplot(2,1,2)
hold on
plot(y2);
plot(signal, 'black')
title('Simulated Reverberation Output');
legend('Filtered Audio', 'Original Audio');
xlabel('Time [samples]');

end







