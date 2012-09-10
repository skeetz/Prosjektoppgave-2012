

% source signal
t = 0:.01:2*pi; 
s=[sin(4*pi*t)' sign(cos(9*t))']';

a = rand(2);
a = [.23,.97;.22,.28];
x = (a*s);

[y,w] = Ica(x);

figure(1)
subplot(311), plot(s','LineWidth',2), title('Source Signals'), axis tight, grid on
subplot(312), plot(x','LineWidth',2), title('Mixed Signals'), axis tight, grid on
subplot(313), plot(y','LineWidth',2), title('Recovered Signals'), axis tight, grid on

