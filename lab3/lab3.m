close all; clear; clc;

%========================================
% Fourier Analysis
%========================================
%% Fourier Analysis
% Setup toy image
% Black background with white strip in middle
toy = zeros(256, 256);
toy(:, 108:148) = 1; 
figure(1);
imshow(toy);

% Plot a 2d fft
F = fft2(toy);
F = fftshift(F);
F = abs(F);
F= log(F+1); % because F maybe 0
F = mat2gray(F);

figure(2);
imshow(F, []);

% rotate image 45 degrees and get fourier spectra
G = imrotate(toy, 45);
figure(3);
imshow(G);

I = fft2(G);
I = fftshift(I);
I = log(abs(I) + 1);
I = mat2gray(I);

figure(4);
imshow(I, []);
%% Study Contributions of Fourier Magnitude and Phase
lena = imread('../lena.tiff');
lena = rgb2gray(lena);
lenaF = fft2(lena);
figure(7);
imshow(lena);
figure(8);
imshow(ifft2(lenaF), []);
mag = abs(lenaF);
phase = angle(lenaF);

figure(5);
imshow(uint8(ifft2(mag)), []);
figure (6);
imshow(ifft2(exp(1*j*phase)), []);

%================================================
% Part 3: Noise Reduction in the Frequency Domain
%================================================
%% Load
lena = im2double(rgb2gray(imread('../lena.tiff')));
lena_gauss = imnoise(lena, 'gaussian', 0, 0.005);
disp(strcat('PSNR oringinal vs gaussian noise: ', num2str(psnr(lena, lena_gauss))));

%% Log fourier spectra
fft_lena = fftshift(fft2(lena));
log_fft_lena = log(abs(fft_lena));
fft_lena_gauss = fftshift(fft2(lena_gauss));
log_fft_lena_gauss = log(abs(fft_lena_gauss));

figure(31);
imshow(log_fft_lena, []);
figure(32);
imshow(log_fft_lena_gauss, []);

%% Ideal low pass filter r = 60
[height, width] = size(lena);
r = 60;
h = fspecial('disk', r); 
h(h > 0) = 1;
h_freq = zeros(height, width);
h_freq([height / 2 - r: width / 2 + r], [width / 2 - r: width / 2 + r]) = h;

low_pass_fft_lena_gauss_60 = real(ifft2(ifftshift(fft_lena_gauss .* h_freq)));
figure(33);
imshow(low_pass_fft_lena_gauss_60, []);
disp(strcat('PSNR oringinal vs LPF denoised radius 60: ', num2str(psnr(lena, low_pass_fft_lena_gauss_60))));

%% Ideal low pass filter r = 20
r = 20;
h = fspecial('disk', r); 
h(h > 0) = 1;
h_freq = zeros(height, width);
h_freq([height / 2 - r: width / 2 + r], [width / 2 - r: width / 2 + r]) = h;

low_pass_fft_lena_gauss_20 = real(ifft2(ifftshift(fft_lena_gauss .* h_freq)));
figure(33);
imshow(low_pass_fft_lena_gauss_20, []);
disp(strcat('PSNR oringinal vs LPF denoised radius 20: ', num2str(psnr(lena, low_pass_fft_lena_gauss_20))));

%% Gaussian filter std dev = 60
h = fspecial('gaussian', [height width], 60);
h_norm = (h - min(min(h))) ./ (max(max(h)) - min(min(h)));
gauss_fft_lena_gauss = real(ifft2(ifftshift(fft_lena_gauss .* h_norm)));

figure(34);
imshow(gauss_fft_lena_gauss, []);
disp(strcat('PSNR oringinal vs gaussian denoised: ', num2str(psnr(lena, gauss_fft_lena_gauss))));
