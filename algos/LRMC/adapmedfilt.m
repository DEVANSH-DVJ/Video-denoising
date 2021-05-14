
function [denoised]=adapmedfilt(noisy, Smax)
    % Input:
    %   noisy : noisy image, [dim1 dim2] (uint8)
    %   Smax  : maximum window size
    % Output:
    %   denoised : denoised image, [dim1 dim2] (uint8)
    % Brief:
    %   Apply median filter adaptively

    denoised = noisy;
    alreadyProcessed = false(size(noisy));

    % Iteration on k
    for k = 3:2:Smax
        % Getting zmin, zmax, zmed of every pixel with window size k
        zmin = ordfilt2(noisy, 1, ones(k, k), 'symmetric');
        zmax = ordfilt2(noisy, k * k, ones(k, k), 'symmetric');
        zmed = medfilt2(noisy, [k k], 'symmetric');

        % pixels that need to go to step B
        processUsingLevelB = (zmed > zmin) & (zmax > zmed) & ~alreadyProcessed;
        zB = (noisy > zmin) & (zmax > noisy);

        % position of the pixel corresponding to the original output value of step AB
        outputZxy = processUsingLevelB & zB;
        % pixel position corresponding to the median value of the output that satisfies A but does not satisfy B
        outputZmed = processUsingLevelB & ~zB;

        % Updating pixels
        denoised(outputZxy) = noisy(outputZxy);
        denoised(outputZmed) = zmed(outputZmed);

        % Updating processed subset
        alreadyProcessed = alreadyProcessed | processUsingLevelB;

        if all(alreadyProcessed(:))
            break;
        end
    end

    % pixels which aren't processed are given values from zmed
    denoised(~alreadyProcessed) = zmed(~alreadyProcessed);
end
