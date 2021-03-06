
%% Read data
x1 = wavread('sound/ssm1');
x2 = wavread('sound/ssm2');
x1 =x1(1:109936);
x2 =x2(1:109936);
s = [x1 x2]';

%% Read signals
a = rand(2);
mix = a*s;

%% Run ica on mixed stuff
[y,w] = ica(mix);


%% Play sounds
% y(1,:) = y(1,:) * std(s(1,:))/std(y(1,:));
% sound(y(1,:), 16384)
% 
% y(2,:) = y(2,:) * std(s(2,:))/std(y(2,:));
% sound(y(2,:), 16384)

%% Plot signals
figure;
subplot(321), plot(s(1,:)), axis tight, grid on, title('Original Signals')
subplot(322), plot(s(2,:)), axis tight, grid on
subplot(323), plot(mix(1,:)), axis tight, grid on, title('Mixed Signals')
subplot(324), plot(mix(2,:)), axis tight, grid on
subplot(325), plot(y(1,:)), axis tight, grid on, title('Recovered Signals')
subplot(326), plot(y(2,:)), axis tight, grid on

%% Measure of difference between original and mix
norm(s(1,:)-y(1,:))+norm(s(2,:) - y(2,:))