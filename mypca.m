% 
% clc;
% clear;
% close all;
% 
% rng(1);
% addpath("yuv4mpeg2mov");
% 
% mov = yuv4mpeg2mov("data/akiyo_qcif.y4m");
% frame1 = mov(1).cdata;
% frames = zeros([size(frame1, 1) size(frame1, 2) size(mov,2)], 'uint8');
% for i=1:size(mov, 2)
%     frames(:,:,i) = rgb2gray(mov(i).cdata) + cast(randn(size(frame1, 1), size(frame1, 2))*20, 'uint8');
% end
% firstgroup = frames(:,:,1:50);
% patchArr = zeros([8 8 35 43 50], 'uint8');
% for i=1:50
%     for j=1:35
%         for k=1:43
%             patchArr(:,:,j,k,i) = firstgroup((1+4*(j-1)):(4*(j+1)), (1+4*(k-1)):(4*(k+1)), i);
%         end
%     end
% end
% new = reshape(patchArr, [64 35 43 50]);
% tic
% indices = patchmatcher(new, 10, 11, 25);
% toc
% matched = zeros([64, size(indices,2)]);
% for i=1:size(indices,2)
%     matched(:,i)=new(:,indices(1,i), indices(2,i), indices(3,i));
% end
% meanpatch=mean(matched,2);
% centered=matched-meanpatch;
% arr=sqrt(sum(centered.^2,2)/size(centered,2)); %standard deviation
% onebyarr=1./arr;
% normalised=centered.*(onebyarr);
% [coeff,score,~]=pca(normalised');
% 
% C=32;
% reduced=score(:,1:C)*((coeff(:,1:C))');
% 
% newcentered=(reduced').*arr;
% completenew=newcentered+meanpatch;
% 
% norm(matched-completenew, 'fro')/norm(matched, 'fro')
% 

function [pcaed]=mypca(P, C)
    % assume noisy patch matrix is of size ([64 n2]) (double)
    % n2 must be greater than 64
    % We have to apply Principal Components Analysis
    % taking C of the dimensions
    
    % Output would be denoised patch matrix of same dimension
    
    %centering the data
    meanpatch=mean(P,2);
    centered=P-meanpatch;
    
    %normalising
    arr=sqrt(sum(centered.^2,2)/size(centered,2)); %standard deviation
    onebyarr=1./arr;
    normalised=centered.*(onebyarr);
    
    %principal component analysis
    [coeff,score,~]=pca(normalised');
    
    %data with reduced dimensions
    reduced=score(:,1:C)*((coeff(:,1:C))');
    
    %De-normalising
    newcentered=(reduced').*arr;
    
    %De-centering
    pcaed=newcentered+meanpatch;
end
