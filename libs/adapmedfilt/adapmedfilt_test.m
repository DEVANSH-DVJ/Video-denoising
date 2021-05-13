clc;
clear;
close all;

rng(1);

addpath('../../libs/yuv4mpeg2mov');

mov = yuv4mpeg2mov('../../data/carphone_qcif.y4m');

frame = rgb2gray(mov(1).cdata);
noisy = imnoise(frame,'salt & pepper',0.7); % image with salt and pepper noise added
Smax = 11;

denoised = adapmedfilt(noisy, Smax);

imshow([frame denoised noisy]);

consistency = sum((frame - denoised == 0), 'all') / numel(frame);
