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
nframes = min(size(mov, 2), 50);

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

missing = (denoised ~= noisy);
consistency = sum(missing, 'all') / numel(missing);

figure; imshow([frames(:,:,1) denoised(:,:,1) noisy(:,:,1) missing(:,:,1)*255]);

toc;
tic;

patchArr = zeros([64 (dim1/4 - 1) (dim2/4 - 1) nframes], 'uint8');
missingArr = false([64 (dim1/4 - 1) (dim2/4 - 1) nframes]);

for i=1:nframes
    for j=1:(dim1/4 - 1)
        for k=1:(dim2/4 - 1)
            patchArr(:,j,k,i) = reshape(denoised((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i), [64 1]);
            missingArr(:,j,k,i) = reshape(missing((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i), [64 1]);
        end
    end
end

indices = patchmatcher(patchArr, 10, 11, 25);

patchMat = zeros(64, size(indices, 2), 'uint8');
patchOmega = false(64, size(indices, 2));
for i=1:size(indices,2)
    patchMat(:,i) = patchArr(:, indices(1,i), indices(2,i), indices(3,i));
    patchOmega(:, i) = ~missingArr(:, indices(1,i), indices(2,i), indices(3,i));
end

figure; imshow(patchMat);
S = svd(cast(patchMat, 'double'));
figure; plot(S);

toc;

save('patchMat', 'patchMat');
save('patchOmega', 'patchOmega');
