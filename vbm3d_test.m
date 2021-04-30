clc;
clear;
close all;

addpath("yuv4mpeg2mov");
addpath("BM3D");

mov = yuv4mpeg2mov("data/akiyo_qcif.y4m");

frame1 = mov(1).cdata;
% imshow(frame1);

frames = zeros([size(frame1, 1) size(frame1, 2) size(mov,2)], 'uint8');
for i=1:size(mov, 2)
    frames(:,:,i) = rgb2gray(mov(i).cdata) + cast(randn(size(frame1, 1), size(frame1, 2))*20, 'uint8');
end

[~, x]  = VBM3D(frames, 20);

for i=1:5
    figure;
    imshow([x(:,:,i)*255 rgb2gray(mov(i).cdata) frames(:,:,i)]);
end
