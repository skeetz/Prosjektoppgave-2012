addpath('ICA','PCA');

% signal
t = 0:.01:10;
f1 = @(x) sin(pi*x);
f2 = @(x) cos(7*pi*x);
s = [f1(t); f2(t);];
s =s + .2*randn(size(2,length(t))); 
[n,m] = size(s);

% mixing
% ang = pi/4;%
% a = [cos(ang) -sin(ang);sin(ang), cos(ang)];
a = randn(2);
x = (a*s);

% pca
x_std = standardize(x); % standardize
[u,S,v] = svd(x_std',0); % pca

% ica
[wd,wm,uwm,mx] = preprocess(x);
[y,w] = ica(wd, 1000, .1, .0001);


figure(2), clf,title('Data - Eigenvectors')
scatterhist(x_std(1,:), x_std(2,:)), xlabel('X_1'), ylabel('X_2')
hold on
quiver(0,0,v(1,1),v(2,1), 'LineWidth',2)
quiver(0,0,v(1,2),v(2,2), 'LineWidth',2)
title('Data - Eigenvectors')
quiver(-2,0,w(1,1),w(2,1), 'LineWidth',2)
quiver(-2,0,w(1,2),w(2,2), 'LineWidth',2)

figure(1)
subplot(411), plot(s','LineWidth',2), title('Source Signals'), axis tight, grid on
subplot(412), plot(x','LineWidth',2), title('Mixed Signals'), axis tight, grid on
subplot(413), plot(u, 'LineWidth', 2), title('Recovered Signals PCA')
subplot(414), plot(y','LineWidth',2), title('Recovered Signals ICA'), axis tight, grid on