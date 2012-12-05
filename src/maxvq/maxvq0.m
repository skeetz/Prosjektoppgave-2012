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


%% Estimation
[nBands, T] = size(Pmix);

totalComponents = zeros(length(gmms),1);
for i = 1:length(totalComponents) 
    totalComponents(i) = gmms{i}.NComponents; 
end

spectOut = zeros(size(Pmix));
B = cell(length(gmms),1);       % Bound
l0 = zeros(length(gmms),1);


sigInv = cell(length(gmms),1);
sigDet = cell(length(gmms),1);
sigmas = cell(length(gmms),1);
for m = 1:length(gmms) 
    sigmas{m} = diag(gmms{m}.Sigma);
    sigDet{m} = det(sigmas{m});
    sigInv{m} = inv(sigmas{m});
end

Pmix = -log(Pmix);

for t = 1:T
    
    X = Pmix(:,t)';
    
    
    remaining = totalComponents;    % Number of components not evaluated
    minB = ones(length(gmms),1)*Inf;
    minIdx = zeros(length(gmms),1);
    
    % Initial bound estimate
    for m = 1:length(gmms) % Iterate over sources

        B{m} = cell(gmms{m}.NComponents,1);
        for k = 1:gmms{m}.NComponents % iterate over gmm components
            B{m}{k} = -.5 * sum(max(X - gmms{m}.mu(k,:), 0).^2) - .5*nBands*log(sigDet{m}) - log(1/gmms{m}.NComponents); % assume equal apriori probs
            if(B{m}{k} < minB(m))
                minB(m) = B{m}{k};
                minIdx(m) = k;
            end
        end
        % compute best likelihood estimate for each source
        mu = gmms{m}.mu(minIdx(m),:);
        l0(m) = -.5* nBands*log(2*pi)+ -.5*log(sigDet{m}) - .5 * (X-mu)*sigInv{m}*(X-mu)';
    end
    
    %Best likelihood component estimate
    l0Max = max(l0);
    
    while(any(remaining>0))
        
        % Compare bounds to max likelihood estimate
        for m = 1:length(gmms)
            for k = 1:gmms{m}.NComponents
                
                if (B{m}{k} < l0(m))
                    B{m}{k} = -Inf; 
                    remaining(m) = remaining(m) -1;
           
                else % compute likelihood
                    likelihood = mvnpdf(X, gmms{m}.mu(k,:), sigmas{m});
                    
                    if (likelihood > l0(m))
                        l0(m) = likelihood;
                        minIdx(m) = k;
                    else
                        B{m}{k} = -Inf;
                        remaining(m) = remaining(m) - 1;
                    end
                end
            end
        end
    end
    
    % output spectrogram
    bestIdx = find(l0 == max(l0),1);
    bestMu = gmms{bestIdx}.mu(minIdx(bestIdx),:);
    mus = zeros(nBands,length(gmms));
    %Her skjer det noe tull
    for i = 1:length(gmms)%for i = 1:length(mus)
        mus(:,i) = gmms{i}.mu(minIdx(i),:)';
    end
    i = [1:(bestIdx-1) (bestIdx+1):length(gmms)];
    mus = mus(:,i);
    bestMu = repmat(bestMu, 1, size(mus,2))';
    masks = sum(bestMu<mus,2);
    spectOut(:,t) = X(masks==0)';
end



