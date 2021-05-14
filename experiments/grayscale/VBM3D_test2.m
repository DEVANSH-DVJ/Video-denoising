clc;
clear;
close all;

rng(1);

addpath('../../algos/BM3D');

addpath('../../libs/yuv4mpeg2mov');
addpath('../../libs/noisemodel');

mov = yuv4mpeg2mov('../../data/carphone_qcif.y4m');

% Update these parameters
sigma = 50;
k = 05;
s = 10;

dim1 = size(mov(1).cdata, 1);
dim2 = size(mov(1).cdata, 2);
nframes = min(size(mov, 2), 30);
frameno = 10;

% Grayscaling the video
frames = zeros([dim1 dim2 nframes], 'uint8');
for i=1:nframes
    frames(:,:,i) = rgb2gray(mov(i).cdata);
end

% Adding noise
noisy = noisemodel(frames, sigma, k, s);

% VBM3D algorithm
tic;
[~, recon]  = VBM3D(noisy, sigma, 0, 0);
recon = cast(recon*255, 'uint8');
toc;

% Display result
figure; imshow([frames(:,:,frameno) recon(:,:,frameno) noisy(:,:,frameno)]);

% Calculate PSNR
psnr_noisy = 10 * log10(dim1 * dim2 * 255^2 / norm(cast(frames(:,:,frameno) - noisy(:,:,frameno), 'double'), 'fro')^2);
psnr_recon = 10 * log10(dim1 * dim2 * 255^2 / norm(cast(frames(:,:,frameno) - recon(:,:,frameno), 'double'), 'fro')^2);
fprintf('PSNR of Noisy Image: %f\n', psnr_noisy);
fprintf('PSNR of Reconstructed Image: %f\n', psnr_recon);

% Save the output
path = sprintf('results/%i_%i_%i/VMB3D_test2/',sigma,k,s);
save(append(path, 'output'), 'frames', 'noisy', 'recon', 'psnr_noisy', 'psnr_recon');
imwrite([frames(:,:,frameno) recon(:,:,frameno) noisy(:,:,frameno)], append(path, 'combined.png'));
imwrite(frames(:,:,frameno), append(path, 'original.png'));
imwrite(noisy(:,:,frameno), append(path, 'noisy.png'));
imwrite(recon(:,:,frameno), append(path, 'recon.png'));
