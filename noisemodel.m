
function [noisy]=noisemodel(frames,sigma,k,s)
    % assume frames is of size ([dim1 dim2 nframes]) (uint8)
    % We have to add gaussian, possion, impulsive noise

    % Output would be noise added frames of same dimension

    dim1=size(frames, 1);
    dim2=size(frames, 2);
    nframes=size(frames, 3);

    noisy = cast(frames, 'double');
    np = (poissrnd(k*noisy) - k*noisy);
    ng = sigma*randn(dim1, dim2, nframes);
    noisy = noisy + np + ng;

    X = rand(dim1, dim2, nframes);
    noisy(X < s/2) = 0;
    noisy(X > 1 - s/2) = 255;

    noisy = cast(noisy, 'uint8');
    noisy(noisy < 0) = 0;
    noisy(noisy > 255)= 255;
end
