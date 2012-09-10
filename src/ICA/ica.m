function [y,w] = Ica(x,alpha,Niter,Blocks)

switch nargin
    case 0
        error('Too few input args.')
    case 1
        alpha = 0.005; 
        Niter = 20000;
        Blocks = 50; 
    case 2
        Niter = 20000;
        Blocks = 50; 
    case 3
        Blocks = 50;
end
        

N=size(x,1); P=size(x,2); M=N;
wz = whiteningMat(x);
xx=inv(wz)*x;

w=eye(N); 
perm=randperm(P); 
Id=eye(M);


for i = Niter
    w = update(x,w);
end

y=w*wz*xx;

    function wz = whiteningMat(x)
        %% Whitening transform
        mx=mean(x,2)';
        x=x-(ones(P,1)*mx)';
        c=cov(x');
        wz=2*inv(sqrtm(c));        
    end

    function w = update(x,w)
        %% main update
        x=x(:,perm);
        t=1;
        noblocks=fix(P/Blocks);
        BlocksI=Blocks*Id;
        for t=t:Blocks:t-1+noblocks*Blocks,
          u=w*x(:,t:t+Blocks-1); 
          w=w+alpha * ( BlocksI + (1-2*(1./(1+exp(-u))))*u') * w;
        end;
    end
end