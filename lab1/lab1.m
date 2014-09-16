close all; clear; clc;

%========================================
% Load images
%========================================

tire = imread('tire.tif');
tire_noisy = imnoise(tire, 'gaussian');
cameraman = imread('cameraman.tif');
cameraman_noisy = imnoise(cameraman, 'gaussian');
lena = imread('../lena.tiff');
lena_noisy = imnoise(lena, 'gaussian');

%========================================
% Part 1: PSNR calculation
%========================================
PSNR(tire, tire_noisy)
PSNR(cameraman, cameraman_noisy)
PSNR(lena, lena_noisy)

%========================================
% Part 2: Convolution
%========================================
h1 = (1 / 6) * ones(1, 6);
h2 = h1';
h3 = [-1 1];

subplot(2,2,1);
imshow(cameraman)
subplot(2,2,2);
imshow(conv2(cameraman, h1), [])
subplot(2,2,3);
imshow(conv2(cameraman, h2), [])
subplot(2,2,4);
imshow(conv2(cameraman, h3), [])


