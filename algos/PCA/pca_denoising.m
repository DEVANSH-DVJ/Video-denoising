clc;
clear;
close all;

rng(1);

addpath('../../libs/yuv4mpeg2mov');
addpath('../../libs/noisemodel');
addpath('../../libs/adapmedfilt');
addpath('../../libs/patchmatcher');
addpath('../../libs/pcai');

tic;
mov = yuv4mpeg2mov('../../data/carphone_qcif.y4m');

sigma = 10;
k = 10;
s = 0.5;
C=20; % the number of dimensions we are retaining

dim1 = size(mov(1).cdata, 1);
dim2 = size(mov(1).cdata, 2);
nframes = min(size(mov, 2), 50);
frameno = 10;

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

toc;
tic;

for refj=1:(dim1/4 - 1)
    for refk=1:(dim2/4 - 1)
%         refj = 11;
%         refk = 25;

        indices = patchmatcher(patchArr, frameno, refj, refk);

        patchMat = zeros(64, size(indices, 2), 'uint8');
        patchOmega = false(64, size(indices, 2));
        for i=1:size(indices,2)
            patchMat(:,i) = patchArr(:, indices(1,i), indices(2,i), indices(3,i));
            patchOmega(:, i) = ~missingArr(:, indices(1,i), indices(2,i), indices(3,i));
        end

        [denoisedpatchMat] = pcai(cast(patchMat, 'double'), C);

        for selfind=1+5*(frameno-1):5*frameno
            if (indices(:, selfind) == [refj; refk; frameno;])
                break;
            end
        end

        patchArr(:, refj, refk, frameno) = denoisedpatchMat(:, selfind);
    end
end

toc;

final = zeros(size(denoised), 'double');
weight = final;
for i=1:nframes
    for j=1:(dim1/4 - 1)
        for k=1:(dim2/4 - 1)
            final((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) = final((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) + cast(reshape(patchArr(:,j,k,i), [8 8]), 'double');
            weight((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) = weight((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)),i) + 1;
        end
    end
end
final = final ./ weight;

figure; imshow([frames(:,:,frameno) final(:,:,frameno) denoised(:,:,frameno) noisy(:,:,frameno)]);

% save('output1', 'frames', 'final', 'denoised', 'noisy', 'patchArr');

psnr = 10 * log10(dim1 * dim2 * 255^2 / norm(cast(frames(:,:,10), 'double') - final(:,:,10), 'fro')^2)
