%% Read data
[x1,F1] = wavread('sound/ssm1');
[x2,F2] = wavread('sound/ssm2');

x1 =x1(1:109936/4); % set vectors to equal length
x2 =x2(1:109936);
%s = [x1 x2]';

%t = 0:.01:20;

%f1 = @(x) sin(pi*x);
%f2 = @(x) cos(50*pi*x);

%s = [f1(t); f2(t);];


%% Mix
% 
% a = randn(1,2);
% mix = a*s;
% figure(3), subplot(311), plot(t, f1(t)), title('Sine')
% subplot(312), plot(t, f2(t)), title('Cosine')
% subplot(313), plot(t, mix); title('Mix')
%figure(3), subplot(311), plot(f1), title('Original - count 1-10')
%subplot(312), plot(f2), title('Original - music')
%subplot(313), plot(mix), title('Mix')
%sound(mix, Fs)


%% Do the magic 
% short term fourier ( mix )

window = 256;
noverlap = 250;
nfft = 256;
[S,F,T,P] = spectrogram(x1,window,noverlap,nfft,F1);
%[S0,F0,T0,P0] = spectrogram(s(1,:),window,noverlap,nfft);
%[S1,F1,T1,P1] = spectrogram(s(2,:),window,noverlap,nfft);



surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz'); title('speaker1')



%% gmm

p0 = -log(P);
gmm1 = gmdistribution.fit(p0', 50, 'SharedCov', true);




%trans1 = rand(10);
%trans1 = trans1./repmat(sum(trans1,2),1,10);

% %%  HMMBSS
% 
% % training on original data (x1, x2), separate HMMs
% 
% %
% trans_guess_speaker = randn(128); est_guess_speaker = randn(128);
% trans_guess_music = randn(128); est_guess_music = randn(128);
% for(i=1:128)
%     est_guess_speaker(i,:) = est_guess_speaker(i,:)./sum(est_guess_speaker(i,:));
%     trans_guess_speaker(i,:) = trans_guess_speaker(i,:)./sum(trans_guess_speaker(i,:));
%     est_guess_music(i,:) = est_guess_music(i,:)./sum(est_guess_music(i,:));
%     trans_guess_music(i,:) = trans_guess_music(i,:)./sum(trans_guess_music(i,:));
% end
% 
% scaleToInterval = @(x, minInterval, maxInterval) ceil((x-min(x))./max(x) * maxInterval + minInterval);
% 
% %P0Max = max(max(P0));
% %P1Max = max(max(P1));
% %P0 = ceil(P0*128/P0Max);
% %P1 = ceil(P1*128/P1Max);
%     
% 
% for i = 1:size(P0,2)
%    P0(:,i) =  scaleToInterval(P0(:,i), 1, 127);
%    P1(:,i) = scaleToInterval(P1(:,i), 1, 127);
% end
% 
% % set size according to no of states and make a better guess
% 
% [trans0_speaker, sensor0_speaker] = hmmtrain(P0, trans_guess_speaker, est_guess_speaker);
% [trans1_music, sensor1_music] = hmmtrain(P1, trans_guess_music, est_guess_music);
% 
% trans0_speaker
% sensor0_speaker
% trans1_music
% sensor1_music
% % recover mix..
