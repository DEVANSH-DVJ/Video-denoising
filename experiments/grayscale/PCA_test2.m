clc;
clear;
close all;

rng(1);

addpath('../../algos/PCA');

addpath('../../libs/yuv4mpeg2mov');
addpath('../../libs/noisemodel');

mov = yuv4mpeg2mov('../../data/carphone_qcif.y4m');

sigma = 10;
k = 10;
s = 50;

dim1 = size(mov(1).cdata, 1);
dim2 = size(mov(1).cdata, 2);
nframes = min(size(mov, 2), 30);
frameno = 10;

frames = zeros([dim1 dim2 nframes], 'uint8');
for i=1:nframes
    frames(:,:,i) = rgb2gray(mov(i).cdata);
end

noisy = noisemodel(frames, sigma, k, s);

tic;
C = 20; % the number of dimensions we are retaining
variant = '0';
[recon, filtered] = PCA(noisy, frameno, C, variant);
toc;

figure; imshow([frames(:,:,frameno) recon(:,:,frameno) filtered(:,:,frameno) noisy(:,:,frameno)]);

psnr = 10 * log10(dim1 * dim2 * 255^2 / norm(cast(frames(:,:,frameno) - recon(:,:,frameno), 'double'), 'fro')^2);
fprintf('PSNR: %f\n', psnr);

path = sprintf('results/%i_%i_%i/PCA_test2/',sigma,k,s);
save(append(path, 'output'), 'frames', 'noisy', 'filtered', 'recon', 'psnr');
imwrite([frames(:,:,frameno) recon(:,:,frameno) filtered(:,:,frameno) noisy(:,:,frameno)], append(path, 'combined.png'));
imwrite(frames(:,:,frameno), append(path, 'original.png'));
imwrite(noisy(:,:,frameno), append(path, 'noisy.png'));
imwrite(filtered(:,:,frameno), append(path, 'filtered.png'));
imwrite(recon(:,:,frameno), append(path, 'recon.png'));
