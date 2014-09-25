function [] = ImageEnhancement(tire)
  figure(1);
  subplot(2, 1, 1);
  imhist(tire);
  subplot(2, 1, 2);
  imshow(tire);
  
  figure(2);
  tireNegative = imcomplement(tire);
  subplot(2, 1, 1);
  imshow(tireNegative);
  subplot(2, 1, 2);
  imhist(tireNegative);
  
  figure(3);
  light = im2double(tire).^0.5; 
  subplot(2, 1, 1);
  imshow(light);
  subplot(2, 1, 2);
  imhist(light);
  
  figure(4);
  dark = im2double(tire).^1.3;
  subplot(2, 1, 1);
  imshow(dark);
  subplot(2, 1, 2);
  imhist(dark);
  
  figure(5);
  equalizedTire = histeq(tire);
  subplot(2, 1, 1);
  imshow(equalizedTire);
  subplot(2, 1, 2);
  imhist(equalizedTire);
end

