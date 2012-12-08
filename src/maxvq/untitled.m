[x1,f1] = wavread('sound/ssm1.wav'); % Count
[x2,f2] = wavread('sound/ssm2.wav'); % Music


x1 =x1(1:109936/2); % set vectors to equal length
x2 =x2(1:109936/2);

mixer = round(rand(length(x1),1));
mix = x1.*(mixer == 1) + x2.*(mixer == 0);


window = 512;
noverlap = 500;
nfft = 512;
[S1,F1,T1,P1] = spectrogram(x1,window,noverlap,nfft,f1);
[S2,F2,T2,P2] = spectrogram(x2,window,noverlap,nfft,f2);
[Smix, Fmix, Tmix, Pmix] = spectrogram(mix, window, noverlap, nfft, f2);


%% Plot spectrograms
figure(1)
subplot(311)
surf(T1,F1,10*log10(P1),'edgecolor','none'); axis tight;
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz'); title('source 1')

subplot(312)
surf(T2,F2,10*log10(P2),'edgecolor','none'); axis tight;
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz'); title('source 2')

subplot(313)
surf(Tmix,Fmix,10*log10(Pmix),'edgecolor','none'); axis tight;
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz'); title('mixed signal')



%% gmm estimation
% Roweis 512 components for voice, 32 for noise
gmm1 = gmdistribution.fit(-log(P1)', 128, 'SharedCov', true, 'CovType', 'diagonal', 'Regularize', 1);
gmm2 = gmdistribution.fit(-log(P2)', 32, 'SharedCov', true, 'CovType', 'diagonal', 'Regularize', 1);

gmms = cell(2,1);
gmms{1} = gmm1;
gmms{2} = gmm2;



%%


for t = 1:T
    
    X = Pmix(:,t)';
    ll = cell{length(gmms),1}
    
    for m  = 1:length(gmms)
        ll{m} = zeros(length(gmms{m}),1);
        for k = 1:gmms{m}.NComponents
             ll{m}(k) = mvnpdf(X, gmms{m}.mu(k,:), gmms{m}.Sigma);
        end
    end
    
   fprintf('homo') 
    
end




