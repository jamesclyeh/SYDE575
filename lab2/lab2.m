close all; clear; clc;

%========================================
% Load images
%========================================
%% Load
toy_img = [0.3*ones(200,100) 0.7*ones(200,100)];
figure(1);
subplot(1,2,1);
imshow(toy_img);
subplot(1,2,2);
imhist(toy_img);

%========================================
% Part 2: Noise Generation
%========================================

%% The default is zero mean noise with 0.01 variance.
toy_img_gauss = imnoise(toy_img, 'gaussian');
figure(2);
subplot(1,2,1);
imshow(toy_img_gauss);
subplot(1,2,2);
imhist(toy_img_gauss);

%% The default for noise density is 0.05.
toy_img_salt_pepper = imnoise(toy_img,'salt & pepper');
figure(3);
subplot(1,2,1);
imshow(toy_img_salt_pepper);
subplot(1,2,2);
imhist(toy_img_salt_pepper);

%% The default for variance is 0.04.
toy_img_speckle = imnoise(toy_img,'speckle');
figure(4);
subplot(1,2,1);
imshow(toy_img_speckle);
subplot(1,2,2);
imhist(toy_img_speckle);

%==============================================
% Part 3: Noise Reduction in the Spatial Domain
%==============================================
%% Load
lena = im2double(rgb2gray(imread('../lena.tiff')));
lena_gauss = imnoise(lena, 'gaussian', 0, 0.002);
figure(5);
subplot(1,2,1);
imshow(lena);
subplot(1,2,2);
imhist(lena);
figure(6);
subplot(1,2,1);
imshow(lena_gauss);
subplot(1,2,2);
imhist(lena_gauss);
disp(strcat('PSNR oringinal vs 0.002 gauss: ', num2str(psnr(lena, lena_gauss))));

%% The 3x3 smoothing window.
average_filter_33 = fspecial('average', [3 3]);
figure(7);
colormap(gray);
imagesc(average_filter_33);
smooth_lena_gauss_33 = imfilter(lena_gauss, average_filter_33);
figure(8);
subplot(1,2,1);
imshow(smooth_lena_gauss_33);
subplot(1,2,2);
imhist(smooth_lena_gauss_33);
disp(strcat('PSNR oringinal vs 3x3 smoothed 0.002 gauss: ', num2str(psnr(lena, smooth_lena_gauss_33))));

%% The 7x7 smoothing window.
average_filter_77 = fspecial('average', [7 7]);
smooth_lena_gauss_77 = imfilter(lena_gauss, average_filter_77);
figure(9);
subplot(1,2,1);
imshow(smooth_lena_gauss_77);
subplot(1,2,2);
imhist(smooth_lena_gauss_77);
disp(strcat('PSNR oringinal vs 7x7 smoothed 0.002 gauss: ', num2str(psnr(lena, smooth_lena_gauss_77))));

%% The 7x7 gaussian filter window.
gaussian_filter_77 = fspecial('gaussian', [7 7], 1);
figure(10);
colormap(gray);
imagesc(gaussian_filter_77);
guass_lena_gauss_77 = imfilter(lena_gauss, gaussian_filter_77);
figure(11);
subplot(1,2,1);
imshow(guass_lena_gauss_77);
subplot(1,2,2);
imhist(guass_lena_gauss_77);
disp(strcat('PSNR oringinal vs 7x7 gaussian filter 0.002 gauss: ', num2str(psnr(lena, guass_lena_gauss_77))));

%% The 7x7 gaussian and averaging filter windows with salt and pepper.
lena_salt_pepper = imnoise(lena,'salt & pepper');
figure(12);
subplot(1,2,1);
imshow(lena_salt_pepper);
subplot(1,2,2);
imhist(lena_salt_pepper);

guass_lena_salt_pepper_77 = imfilter(lena_salt_pepper, gaussian_filter_77);
figure(13);
subplot(1,2,1);
imshow(guass_lena_salt_pepper_77);
subplot(1,2,2);
imhist(guass_lena_salt_pepper_77);
disp(strcat('PSNR oringinal vs 7x7 gaussian filter salt&pepper: ', num2str(psnr(lena, guass_lena_salt_pepper_77))));

smooth_lena_salt_pepper_77 = imfilter(lena_salt_pepper, average_filter_77);
figure(14);
subplot(1,2,1);
imshow(smooth_lena_salt_pepper_77);
subplot(1,2,2);
imhist(smooth_lena_salt_pepper_77);
disp(strcat('PSNR oringinal vs 7x7 smoothed salt&pepper: ', num2str(psnr(lena, smooth_lena_salt_pepper_77))));

%% Median filter
median_lena_salt_pepper = medfilt2(lena_salt_pepper);
figure(15);
subplot(1,2,1);
imshow(median_lena_salt_pepper);
subplot(1,2,2);
imhist(median_lena_salt_pepper);
disp(strcat('PSNR oringinal vs median filter salt&pepper: ', num2str(psnr(lena, median_lena_salt_pepper))));