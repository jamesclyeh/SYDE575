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