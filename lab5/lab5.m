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
figure(2);
imshow(y);
figure(3);
imshow(cb);
figure(4);
imshow(cr);

%% Cb Cr subsample
cr2 = imresize(imresize(cr,0.5,'bilinear'),2,'bilinear');
cb2 = imresize(imresize(cb,0.5,'bilinear'),2,'bilinear');

peppers_cbcrsubsample = peppers_ycbcr;
peppers_cbcrsubsample(:,:,2) = cb2;
peppers_cbcrsubsample(:,:,3) = cr2;

figure(5);
imshow(ycbcr2rgb(peppers_cbcrsubsample));

%% Chroma subsample
y2 = imresize(imresize(y,0.5,'bilinear'),2,'bilinear');

peppers_ysubsample = peppers_ycbcr;
peppers_ysubsample(:,:,1) = y2;

figure(6);
imshow(ycbcr2rgb(peppers_ysubsample));

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

%========================================
% Image Transform
%========================================
%% Plot DCT matrix
f = rgb2gray(imread('../lena.tiff'));
T = dctmtx(8);
% for i = 1:8
%     figure(i);
%     stem(T(i, :));
% end
figure();
subplot(1, 1, 1), imshow(T, []);
F_trans = floor(blockproc(double(f) - 128, [8 8], @(x) T * x.data * T'));
figure();
subplot(1, 2, 1), imshow(F_trans(297:304, 81:88), []);
subplot(1, 2, 2), imshow(F_trans(1:8, 1:8), []);

figure();
subplot(2, 1, 1), imshow(f(297:304, 81:88), []);
subplot(2, 1, 2), imshow(f(1:8, 1:8), []);

mask = [1 1 1 0 0 0 0 0;
        1 1 0 0 0 0 0 0;
        1 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0];
    
F_thresh = blockproc(F_trans, [8 8], @(x) mask.*x.data);
f_thresh = floor(blockproc(F_thresh, [8 8], @(x) T'*x.data*T)) + 128;
figure();
imshow(f_thresh, []);
%% test
trans = F_trans(1:8, 1:8);
for i = 1:8
    figure(i);
    stem(trans(i, :));
end

%========================================
% Quantization
%========================================
%% Quantization
T = dctmtx(8);
k = 1;
figure();
for j = [1 3 5 10]
    Z = [16 11 10 16 24 40 51 61;
        12 12 14 19 26 58 60 55;
        14 13 16 24 40 57 69 56;
        14 17 22 29 51 87 80 62;
        18 22 37 56 68 109 103 77;
        24 35 55 64 81 104 113 92;
        49 64 78 87 103 121 120 101;
        72 92 95 98 112 100 103 99];
    Z = j*Z;
    F_trans = floor(blockproc(double(f) - 128, [8 8], @(x) T * x.data * T'));

    F_trans_quant = round(blockproc(F_trans, [8 8], @(x)  x.data ./ Z));

    % inverse
    F_thresh = blockproc(F_trans_quant, [8 8], @(x) Z.*x.data);
    f_thresh = blockproc(F_thresh, [8 8], @(x) T'*x.data*T) + 128;
    figure();
    imshow(f_thresh, []);
    k = k +1;
end