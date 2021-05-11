clc;
clear;
close all;

rng(1);

addpath("yuv4mpeg2mov");
addpath("BM3D");

mov = yuv4mpeg2mov("data/akiyo_qcif.y4m");

f = rgb2gray(mov(1).cdata);
 f1=imnoise(f,'salt & pepper',0.3);% image with salt and pepper noise added
image_gray=f1;% get grayscale image
ff =image_gray;
 alreadyProcessed = false(size(image_gray));% generates a matrix of logical negation
 % Iteration.
Smax=7;
for k = 3:2:Smax
   zmin = ordfilt2(image_gray, 1, ones(k, k), 'symmetric');
   zmax = ordfilt2(image_gray, k * k, ones(k, k), 'symmetric');
   zmed = medfilt2(image_gray, [k k], 'symmetric');
   
   processUsingLevelB = (zmed > zmin) & (zmax > zmed) & ...
               ~alreadyProcessed;% pixels that need to go to step B
   zB = (image_gray > zmin) & (zmax > image_gray);
       outputZxy = processUsingLevelB & zB;% The position of the pixel corresponding to the original output value of step AB
       outputZmed = processUsingLevelB & ~zB;% The pixel position corresponding to the median value of the output that satisfies A but does not satisfy B
   ff(outputZxy) = image_gray(outputZxy);
   ff(outputZmed) = zmed(outputZmed);
   
   alreadyProcessed = alreadyProcessed | processUsingLevelB;
   if all(alreadyProcessed(:))
      break;
   end
end

ff(~alreadyProcessed) = zmed(~alreadyProcessed);
 f2=medfilt2(f1,[3,3]);% median filtered image
subplot(2,2,1);
imshow(f);
 title('Original image');
subplot(2,2,2);
imshow(f1);
 title('Image after salt and pepper noise pollution');
subplot(2,2,3);
imshow(f2);
 title('Median filtering');
subplot(2,2,4);
imshow(ff);
 title('Adaptive median filter');