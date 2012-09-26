%% Read data
%[x1,F1] = wavread('sound/ssm1');
%[x2,F2] = wavread('sound/ssm2');

%Fs = (F1 + F2)/2; % avg sampling freq.
%x1 =x1(1:109936); % set vectors to equal length
%x2 =x2(1:109936);
%s = [x1 x2]';

t = 0:.01:20;

f1 = @(x) sin(pi*x);
f2 = @(x) cos(50*pi*x);

s = [f1(t); f2(t);];


%% Mix

a = randn(1,2);
mix = a*s;
figure(3), subplot(311), plot(t, f1(t)), title('Sine')
subplot(312), plot(t, f2(t)), title('Cosine')
subplot(313), plot(t, mix); title('Mix')
%figure(3), subplot(311), plot(f1), title('Original - count 1-10')
%subplot(312), plot(f2), title('Original - music')
%subplot(313), plot(mix), title('Mix')
%sound(mix, Fs)

%% Do the magic 
% short term fourier ( mix )

window = 200;
noverlap = 100;
nfft = 256;
[S,F,T,P] = spectrogram(mix,window,noverlap,nfft);
[S0,F0,T0,P0] = spectrogram(s(1,:),window,noverlap,nfft);
[S1,F1,T1,P1] = spectrogram(s(2,:),window,noverlap,nfft);


figure(1), clf, subplot(311),
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz'); title('Mix')

% short term fourier ( source1 )

% short term fourier ( source2 )

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
P0 = scbss_slice(P0, 32);
%F0 = F0(1:128);
P1 = scbss_slice(P1, 32);
%F1 = F1(1:128);



figure(15)
surf(10*log10(P0),'edgecolor','none'); axis tight; 
view(0,90);

%TODO: test at P0 har maks i 1, 7 for hhv sin og cos bølge

figure(11)
surf(10*log10(P1),'edgecolor','none'); axis tight; 
view(0,90);

trans_guess_speaker = randn(128); est_guess_speaker = randn(128);
trans_guess_music = randn(128); est_guess_music = randn(128);
for(i=1:128)
    est_guess_speaker(i,:) = est_guess_speaker(i,:)./sum(est_guess_speaker(i,:));
    trans_guess_speaker(i,:) = trans_guess_speaker(i,:)./sum(trans_guess_speaker(i,:));
    est_guess_music(i,:) = est_guess_music(i,:)./sum(est_guess_music(i,:));
    trans_guess_music(i,:) = trans_guess_music(i,:)./sum(trans_guess_music(i,:));
end

scaleToInterval = @(x, minInterval, maxInterval) ceil((x-min(x))./max(x) * maxInterval + minInterval);

%P0Max = max(max(P0));
%P1Max = max(max(P1));
%P0 = ceil(P0*128/P0Max);
%P1 = ceil(P1*128/P1Max);
    

for i = 1:size(P0,2)
   P0(:,i) =  scaleToInterval(P0(:,i), 1, 127);
   P1(:,i) = scaleToInterval(P1(:,i), 1, 127);
end

% set size according to no of states and make a better guess

[trans0_speaker, sensor0_speaker] = hmmtrain(P0, trans_guess_speaker, est_guess_speaker);
[trans1_music, sensor1_music] = hmmtrain(P1, trans_guess_music, est_guess_music);

trans0_speaker
sensor0_speaker
trans1_music
sensor1_music
% recover mix..
