close all; clear; clc;

%========================================
% Restoration in Frequency Domain
%========================================

%% inverse filtering when no noise
h = fspecial('disk', 4);
f = im2double(imread('cameraman.tif'));
h_freq = fft2(h, size(f, 1), size(f, 2)); % pad h
f_blur = real(ifft2(h_freq .* fft2(f)));
disp(strcat('PSNR oringinal vs blurred: ', num2str(psnr(f, f_blur))));
f_blur_restored = ifft2(fft2(f_blur) ./ h_freq);
disp(strcat('PSNR oringinal vs blurred restored: ', num2str(psnr(f, f_blur_restored))));

figure(1);
imshow(f, []);
figure(2)
imshow(f_blur, []);
figure(3)
imshow(f_blur_restored, []);

%% inverse filter with noise
f_blur_noise = imnoise(f_blur, 'gaussian', 0, 0.002);
disp(strcat('PSNR oringinal vs blurred with noise: ', num2str(psnr(f, f_blur_noise))));
f_blur_noise_restored = ifft2(fft2(f_blur_noise) ./ h_freq);
disp(strcat('PSNR oringinal vs blurred with noise restored: ', num2str(psnr(f, f_blur_noise_restored))));

figure(4);
imshow(f_blur_noise);
figure(5);
imshow(f_blur_noise_restored);

%% restoration with weiner filter
nsr = 0.002 / var(f(:));
f_blur_noise_restored_weiner = deconvwnr(f_blur_noise, ifftshift(ifft2(h_freq)), nsr);
figure(6);
imshow(f_blur_noise_restored_weiner);
disp(strcat('PSNR oringinal vs blurred with noise restored with weiner: ', num2str(psnr(f, f_blur_noise_restored_weiner))));
