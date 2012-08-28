function [whitened_data, whitening_matrix, unwhitening_matrix, mean_x] = preprocess(x)
  mean_x = repmat(mean(x,2), 1,size(x,2));
  x = x-mean_x;
  cv = x*x';
  [E,D] = eig(cv);
  whitening_matrix = E*inv(sqrt(D))*E';
  unwhitening_matrix = inv(whitening_matrix);
  whitened_data = whitening_matrix*x;
end
