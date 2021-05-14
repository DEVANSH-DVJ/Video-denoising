clc;
clear;
close all;

rng(1);

addpath('../../algos/LRMC');

addpath('../../libs/yuv4mpeg2mov');
addpath('../../libs/noisemodel');

mov = yuv4mpeg2mov('../../data/carphone_qcif.y4m');

% Don't update these parameters
sigma = 10;
k = 10;
s = 50;

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

% LRMC algorithm
tic;
% Update these parameters
tau = 1.5;
kmax = 30;
tol = 1e-5;
variant = '01';
[recon, filtered] = LRMC(noisy, frameno, tau, kmax, tol, variant);
toc;

% Display result
figure; imshow([frames(:,:,frameno) recon(:,:,frameno) filtered(:,:,frameno) noisy(:,:,frameno)]);

% Calculate PSNR
psnr_noisy = 10 * log10(dim1 * dim2 * 255^2 / norm(cast(frames(:,:,frameno) - noisy(:,:,frameno), 'double'), 'fro')^2);
psnr_filtered = 10 * log10(dim1 * dim2 * 255^2 / norm(cast(frames(:,:,frameno) - filtered(:,:,frameno), 'double'), 'fro')^2);
psnr_recon = 10 * log10(dim1 * dim2 * 255^2 / norm(cast(frames(:,:,frameno) - recon(:,:,frameno), 'double'), 'fro')^2);
fprintf('PSNR of Noisy Image: %f\n', psnr_noisy);
fprintf('PSNR of Filtered Image: %f\n', psnr_filtered);
fprintf('PSNR of Reconstructed Image: %f\n', psnr_recon);

% Save the output
path = sprintf('results/LRMC_var/%i_%i_%i/%.1f_%i_%i_%s/',sigma,k,s,tau,kmax,-log10(tol),variant);
save(append(path, 'output'), 'frames', 'noisy', 'filtered', 'recon', 'psnr_noisy', 'psnr_filtered', 'psnr_recon');
imwrite([frames(:,:,frameno) recon(:,:,frameno) filtered(:,:,frameno) noisy(:,:,frameno)], append(path, 'combined.png'));
imwrite(frames(:,:,frameno), append(path, 'original.png'));
imwrite(noisy(:,:,frameno), append(path, 'noisy.png'));
imwrite(filtered(:,:,frameno), append(path, 'filtered.png'));
imwrite(recon(:,:,frameno), append(path, 'recon.png'));
