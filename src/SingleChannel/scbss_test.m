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

figure(3), subplot(311), plot(x1), title('Original - count 1-10')
subplot(312), plot(x2), title('Original - music')
subplot(313), plot(mix), title('Mix')
%sound(mix, Fs)

%% Do the magic 
% short term fourier ( mix )

window = 1024;
noverlap = 1000;
nfft = 1024;
[S,F,T,P] = spectrogram(mix,window,noverlap,nfft);
[S0,F0,T0,P0] = spectrogram(x1,window,noverlap,nfft);



figure(1), clf, subplot(311),
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz'); title('Mix')

% short term fourier ( source1 )

% short term fourier ( source2 )
[S1,F1,T1,P1] = spectrogram(x2,window,noverlap,nfft);

subplot(312)
surf(T0,F0,10*log10(P0),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz'); title('Original - count')
subplot(313)
surf(T1,F1,10*log10(P1),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz');title('Original - music')

%%  HMMBSS

% training on original data (x1, x2), separate HMMs

% todo: slice and dice in freq, t direction

trans_guess = randn(10); est_guess = randn(10); 
% set size according to no of states and make a better guess

[trans0, sensor0] = hmmtrain(P0, trans_guess, est_guess);
[trans1, sensor1] = hmmtrain(P1, trans_guess, est_guess);


% recover mix..
