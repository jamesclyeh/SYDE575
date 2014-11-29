close all; clear; clc;

%========================================
% Chroma Subsampling
%========================================
%% Load
peppers = imread('peppers.png');
peppers_ycbcr = rgb2ycbcr(peppers);
y = peppers_ycbcr(:,:,1);
cb = peppers_ycbcr(:,:,2);
cr = peppers_ycbcr(:,:,3);

figure(1);
imshow(peppers);
title('Original Image');
figure(2);
imshow(y);
title('Luma');
figure(3);
imshow(cb);
title('Chroma - Cb');
figure(4);
imshow(cr);
title('Chroma - Cr');

%% Cb Cr subsample
cr2 = imresize(imresize(cr,0.5,'bilinear'),2,'bilinear');
cb2 = imresize(imresize(cb,0.5,'bilinear'),2,'bilinear');

peppers_cbcrsubsample = peppers_ycbcr;
peppers_cbcrsubsample(:,:,2) = cb2;
peppers_cbcrsubsample(:,:,3) = cr2;

figure(5);
imshow(ycbcr2rgb(peppers_cbcrsubsample));
title('Chrma subsampling');

%% Luma subsample
y2 = imresize(imresize(y,0.5,'bilinear'),2,'bilinear');

peppers_ysubsample = peppers_ycbcr;
peppers_ysubsample(:,:,1) = y2;

figure(6);
imshow(ycbcr2rgb(peppers_ysubsample));
title('Luma subsampling');

%========================================
% Color Segmentation
%========================================
%% Load
rgb2lab = makecform('srgb2lab');
peppers_lab = applycform(peppers, rgb2lab);

%% K = 2
K = 2;
row = [55 200];
col = [155 400];

idx = sub2ind([size(peppers_lab,1) size(peppers_lab,2)], row, col);

ab = double(peppers_lab(:,:,2:3)); % NOT im2double
m = size(ab,1);
n = size(ab,2);
ab = reshape(ab, m*n, 2);

for k = 1:K
  mu2(k,:) = ab(idx(k),:);
end

cluster_idx = kmeans(ab, K, 'Distance', 'sqEuclidean', 'Start', mu2);

% Label each pixel according to k-means
pixel_labels = reshape(cluster_idx, m, n);
figure(7);
imshow(pixel_labels, []);
title('Image labeled by cluster index k=2');
colormap(jet);

%% K = 4
K = 4;
row = [55 130 200 280];
col = [155 110 400 470];

idx = sub2ind([size(peppers_lab, 1) size(peppers_lab, 2)], row, col);

for k = 1:K
  mu4(k,:) = ab(idx(k),:);
end

cluster_idx = kmeans(ab, K, 'Distance', 'sqEuclidean', 'Start', mu4);

% Label each pixel according to k-means
pixel_labels = reshape(cluster_idx, m, n);
figure(8);
imshow(pixel_labels, []);
title('Image labeled by cluster index k=4');
colormap(jet);

pixel_labels_2d = reshape(pixel_labels, m, n);

for k = 1:K
  tmp_peppers = peppers;
  tmp_r = tmp_peppers(:,:,1);
  tmp_g = tmp_peppers(:,:,2);
  tmp_b = tmp_peppers(:,:,3);
  tmp_r(pixel_labels_2d ~= k) = 0;
  tmp_g(pixel_labels_2d ~= k) = 0;
  tmp_b(pixel_labels_2d ~= k) = 0;
  tmp_peppers(:,:,1) = tmp_r;
  tmp_peppers(:,:,2) = tmp_g;
  tmp_peppers(:,:,3) = tmp_b;
  figure(8 + k);
  imshow(tmp_peppers);
end