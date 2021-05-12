
function [Q, iter]=svt(P, Omega, tau)
    % assume noisy patch matrix is of size ([64 n2]) (double)
    % We have to apply singular value thresholding (tolerance 1e-5)

    % Output would be denoised patch matrix of same dimension

    n2 = size(P, 2);
    p = sum(Omega, 'all')/numel(Omega);
    sigma_bar = zeros(64, 1, 'double');
    for i=1:64
        Pi = P(i,:);
        sigma_bar(i) = std(Pi(Omega(:,i)));
    end
    sigma_hat = mean(sigma_bar);

    mu = (8 + sqrt(n2)) * sqrt(p) * sigma_hat;
    n = min(64, n2);

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

    iter = k;
end

