
function [pcaed]=pcai(P, C)
    % assume noisy patch matrix is of size ([64 n2]) (double)
    % n2 must be greater than 64
    % We have to apply Principal Components Analysis
    % taking C of the dimensions

    % Output would be denoised patch matrix of same dimension

    % centering the data
    meanpatch = mean(P,2);
    centered = P - meanpatch;

    % normalising
    arr = sqrt(sum(centered.^2, 2) / size(centered, 2)); % standard deviation
    onebyarr = 1 ./ arr;
    normalised = centered.*(onebyarr);

    % principal component analysis
    [coeff, score, ~] = pca(normalised');

    % data with reduced dimensions
    reduced = score(:,1:C) * ((coeff(:,1:C))');

    % De-normalising
    newcentered = (reduced').*arr;

    % De-centering
    pcaed = newcentered + meanpatch;
end
