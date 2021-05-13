clc;
clear;
close all;

rng(1);

addpath('../../libs/yuv4mpeg2mov');

mov = yuv4mpeg2mov('../../data/carphone_qcif.y4m');

sigma = 20;
k = 5;
s = 30;

dim1 = size(mov(1).cdata, 1);
dim2 = size(mov(1).cdata, 2);
nframes = size(mov, 2);

frames = zeros([dim1 dim2 nframes], 'uint8');
for i=1:nframes
    frames(:,:,i) = rgb2gray(mov(i).cdata);
end

noisy = noisemodel(frames, sigma, k, s);

imshow([frames(:,:,5) noisy(:,:,5)]);
