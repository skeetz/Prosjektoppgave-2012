[x1,f1] = wavread('sound/ssm1.wav'); % Count
[x2,f2] = wavread('sound/ssm2.wav'); % Music


x1 =x1(1:109936/4); % set vectors to equal length
x2 =x2(1:109936/4);

window = 512;
noverlap = 500;
nfft = 512;
[S1,F1,T1,P1] = spectrogram(x1,window,noverlap,nfft,f1);
[S2,F2,T2,P2] = spectrogram(x2,window,noverlap,nfft,f2);

%% Plot spectrograms
figure(1)
subplot(211)
surf(T1,F1,10*log10(P1),'edgecolor','none'); axis tight;
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz'); title('source 1')

subplot(212)
surf(T2,F2,10*log10(P2),'edgecolor','none'); axis tight;
view(0,90);
xlabel('Time (Seconds)'); ylabel('Hz'); title('source 2')



%% gmm estimation
% Roweis 512 components for voice, 32 for noise
gmm1 = gmdistribution.fit(-log(P1)', 50, 'SharedCov', true);
gmm2 = gmdistribution.fit(-log(P2)', 32, 'SharedCov', true);

gmms = cell(2,1);
gmms{1} = gmm1;
gmms{2} = gmm2;


%% Estimation
[nBands, T] = size(Pmix);

totalComponents = zeros(length(gmms),1);
for i = 1:length(totalComponents) totalComponents(i) = gmms{i}.nComponents; end

stateSeq = zeros(2,T); %array of (source, component) indices

B = cell(length(gmms),1);       % Bound


for t = 1:T
    
    X = P2(:,t);
    
    remaining = totalComponents;    % Number of components not evaluated
    minB = Inf;
    minIdx = zeros(2,1);
    

    % Initial bound estimate
    for (m = 1:length(gmms)) % Iterate over sources
        B{m} = cell(gmms{m}.NComponents,1)
        for (k = 1:gmms{m}.NComponents) % iterate over gmm components
            B{m}{k} = -.5 * sum(X - gmms{m}.mu(k,:))^2 - .5*nBands*log(det(gmms{m}.sigma)); % todo: add last term
            if(B{m}{k} < minB)
                minB = B{m}{k};
                minIdx = [m,k];
            end
        end
    end
    % compute best likelihood estimate
    l0 = mvnpdf(X, gmms{minIdx(1)}.mu(minIdx(2),:), gmms{minIdx(1)}.sigma);
    
    while(any(remaining>0))
        
        % Compare bounds to max likelihood estimate
        for m = 1:length(gmms)
            for k = 1:gmms{m}.NComponents
                if (B{m}{k} < l0) 
                    B{m}{k} = -Inf; 
                    remaining(m) = remaining(m) -1;
                else % compute likelihood
                    likelihood = mvnpdf(X, gmms{m}.mu(k,:), gmms{m}.sigma);
                    if (likelihood > l0{m})
                        l0 = likelihood;
                        minIdx = [m,k];
                    else
                        B{m}{k} = -Inf;
                        remaining(m) = remaining(m) - 1;
                    end
                end
            end
        end

        
    end
    
    % set state sequence
    stateSeq(:,t) = minIdx;
    
    
end