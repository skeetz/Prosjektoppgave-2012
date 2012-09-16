%% Read data
[x1,F1] = wavread('sound/ssm1');
[x2,F2] = wavread('sound/ssm2');
Fs = (F1 + F2)/2; % avg sampling freq.
x1 =x1(1:109936); % set vectors to equal length
x2 =x2(1:109936);
s = [x1 x2]';

%% Mix
a = rand(1,2);
mix = a*s;

figure, plot(mix)
sound(mix, Fs)

%% Do the magic 1. short term fourier

window = 512;
noverlap = 400;
nfft = 256;
[S,F,T,P] = spectrogram(mix,window,noverlap,nfft);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz');

%%  HMMBSS

% training on original data (x1, x2), separate HMMs

% recover mix
