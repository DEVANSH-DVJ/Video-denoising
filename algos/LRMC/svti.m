
function [Q, iter]=svti(P, Omega, tau, kmax, tol, sec_missing)
    % Input:
    %   P           : noisy patch matrix with missing pixels, [64 n2] (double)
    %   Omega       : boolean matrix of known pixels, [64 n2] (logical)
    %   tau         : step size
    %   kmax        : maximum iterations
    %   tol         : tolerance
    %   sec_missing : whether second subset of missing pixels to be taken
    % Output:
    %   Q    : denoised patch matrix, [64 n2] (uint8)
    %   iter : iterations required
    % Brief:
    %   Apply SVT on the patch matrix to remove noise and fill in missing pixels

    n2 = size(P, 2);

    % Finding sigma and mean for each row
    sigma_bar = zeros(64, 1, 'double');
    for i=1:64
        Pi = P(i,:);
        sigma_bar(i) = std(Pi(Omega(i,:)));

        % Second subset of missing pixels
        if sec_missing
            mu_bar = mean(Pi(Omega(i,:)));
            Omega(i,:) = Omega(i,:) & (Pi <= mu_bar + 2 * sigma_bar(i)) & (Pi >= mu_bar - 2 * sigma_bar(i));
        end
    end

    % Calculating mu
    sigma_hat = mean(sigma_bar);
    p = sum(Omega, 'all')/numel(Omega);
    mu = (8 + sqrt(n2)) * sqrt(p) * sigma_hat;
    lambda = tau*mu;

    % Initializing
    Q = zeros(size(P), 'double');

    % Iteration
    for k=1:kmax
        % Projection Operator
        P_ = Q - P;
        P_(~Omega) = 0;

        % SVD on residual R
        R = Q - tau * P_;
        [U, S, V] = svd(R, 'econ');

        % Soft thresholding of singular values by lambda
        Q_new = U * diag(max(diag(S) - lambda, 0)) * V';

        % Check convergence condition
        if (norm(Q_new - Q, 'fro') <= tol)
            Q = Q_new;
            break;
        end

        % Save and continue
        Q = Q_new;
    end

    iter = k;
end
