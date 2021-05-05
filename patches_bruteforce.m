clc;
clear;
close all;

rng(1);

addpath("yuv4mpeg2mov");
addpath("BM3D");

mov = yuv4mpeg2mov("data/akiyo_qcif.y4m");

frame1 = mov(1).cdata;

frames = zeros([size(frame1, 1) size(frame1, 2) size(mov,2)], 'uint8');
for i=1:size(mov, 2)
    frames(:,:,i) = rgb2gray(mov(i).cdata) + cast(randn(size(frame1, 1), size(frame1, 2))*20, 'uint8');
end

firstgroup=frames(:,:,1:50);

patchArr=zeros([8 8 35 43 50], 'uint8');
%A=false([35 43 50],'logical');

for i=1:50
    for j=1:35
        for k=1:43
            patchArr(:,:,j,k,i)=firstgroup((1+4*(j-1)):(4*(j+1)),(1+4*(k-1)):(4*(k+1)),i);
        end
    end
end

for i=1:1
    for j=1:1
        for k=1:1
            for i_=1:20
            M=zeros([1 35*43]);
            for l=1:35
                for m=1:43
                    diffimage=double(patchArr(:,:,j,k,i))-double(patchArr(:,:,l,m,i_));
                    M(1,l+35*(m-1))=sum(sum(abs(diffimage)));
                end
            end
            [Q,I]=mink(M,5);
            [z,t]=inverse(I);
            figure;
            for a=1:5
                subplot(2,5,a);
                imshow(patchArr(:,:,z(a),t(a),i_));
                subplot(2,5,a+5);
                imshow(patchArr(:,:,j,k,i));
            end
            end
        end
    end
end

function [l,m]=inverse(rvalue)
    % If (rvalue-1)=(l-1)+35*(m-1) 
    % I want to return l and m 
    x=floor((rvalue-1)/35);
    l=rvalue-x*35;
    m=x+1;
end




