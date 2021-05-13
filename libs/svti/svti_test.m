clc;
clear;
close all;

rng(1);

load('patchMat');
load('patchOmega');

tau = 1.5;
kmax = 30;
tol = 1e-5;
sec_missing = true;
[Q, iter] = svti(cast(patchMat, 'double'), patchOmega, tau, kmax, tol, sec_missing);

imshow([patchMat Q]);
