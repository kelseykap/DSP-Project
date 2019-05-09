function [theta, t] = echodensity(h,fs)
t1 = 100;
t2 = 10E4;
% t2 = 0.1*fs;
L = round(0.02*fs/2);
length(h)
w = hann(L*2+1);
w = w/sum(w);
theta = zeros(1,t2);
t2-2*L-1
%for n = 1:1:t2-2*L-1
for n = 1:1:(t2-2*L-1)/3
    segma = sqrt(sum(w.*h(n:n+2*L).^2));
    theta(n) = sum(w.*(abs(h(n:n+2*L))>segma));
end
theta = theta/erfc(1/sqrt(2));
theta = [zeros(1,L) theta];
t = t1:t2;