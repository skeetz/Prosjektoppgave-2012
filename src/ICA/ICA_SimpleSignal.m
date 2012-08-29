% initialization
t = 0:.01:10;

 f1 = @(x) sin(pi*x);
 f2 = @(x) cos(7*pi*x);

% f1 = @(x) sin(3*pi*x);
% f2 = @(x) sign(cos(50*x));

s = [f1(t); f2(t);] + .03*randn(size(2,length(t)));  %original signal
[n,m] = size(s);

% mixing
a = [2,1;1,2];
%a = rand(2);
x = (a*s);


[wd,wm,uwm,mx] = preprocess(x);
[y,w] = ica(wd, 1000, .1, .0001);
%y = uwm*y;

figure(1)
subplot(311), plot(s','LineWidth',2), title('Source Signals'), axis tight, grid on
subplot(312), plot(x','LineWidth',2), title('Mixed Signals'), axis tight, grid on
subplot(313), plot(y','LineWidth',2), title('Recovered Signals'), axis tight, grid on

