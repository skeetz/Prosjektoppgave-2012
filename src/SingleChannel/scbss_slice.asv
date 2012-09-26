%% Slicing in the power spectrum
function P1 = scbss_slice(P0, F_slices)
    [n,m] = size(P0);
    r = ceil(n/F_slices);
    P1 = zeros(F_slices, m);
    for(i=1:m)
       for(j=1:F_slices-1)
           val = sum(P0((j-1)*r+1:min(j*r, n),i))/r;
           
           P1(j, i) = val;
       end
    end

end