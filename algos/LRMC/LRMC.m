function [recon, filtered] = LRMC(noisy, frameno, tau, kmax, tol, variant)
    % Input:
    %   noisy   : noisy video, [dim1 dim2 nframes] (uint8)
    %   frameno : frame number to be denoised
    %   tau     : step size
    %   kmax    : maximum iterations
    %   tol     : tolerance
    %   variant : two binary digits representing
    %               { whether second subset of missing pixels to be taken and
    %                 replace in patchArr after every iteration }
    % Output:
    %   recon    : denoised video, [dim1 dim2 nframes] (uint8)
    %   filtered : video after applying adaptive median filter, [dim1 dim2 nframes] (uint8)
    % Brief:
    %   Using Low Rank Matrix Completion to denoise video

    % Switch case on variant
    switch variant
        case '00'
            sec_missing = false;
            replace = false;
        case '01'
            sec_missing = false;
            replace = true;
        case '10'
            sec_missing = true;
            replace = false;
        case '11'
            sec_missing = true;
            replace = true;
        otherwise
            warning('incorrect variant - setting to default variant: 01');
    end

    [dim1, dim2, nframes] = size(noisy);

    % Applying adaptive median filter
    filtered = zeros([dim1 dim2 nframes], 'uint8');
    for i=1:nframes
        filtered(:,:,i) = adapmedfilt(noisy(:,:,i), 11);
    end

    % Finding out the first subset of missing pixels
    missing = (filtered ~= noisy);

    % Generating patch array and missing array
    patchArr = zeros([64 (dim1/4 - 1) (dim2/4 - 1) nframes], 'uint8');
    missingArr = false(size(patchArr));

    for i=1:nframes
        for j=1:(dim1/4 - 1)
            for k=1:(dim2/4 - 1)
                patchArr(:,j,k,i) = reshape(filtered((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i), [64 1]);
                missingArr(:,j,k,i) = reshape(missing((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i), [64 1]);
            end
        end
    end

    % Iteratively denoising each patch
    denoisedpatchArr = zeros(size(patchArr), 'double');
    for refj=1:(dim1/4 - 1)
        for refk=1:(dim2/4 - 1)

            % Getting indices of matching patches
            indices = patchmatcher(patchArr, refj, refk, frameno);

            % Creating patch matrix and Omega
            patchMat = zeros(64, size(indices, 2), 'uint8');
            patchOmega = false(64, size(indices, 2));
            for i=1:size(indices,2)
                patchMat(:,i) = patchArr(:, indices(1,i), indices(2,i), indices(3,i));
                patchOmega(:, i) = ~missingArr(:, indices(1,i), indices(2,i), indices(3,i));
            end

            % Running our SVT algorithm
            [denoisedpatchMat, ~] = svti(cast(patchMat, 'double'), patchOmega, tau, kmax, tol, sec_missing);

            % Finding the index of the reference patch in patch matrix
            for selfind=1+5*(frameno-1):5*frameno
                if (indices(:, selfind) == [refj; refk; frameno;])
                    break;
                end
            end

            % Updating the reference patch
            if replace
                patchArr(:, refj, refk, frameno) = denoisedpatchMat(:, selfind);
            end
            denoisedpatchArr(:, refj, refk, frameno) = denoisedpatchMat(:, selfind);
        end
    end

    % Averaged reconstruction from denoised patch array
    recon = zeros(size(filtered), 'double');
    weight = recon;
    for i=1:nframes
        for j=1:(dim1/4 - 1)
            for k=1:(dim2/4 - 1)
                recon((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) = recon((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) + reshape(denoisedpatchArr(:,j,k,i), [8 8]);
                weight((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) = weight((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) + 1;
            end
        end
    end
    recon = recon ./ weight;
    % Casting it to uint8 for consistency
    recon = cast(recon, 'uint8');
end
