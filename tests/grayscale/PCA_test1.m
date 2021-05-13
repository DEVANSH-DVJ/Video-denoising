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
s = 0.5;

dim1 = size(mov(1).cdata, 1);
dim2 = size(mov(1).cdata, 2);
nframes = min(size(mov, 2), 30);
frameno = 10;

frames = zeros([dim1 dim2 nframes], 'uint8');
for i=1:nframes
    frames(:,:,i) = rgb2gray(mov(i).cdata);
end

noisy = noisemodel(frames, sigma, k, s);

C = 8; % the number of dimensions we are retaining
variant = 2;
[final, denoised] = PCA(noisy, frameno, C, variant);

figure; imshow([frames(:,:,frameno) final(:,:,frameno) denoised(:,:,frameno) noisy(:,:,frameno)]);

% save('output1', 'frames', 'final', 'denoised', 'noisy', 'patchArr');

psnr = 10 * log10(dim1 * dim2 * 255^2 / norm(cast(frames(:,:,10), 'double') - final(:,:,10), 'fro')^2)