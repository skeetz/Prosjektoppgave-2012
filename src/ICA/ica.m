function [y,w] = ica(x, max_iter, learn_rate, epsilon)

  %% checks here
  
  [nSignals,nObs] = size(x);

  w = eye(nSignals).*randn(nSignals);  w_old = randn(nSignals);
  f = @(x) x.*exp(-.5*x.^2); f_diff = @(x) -x.^2*exp(-.5*x.^2);
  
  for i = 1:max_iter
    if norm(w-w_old)<epsilon, break, end;
    w = w/sqrt(norm(w*w'));
    w = 3/2*w -1/2 * w*w'*w;
    
  end
  if(i<max_iter)
    fprintf('Converged after %d iterations.\n', i);
  else
    fprintf('Search terminated after %d iterations.\n', i);
  end
			  
  y = w*x;
  
end