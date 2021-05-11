clc;
clear;
close all;

rng(1);

addpath("yuv4mpeg2mov");
addpath("BM3D");

mov = yuv4mpeg2mov("data/akiyo_qcif.y4m");

frame = rgb2gray(mov(1).cdata);
noisy = imnoise(frame,'salt & pepper',0.7); % image with salt and pepper noise added
Smax = 11;

denoised = adapmedfilt(noisy, Smax);

imshow([frame denoised noisy]);

consistency = sum((frame - denoised == 0), 'all') / numel(frame);
