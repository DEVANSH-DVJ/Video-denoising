clc;
clear;
close all;

rng(1);

addpath('../../libs/yuv4mpeg2mov');

mov = yuv4mpeg2mov('../../data/carphone_qcif.y4m');

frame1 = mov(1).cdata;

frames = zeros([size(frame1, 1) size(frame1, 2) size(mov,2)], 'uint8');
for i=1:size(mov, 2)
    frames(:,:,i) = rgb2gray(mov(i).cdata) + cast(randn(size(frame1, 1), size(frame1, 2))*20, 'uint8');
end

firstgroup = frames(:,:,1:50);

patchArr = zeros([8 8 35 43 50], 'uint8');

for i=1:50
    for j=1:35
        for k=1:43
            patchArr(:,:,j,k,i) = firstgroup((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)), i);
        end
    end
end

new = reshape(patchArr, [64 35 43 50]);

[indices] = patchmatcher(new, 11, 25, 10);

figure;
tiledlayout(3, 3)

for i=11:19
    nexttile;
    imshow(patchArr(:, :, indices(1,i), indices(2,i), indices(3,i)));
end
