
function [noisy]=noisemodel(frames,sigma,k,s)
    % Input:
    %   frames : original video, [dim1 dim2 nframes] (uint8)
    %   sigma  : std. deviation of gaussian noise
    %   k      : variance factor of the poission noise
    %   s      : percentage of impulsive noise
    % Output:
    %   noisy : noisy video, [dim1 dim2 nframes] (uint8)
    % Brief:
    %   Add gaussian, poisson, impulsive noise to the video

    [dim1 dim2 nframes] = size(frames);

    noisy = cast(frames, 'double');
    % Poisson Noise with zero mean, variance k*noisy
    np = (poissrnd(k*noisy) - k*noisy);
    % Gaussian Noise with zero mean, variance sigma^2
    ng = sigma*randn(dim1, dim2, nframes);
    noisy = noisy + np + ng;

    % Using uniform normal distribution for Impulsive noise
    X = rand(dim1, dim2, nframes);
    noisy(X < s/200) = 0;
    noisy(X > 1 - s/200) = 255;

    % Cast into uint8 to remove pixel intensity not in [0, 255]
    noisy = cast(noisy, 'uint8');
end
