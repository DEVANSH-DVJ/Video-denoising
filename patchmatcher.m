
function [indices]=patchmatcher(patchArr,i,j,k)
    % assume patchArr is of size ([64 dim1 dim2 nframes])
    % We have to find closest 5
    % patches to patchArr(:,j,k,i)
    % per frame patchArr(:,-,-,n)

    % Output would be a matrix of pairs (l,m,n)
    % n ranges from 1 to nframes, per n we have 5 pairs
    % output matrix is 3*(nframes*5)

    dim1 = size(patchArr, 2);
    dim2 = size(patchArr, 3);
    nframes = size(patchArr, 4);

    indices = zeros([3 nframes*5], 'uint8');

    for n=1:nframes % for each frame
        M = zeros([1 dim1*dim2]); % matrix to store the l1 norm of error
        for l=1:dim1
            for m=1:dim2
                % calculate the error and store its l1 norm
                diffimage = double(patchArr(:,j,k,i)) - double(patchArr(:,l,m,n));
                M(1,l+dim1*(m-1)) = sum(abs(diffimage));
            end
        end

        % find 5 indices with minimum error
        [~,I] = mink(M,5);

        % find the corresponding patch indices
        [z,t] = inverse(I, dim1);

        % save the info in output matrix
        for a=1:5
            indices(:,a+(n-1)*5) = [z(a) t(a) n];
        end
    end
end

function [l,m]=inverse(rvalue, dim1)
    % If (rvalue-1)=(l-1)+dim1*(m-1)
    % I want to return l and m
    % This is how we stored values in M matrix in above function

    x = floor((rvalue-1)/dim1);
    l = rvalue-x*dim1;
    m = x+1;
end
