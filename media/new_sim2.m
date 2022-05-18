function new_sim2(theta_true)
% Values, Vectors, and a Matrix
%theta_true = pi./2;
degree = 32;

c = 346.287;                    % speed of sound in air
N = 150;                        % length of the sample buffer
Fs = 48000;                     % sampling frequency
f = 500;                       % frequency of sine wave
M = 2;                          % number of microphones
dist = .1;
t = [0:N-1]./Fs;                % time axis
m = (M-1)./2;                   % array center
x = dist.*[-m:m];               % microphone location on the x axis
omega = 2*pi*f;                 % commonly used value

theta_test = [1:2:2*degree-1]*pi/(2*degree); % test vector of theta values
%theta_test = pi./2;
divisor = degree/8;             % region divisor
length_t = length(theta_test);   % length of the delay vector
A = zeros(1,length_t);           % initialize A vector

delay_true = x.*cos(theta_true)./c;  % actual delay
delay_test = x'*cos(theta_test)./c;  % test matrix of delay values
samples = round(2.*delay_test*Fs)./2;        % number of samples to shift in testing
index = samples - ones(M,1)*min(samples) + 1;


% Signal Simulation

for j = 1:M
    y(j,:) = sin(omega*(t-delay_true(j)));
end

% Region Approximation

for i = [1:length_t]
    for j = [1:M]
        y_delay(j,:) = y(j,[index(j,i)+50:index(j,i)+100]);    %delay y1 by the 1,i value using index
    end
    z = sum(y_delay);

    A(i) = sum(z.^2);
end

aa = find(A == max(A));
region = floor(aa(1)./divisor)
theta_range = [region-1 region]*pi/8;
if(0)
figure
plot(theta_test/pi,A)
end