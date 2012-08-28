% BSS using pca.
% Randomized mixing matrix

clc;clf;clear;

% initialization
t = 0:.01:5;

f1 = @(x) sin(3*pi*x);
f2 = @(x) sign(cos(50*x));

s = [f1(t); f2(t);] + .03*randn(size(2,length(t)));  %original signal
[n,m] = size(s);

ang = pi/4;%rand()*2*pi;
a = [cos(ang) -sin(ang);sin(ang), cos(ang)];
x = (a*s);

x_std = standardize(x); % standardize
[u,S,v] = svd(x_std',0); % pca


disp('Mixing matrix')
a
disp('Recovered mixing matrix') 
v


figure(1)
subplot(311),plot(s', 'LineWidth',2), title('Original')
subplot(312),plot(x_std','LineWidth',2), title('Mixed')
subplot(313), plot(u, 'LineWidth', 2), title('Recovered')

figure(2), clf,title('Data - Eigenvectors')
scatterhist(x_std(1,:), x_std(2,:))
hold on
quiver(0,0,v(1,1),v(2,1), 'LineWidth',2)
quiver(0,0,v(1,2),v(2,2), 'LineWidth',2)
title('Data - Eigenvectors')

figure(3), clf, scatterhist(u(:,1), u(:,2));
title('Data projected onto PCs')
