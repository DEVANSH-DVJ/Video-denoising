clc;
clear;
close all;

rng(1);

load('patchMat');

C = 8;
pcaed = pcai(cast(patchMat, 'double'), C);

imshow([patchMat pcaed]);
