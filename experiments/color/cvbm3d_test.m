clc;
clear;
close all;

addpath('../../algos/BM3D');

addpath('../../libs/yuv4mpeg2mov');

mov = yuv4mpeg2mov('../../data/akiyo_qcif.y4m');

frame1 = mov(1).cdata;
% imshow(frame1);

frames = zeros([size(frame1) size(mov,2)], 'uint8');
for i=1:size(mov, 2)
    frames(:,:,:,i) = mov(i).cdata + cast(randn(size(frame1))*20, 'uint8');
end

x  = CVBM3D(frames, 20);

for i=1:5
    figure;
    imshow([x(:,:,:,i) mov(i).cdata frames(:,:,:,i)]);
end

delete ExternalMatrix*;
