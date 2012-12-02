function Y = maxvq(X, gmms, more_params)


Y = zeros(length(gmms), size(X,2));

for (i = 1:size(X,2))  % Iterate over spectrogram columns
  
  % Initial bound estimate
  B = cell(length(gmms),1);
  remaining = 0; % keep count of how many combinations left to evaluate
  for (m = 1:length(gmms)) % Iterate over sources
    B{m} = cell(length(gmms(m)),1)
    remaining = remaining + length(gmms(m));
    for (k = 1:length(gmms(m)) % iterate over gmm components
      B{m}{k} = computeBound(); % add args
    end
  end  
  l0 = loglikelihood(); % add args
  
  
  % Now iterate over all combinations comparing l0 with computed bounds
  for (m = 1:length(gmms))
    for (k = 1:length(gmms(m)))
      if (B{m}{k} < l0) 
	B{m}{k} = -Inf; % mark (source/component) combinations below bound
	remaining = remaining -1;
      end;
    end
  end

  % compute log likelihood for remaining (source/component) combinations
  while(remaining >1) % or 1
    likelihoods = cell(length(gmms),1);
    for (m = 1:length(gmms))
      likelihoods{m} = cell(length(gmms(m)),1);
      for (k = 1:length(gmms(m)))
	likelihoods{m}{k} = loglikelihood(); % args
	remaining = remaining -1;
	if (likelihoods{m}{k} < l0) % new bound?
	  l0 = likelihoods{m}{k};
	  break;
	end
      end
    end
    
  % Now iterate over all combinations comparing with new bound
  for (m = 1:length(gmms))
    for (k = 1:length(gmms(m)))
      if (B{m}{k} < l0) 
	B{m}{k} = -Inf; % mark (source/component) combinations below bound
	remaining = remaining -1;
      end;
    end
  end    
    
  end % end while
  
  % Set Y to equal last (source/component combination)
  
end

%function B = computeBound(params) return 0;


%function l = logLikelihood(params) return 0;

