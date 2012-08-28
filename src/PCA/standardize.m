function x_std = standardize(x)
% Standardize data along dimension 2.
x_std = (x - repmat(mean(x,2), 1, size(x,2))) ./ ...
    repmat(std(x,0,2), 1, size(x,2));
end