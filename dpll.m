% A second order DPLL design
% Block diagram
%             +---+  e    +-----------+      y
%    x ------>| + |------>|   H1(z)   |---------+  
%             +---+       +-----------+         |
%               ^                               |
%               |   z     +-----------+         |
%               |---------|  H2(z)    |<--------+
%                         +-----------+
% 
clear all;
close all;

fs=25; % Hz, number of PCR samples per second
samples=10000; % number of PCR samples in total
time=samples/fs; % in seconds
refclock=27e6; % PCR reference clock at 27MHz
clockdev = 810; % 30 ppm allowed quarz dev
sysclock=refclock + clockdev; % system clock is a bit faster
PCR=500000:refclock/fs:refclock*time-1; % with arbitrary start phase

% VCO gainfs=25
Gvco = 1; % chosen experimentally by MG

% input (reference) signal
xp = (rand(1,samples)-0.5*ones(1,samples)).*0.02*refclock + PCR;     % Jittered PCR vector [+-20ms]
%x = PCR;

% out-of-loop filter
%initialisation
x(1)=xp(1);
x(2)=0.5*(xp(1)+xp(2));

for i = 3: length(xp)
    x(i) = 0.25*xp(i) + 0.5*xp(i-1) + 0.25*xp(i-2);
end

% initialization
e(1) = 0;
y(1) = 0;
z(1) = sysclock;
p(1) = x(1)+z(1)/fs;

for i = 2 : length(x)
    % phase detector
    e(i) = x(i) - p(i-1);
    
    % loop filter H1(z), an IIR filter
    y(i) = 0.005*e(i) - 0.00499*e(i-1) + y(i-1);
    %y(i) = e(i);
        
    % VCO filter, an IIR accumulator
    z(i) = sysclock + Gvco * fs * y(i); 
    p(i) = p(i-1) + z(i)/fs;
end

figure
plot(e/refclock);
ylabel('Phase Error (e) [s]');

figure
plot(y);
ylabel('Phase Error (filtered) (y) [s]');

figure
plot(z);
ylabel('Frequency (controlled) (z) [Hz]');

figure
ylabel('PCR');
%plot(PCR/refclock, 'b-');
hold on;
plot((x-PCR)/refclock,'r-');
plot((p-PCR)/refclock-1/fs,'g-');
%legend('Original PCR', 'Jittered PCR', 'VCO Output (Restored PCR)');
hold off;