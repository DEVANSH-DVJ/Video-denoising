clc;
clear;
close all;

rng(1);

addpath("yuv4mpeg2mov");
addpath("BM3D");

mov = yuv4mpeg2mov("data/akiyo_qcif.y4m");

sigma = 20;
k = 0.5;
s = 0.3;

dim1 = size(mov(1).cdata, 1);
dim2 = size(mov(1).cdata, 2);
nframes = size(mov, 2);

frames = zeros([dim1 dim2 nframes], 'double');
for i=1:nframes
    frames(:,:,i) = rgb2gray(mov(i).cdata);
end

frames = frames + poissrnd(k*frames);
frames = frames + sigma*randn(dim1, dim2, nframes);

X = rand(dim1, dim2, nframes);
frames(X < s/2) = 0;
frames(X > 1 - s/2) = 255;

frames(frames < 0) = 0; frames(frames > 255)= 255; 

imshow(cast([frames(:,:,5) rgb2gray(mov(5).cdata)], 'uint8'));

