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

%========================================
% Adaptive Filtering
%========================================

%% Lee Filter
degraded = im2double(imread('degraded.tif'));
original = im2double(imread('cameraman.tif'));

imshow(degraded);
rect = getrect();

selected = degraded(rect(1):rect(1)+rect(3), rect(2):rect(2)+rect(4));
% selected(:,1:rect(1)) = 0;
% selected(1:rect(2),:) = 0;
% selected(:,rect(1)+rect(3):end) = 0;
% selected(rect(2)+rect(4):end,:) = 0;
noise_var = var(selected(:));

local_mean = colfilt(degraded, [10,10], 'sliding', @mean);
local_var = colfilt(degraded, [10,10], 'sliding', @var);

K = zeros(256, 256);

for i = 1:256
    for j = 1:256
        if noise_var > local_var(i,j)
            K(i,j) = 0;
        else
            K(i,j) = 1 - (noise_var/local_var(i,j));
        end
    end
end

denoise = K.*degraded + (1 - K).*local_mean;
figure;
imshow(denoise);
figure;
imshow(original);

psnr = psnr(original, denoise);
%% Gaussian Low Pass Filter
h_g = fspecial('gaussian', [3 3],30);
gaussian = imfilter(degraded, h_g, 'replicate');
figure;
imshow(gaussian);