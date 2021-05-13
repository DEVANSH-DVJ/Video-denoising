
function [indices]=patchmatcher(patchArr, refj, refk, frameno)
    % assume patchArr is of size ([64 dim1 dim2 nframes])
    % We have to find closest 5
    % patches to patchArr(:, refj, refk, frameno)
    % per frame patchArr(:, :, :, n)

    % Output would be a matrix of pairs (l, m, n)
    % n ranges from 1 to nframes, per n we have 5 pairs
    % output matrix is of dimension [3 (nframes*5)]

    dim1 = size(patchArr, 2);
    dim2 = size(patchArr, 3);
    nframes = size(patchArr, 4);

    patch = cast(patchArr, 'double');

    M_ = sum(abs(patch - patch(:, refj, refk, frameno)));
    M = reshape(M_, [dim1*dim2 nframes]);

    [~, I_] = mink(M, 5);

    [row, col] = ind2sub([dim1 dim2], I_);

    indices = [reshape(row, [1 5*nframes]); reshape(col, [1 5*nframes]); repelem(1:nframes, 5)];

    indices = cast(indices, 'uint8');
end
