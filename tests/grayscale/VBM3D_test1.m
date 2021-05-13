clc;
clear;
close all;

rng(1);

addpath('../../algos/BM3D');

addpath('../../libs/yuv4mpeg2mov');
addpath('../../libs/noisemodel');
addpath('../../libs/adapmedfilt');

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

denoised = zeros([dim1 dim2 nframes], 'uint8');
for i=1:nframes
    denoised(:,:,i) = adapmedfilt(noisy(:,:,i), 11);
end

tic;
[~, final]  = VBM3D(denoised, sigma);
toc;

figure; imshow([frames(:,:,frameno) final(:,:,frameno)*255 denoised(:,:,frameno) noisy(:,:,frameno)]);

psnr = 10 * log10(dim1 * dim2 * 255^2 / norm(cast(frames(:,:,frameno), 'double') - final(:,:,frameno)*255, 'fro')^2)
