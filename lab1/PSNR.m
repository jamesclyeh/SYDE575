function PSNR_out = PSNR(f, g)
  MSE = sum(sum((f - g) .^ 2)) / prod(size(f));
  PSNR_out = 20 * log10(255) - 10 * log10(MSE);
end
