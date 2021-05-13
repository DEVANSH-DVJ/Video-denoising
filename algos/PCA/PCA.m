function [final, denoised] = PCA(noisy, frameno, C, variant)

    switch variant
        case 1
            replace = true;
        case 2
            replace = false;
        otherwise
            warning('incorrect variant - setting to default 1');
    end

    [dim1, dim2, nframes] = size(noisy);

    denoised = zeros([dim1 dim2 nframes], 'uint8');
    for i=1:nframes
        denoised(:,:,i) = adapmedfilt(noisy(:,:,i), 11);
    end

    patchArr = zeros([64 (dim1/4 - 1) (dim2/4 - 1) nframes], 'uint8');

    for i=1:nframes
        for j=1:(dim1/4 - 1)
            for k=1:(dim2/4 - 1)
                patchArr(:,j,k,i) = reshape(denoised((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i), [64 1]);
            end
        end
    end

    denoisedpatchArr = zeros(size(patchArr), 'double');
    for refj=1:(dim1/4 - 1)
        for refk=1:(dim2/4 - 1)

            indices = patchmatcher(patchArr, frameno, refj, refk);

            patchMat = zeros(64, size(indices, 2), 'uint8');
            for i=1:size(indices,2)
                patchMat(:,i) = patchArr(:, indices(1,i), indices(2,i), indices(3,i));
            end

            [denoisedpatchMat] = pcai(cast(patchMat, 'double'), C);

            for selfind=1+5*(frameno-1):5*frameno
                if (indices(:, selfind) == [refj; refk; frameno;])
                    break;
                end
            end

            if replace
                patchArr(:, refj, refk, frameno) = denoisedpatchMat(:, selfind);
            end
            denoisedpatchArr(:, refj, refk, frameno) = denoisedpatchMat(:, selfind);
        end
    end

    final = zeros(size(denoised), 'double');
    weight = final;
    for i=1:nframes
        for j=1:(dim1/4 - 1)
            for k=1:(dim2/4 - 1)
                final((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) = final((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) + reshape(denoisedpatchArr(:,j,k,i), [8 8]);
                weight((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) = weight((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) + 1;
            end
        end
    end
    final = final ./ weight;
end
