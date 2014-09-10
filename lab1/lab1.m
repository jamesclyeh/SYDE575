close all; clear; clc;

%========================================
% Load images
%========================================

tire = imread('tire.tiff')
tire_noisy = imnoise(tire, 'gaussian')
cameraman = imread('cameraman.tiff')
cameraman_noisy = imread(cameraman, 'gaussian')

