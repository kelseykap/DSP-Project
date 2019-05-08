% 
% function to implement the a single 
% schroeder all pass filter
%
%

function [y] = allpass()

g = 0.7;
M = [113 337 1051];

b = [-g zeros(1,M(1)-1) 1];
a = [1 zeros(1,M(1)-1) -g];

%x = signal;
x = [1 zeros(1, 4000)]; % comment out to get reverb on man talking
y = filter(b, a, x);

y = x;
for n = 1:length(M),
  b = [-g zeros(1,M(n)-1) 1];
  a = [1 zeros(1,M(n)-1) -g];
  y = filter(b, a, y);
end

% figure()
% plot(y);
% ylabel('Impulse Response');
% xlabel('Time [samples]');

end







