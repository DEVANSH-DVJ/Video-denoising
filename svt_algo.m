clc;
clear;
close all;

rng(1);

load('patchMat');
load('patchOmega');

P = cast(patchMat, 'double'); clear patchMat;
Omega = patchOmega; clear patchOmega;

figure; imshow(cast(P, 'uint8'));
Sp = svd(P);
figure; plot(Sp);

[n1, n2] = size(P);
p = sum(Omega, 'all')/numel(Omega);
sigma_bar = zeros(n1, 1, 'double');
for i=1:n1
    Pi = P(i,:);
    sigma_bar(i) = std(Pi(Omega(:,i)));
end
sigma_hat = mean(sigma_bar);

mu = (sqrt(n1) + sqrt(n2)) * sqrt(p) * sigma_hat;
tau = 1.5;
n = min(n1, n2);

tic;
Q = zeros(size(P), 'double');

for k=1:30
    P_ = Q - P;
    P_(~Omega) = 0;
    
    R = Q - tau * P_;
    [U, S, V] = svd(R);
    
    Q_new = U(:,1:n) * diag(max(diag(S) - tau*mu, 0)) * V(:,1:n)';
    
    if (norm(Q_new - Q, 'fro') <= 1e-5)
        break;
    end
    
    Q = Q_new;
end

toc;
figure; imshow(cast(Q, 'uint8'));
Sq = svd(Q);
figure; plot(Sq);
