
function [indices]=patchmatcher(patchArr, refj, refk, frameno)
    % Input:
    %   patchArr : vectorized patches of the video, [64 dim1 dim2 nframes] (uint8)
    %   refj     : j value of reference patch
    %   refk     : k value of reference patch
    %   frameno  : frame number of reference patch
    % Output:
    %   indices : indices of matching patches, [3 nframes*5] (uint8)
    % Brief:
    %   Find 5 closest matches for the reference patch from each frame

    [~, dim1, dim2, nframes] = size(patchArr);

    patch = cast(patchArr, 'double');

    % Generating l1 norm distance matrix
    M_ = sum(abs(patch - patch(:, refj, refk, frameno)));
    M = reshape(M_, [dim1*dim2 nframes]);

    % Finding 5 min distance patches for each frames
    [~, I_] = mink(M, 5);

    % Getting the j, k values of matching patches
    [row, col] = ind2sub([dim1 dim2], I_);

    % Reshaping to form indices
    indices = [reshape(row, [1 5*nframes]); reshape(col, [1 5*nframes]); repelem(1:nframes, 5)];

    % Casting to uint8 as they are further used as index to get the patches
    indices = cast(indices, 'uint8');
end
