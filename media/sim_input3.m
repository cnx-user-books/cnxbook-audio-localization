function [region,theta_range] = sim_input3(theta_true,degree)

% Values, Vectors, and a Matrix

c = 346.287;                    % speed of sound in air
N = 150;                        % length of the sample buffer
Fs = 44100;                     % sampling frequency
f = 500;                       % frequency of sine wave
M = 2;                          % number of microphones
%dist = .32;                     % distance between microphones
dist = .5;
t = [0:N-1]./Fs;                % time axis
m = (M-1)./2;                   % array center
x = dist.*[-m:m];               % microphone location on the x axis
cutoff = 50;                    % cutoff frequency of filter
omega = 2*pi*f;                 % commonly used value
theta_test = [1:2:2*degree-1]*pi/(2*degree); % test vector of theta values
divisor = degree/8;             % region divisor
length_t = length(theta_test);   % length of the delay vector
A = zeros(1,length_t);           % initialize A vector
B = fir1(40,cutoff/Fs,'low');        % lowpass filter
delay_true = x.*cos(theta_true)./c;  % actual delay
delay_test = x'*cos(theta_test)./c;  % test matrix of delay values
samples = round(2.*delay_test*Fs)./2;        % number of samples to shift in testing
index = samples - ones(M,1)*min(samples) + 1;
cos_base = cos(omega*t(1:N));
sin_base = sin(omega*t(1:N));
SNR = 1000;
noise1 = randn(1,N)/SNR;
noise2 = randn(1,N)/SNR;

% Signal Simulation

y1 = sin(omega*(t-delay_true(1))) + noise1;
y2 = sin(omega*(t-delay_true(2))) + noise2;

% Region Approximation

for i = [1:length_t]
    y1_sample = y1(index(1,i):index(1,i)+40);    %delay y1 by the 1,i value using index
    y2_sample = y2(index(2,i):index(2,i)+40);
    z = y1_sample + y2_sample;
    z_cos = z.*cos_base(1:41);
    z_sin = z.*sin_base(1:41);
    
    z_cos_filter = sum(fliplr(z_cos).*B);
    z_sin_filter = sum(fliplr(z_sin).*B);
   
    A(i) = z_sin_filter^2 + z_cos_filter^2;
end

% figure
% plot(theta_test,A);
% title(theta_true)

aa = find(A == max(A));
region = floor(aa(1)./divisor);

if(0)
theta_range = [region-1 region]*pi/8;
figure
plot(theta_test/pi,A)
end
