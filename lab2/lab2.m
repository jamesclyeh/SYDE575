close all; clear; clc;

%========================================
% Load images
%========================================

toy_img = [0.3*ones(200,100) 0.7*ones(200,100)];

%========================================
% Part 2: Noise Generation
%========================================

% The default is zero mean noise with 0.01 variance.
toy_img_gauss = imnoise(toy_img, 'gaussian');
figure(1);
imshow(toy_img_gauss);

% The default for noise density is 0.05.
toy_img_salt_pepper = imnoise(toy_img,'salt & pepper');
figure(2);
imshow(toy_img_salt_pepper);

% The default for variance is 0.04.
toy_img_speckle = imnoise(toy_img,'speckle');
figure(3);
imshow(toy_img_speckle);

