%% Read data
x1 = wavread('sound/ssm1');
x2 = wavread('sound/ssm2');
x1 =x1(1:109936);
x2 =x2(1:109936);
s = [x1 x2]';

%% Mix
a = rand(1,2);
mix = a*s;

figure, plot(mix)
sound(mix, 16384)

%% Do the magic

