
function [denoised]=adapmedfilt(noisy, Smax)
    % assume noisy image is of size ([dim1 dim2]) (uint8)
    % We have to apply median filter adaptively

    % Output would be denoised image of same dimension

    denoised = noisy;
    alreadyProcessed = false(size(noisy)); % generates a matrix of logical negation

    % Iteration.
    for k = 3:2:Smax
        zmin = ordfilt2(noisy, 1, ones(k, k), 'symmetric');
        zmax = ordfilt2(noisy, k * k, ones(k, k), 'symmetric');
        zmed = medfilt2(noisy, [k k], 'symmetric');

        processUsingLevelB = (zmed > zmin) & (zmax > zmed) & ~alreadyProcessed; % pixels that need to go to step B
        zB = (noisy > zmin) & (zmax > noisy);
        outputZxy = processUsingLevelB & zB;% The position of the pixel corresponding to the original output value of step AB
        outputZmed = processUsingLevelB & ~zB;% The pixel position corresponding to the median value of the output that satisfies A but does not satisfy B
        denoised(outputZxy) = noisy(outputZxy);
        denoised(outputZmed) = zmed(outputZmed);

        alreadyProcessed = alreadyProcessed | processUsingLevelB;
        if all(alreadyProcessed(:))
            break;
        end
    end

    denoised(~alreadyProcessed) = zmed(~alreadyProcessed);
end
