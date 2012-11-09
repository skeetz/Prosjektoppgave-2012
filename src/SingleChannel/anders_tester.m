%s = wavread('E:\Skole\Prosjektoppgave\Prosjektoppgave-2012\src\SingleChannel\sound\ssm1.wav')

[s1,F0] = wavread('E:\Skole\Prosjektoppgave\Prosjektoppgave-2012\src\SingleChannel\sound\ssm1.wav');
[s2,F0] = wavread('E:\Skole\Prosjektoppgave\Prosjektoppgave-2012\src\SingleChannel\sound\ssm2.wav');

s1 = s1(1:length(s2));


mix = .3*s1 + .7*s2; %% todo: more sophisticated mixing

%% spectrogram mix

[S,F,T,P] = spectrogram(mix,256,250,256,F0);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz');


%% spectrogram Teller


[S,F,T,P] = spectrogram(s1,256,250,256,F0);
surf(T,F,10*log10(P),'edgecolor','none'); axis tight; 
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz');


%%
p = log(P(:,1:3000)); 
gm = gmdistribution.fit(p', 129, 'SharedCov', true);

%f0 = repmat(F, 1, 18281)
%x = -log(P).*f0;
%gm = gmdistribution.fit(P(), 129, 'Options', options, 'SharedCov',true);

