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

PSNR(tire, tire_noisy)
PSNR(cameraman, cameraman_noisy)
PSNR(lena, lena_noisy)

DigitalZooming(lena, cameraman)