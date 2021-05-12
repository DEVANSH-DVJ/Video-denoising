clc;
clear;
close all;

addpath('yuv4mpeg2mov');
addpath('BM3D');

mov = yuv4mpeg2mov('data/carphone_qcif.y4m');

sigma = 10;
k = 10;
s = 0.3;

dim1 = size(mov(1).cdata, 1);
dim2 = size(mov(1).cdata, 2);
nframes = min(size(mov, 2), 30);

frames = zeros([dim1 dim2 nframes], 'uint8');
for i=1:nframes
    frames(:,:,i) = rgb2gray(mov(i).cdata);
end

noisy = noisemodel(frames, sigma, k, s);

denoised = zeros([dim1 dim2 nframes], 'uint8');
for i=1:nframes
    denoised(:,:,i) = adapmedfilt(noisy(:,:,i), 11);
end

[~, final1]  = VBM3D(denoised, sigma);

figure; imshow([frames(:,:,10) final1(:,:,10)*255 denoised(:,:,10) noisy(:,:,10)]);

10 * log10(144*176*255^2 / norm(cast(frames(:,:,10), 'double') - final1(:,:,10)*255, 'fro')^2)

load('output1');

figure; imshow([frames(:,:,10) final(:,:,10) final1(:,:,10)*255]);
