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
% Part 2:  Digital Zooming
%========================================
DigitalZooming(lena, cameraman)

%========================================
% Part 3: Convolution
%========================================
h1 = (1 / 6) * ones(1, 6);
h2 = h1';
h3 = [-1 1];

subplot(2,2,1);
imshow(cameraman)
title('Original image');
subplot(2,2,2);
imshow(conv2(cameraman, h1), [])
title('Image with horizontal average filter');
subplot(2,2,3);
imshow(conv2(cameraman, h2), [])
title('Image with vertical average filter');
subplot(2,2,4);
imshow(conv2(cameraman, h3), [])
title('Image with edge detector');

%=================================================
% Part 4: Point Operations For Image Enhancement
%=================================================
ImageEnhancement(tire)
