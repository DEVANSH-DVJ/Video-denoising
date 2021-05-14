
function [pcaed]=pcai(P, C)
    % Input:
    %   P : noisy patch matrix, [64 n2] (double)
    %   C : reduced dimension for PCA
    % Output:
    %   pcaed : denoised patch matrix, [64 n2] (uint8)
    % Brief:
    %   Apply C-dimensional PCA on the patch matrix to remove noise

    % Centering the data
    meanpatch = mean(P,2);
    centered = P - meanpatch;

    % Normalizing
    std_arr = sqrt(sum(centered.^2, 2) / size(centered, 2));
    reci_std_arr = 1 ./ std_arr;
    normalised = centered .* reci_std_arr;

    % Principal Component Analysis
    [coeff, score, ~] = pca(normalised');

    % Data with reduced (C) dimensions
    reduced = score(:,1:C) * ((coeff(:,1:C))');

    % De-normalizing
    newcentered = reduced' .* std_arr;

    % De-centering
    pcaed = newcentered + meanpatch;
end
