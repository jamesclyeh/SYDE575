function DigitalZooming = DigitalZooming(lena, cameraman)
    lenaGrayScale = rgb2gray(lena);
    
    figure(1);
    imshow(lenaGrayScale);
    
    figure(2);
    imshow(cameraman);
    
    lenaLowRes = imresize(lenaGrayScale, 0.25, 'bilinear');
    cameramanLowRes = imresize(cameraman, 0.25, 'bilinear');
    
    figure(3);
    imshow(lenaLowRes);
    
    figure(4);
    imshow(cameramanLowRes);
    
    lenaBilinear = imresize(lenaLowRes, 4, 'bilinear');
    lenaNearest = imresize(lenaLowRes, 4, 'nearest');
    lenaCubic = imresize(lenaLowRes, 4, 'cubic');
    
    cameramanBilinear = imresize(cameramanLowRes, 4, 'bilinear');
    cameramanNearest = imresize(cameramanLowRes, 4, 'nearest');
    cameramanCubic = imresize(cameramanLowRes, 4, 'cubic');
    
    figure;
    imshow(lenaBilinear);
    title('Lena Scaled Bilinear');
    
    figure;
    imshow(lenaNearest);
    title('Lena Scaled Nearest');
    
    figure
    imshow(lenaCubic);
    title('Lena Scaled Cubic');
    
    figure
    imshow(cameramanBilinear);
    title('Cameraman Scaled Bilinear');
    
    figure
    imshow(cameramanNearest);
    title('Cameraman Scaled Nearest');
    
    figure
    imshow(cameramanCubic);
    title('Camerman Scaled Cubic');
    
    PSNR(lenaGrayScale, lenaBilinear)
    PSNR(lenaGrayScale, lenaNearest)
    PSNR(lenaGrayScale, lenaCubic)
    
    PSNR(cameraman, cameramanBilinear)
    PSNR(cameraman, cameramanNearest)
    PSNR(cameraman, cameramanCubic)
end