clc;
clear;
close all;

rng(1);

addpath("yuv4mpeg2mov");
addpath("BM3D");

tic;
mov = yuv4mpeg2mov("data/akiyo_qcif.y4m");

sigma = 10;
k = 5;
s = 0.3;

dim1 = size(mov(1).cdata, 1);
dim2 = size(mov(1).cdata, 2);
nframes = size(mov, 2);

frames = zeros([dim1 dim2 nframes], 'uint8');
for i=1:nframes
    frames(:,:,i) = rgb2gray(mov(i).cdata);
end

toc;
tic;

noisy = noisemodel(frames, sigma, k, s);

toc;
tic;

denoised = zeros([dim1 dim2 nframes], 'uint8');
for i=1:nframes
    denoised(:,:,i) = adapmedfilt(noisy(:,:,i), 11);
end

missing1 = (denoised ~= noisy);
consistency = sum(missing1, 'all') / numel(missing1);

imshow([frames(:,:,1) denoised(:,:,1) noisy(:,:,1) missing1(:,:,1)*255]);

toc;
