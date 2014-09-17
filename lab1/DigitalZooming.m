function DigitalZooming = DigitalZooming(lena, cameraman)
    lenaGrayScale = rgb2gray(lena);
    
    lenaLowRes = imresize(lenaGrayScale, 0.25, 'bilinear');
    cameramanLowRes = imresize(cameraman, 0.25, 'bilinear');
    
    figure
    imagesc(lenaLowRes);
    colormap gray
    title('Lena Low Res');
    
    figure
    imagesc(cameramanLowRes);
    colormap gray
    title('Cameraman Low Res');
    
%     lenaLowRes = single(lenaLowRes);
    lenaBilinear = imresize(lenaLowRes, 4, 'bilinear');
    lenaNearest = imresize(lenaLowRes, 4, 'nearest');
    lenaCubic = imresize(lenaLowRes, 4, 'cubic');
    
%     cameramanLowRes = single(cameramanLowRes);
    cameramanBilinear = imresize(cameramanLowRes, 4, 'bilinear');
    cameramanNearest = imresize(cameramanLowRes, 4, 'nearest');
    cameramanCubic = imresize(cameramanLowRes, 4, 'cubic');
    
    figure
    imagesc(lenaBilinear);
    colormap gray
    title('Lena Scaled Bilinear');
    
    figure
    imagesc(lenaNearest);
    colormap gray
    title('Lena Scaled Nearest');
    
    figure
    imagesc(lenaCubic);
    colormap gray
    title('Lena Scaled Cubic');
    
    figure
    imagesc(cameramanBilinear);
    colormap gray
    title('Cameraman Scaled Bilinear');
    
    figure
    imagesc(cameramanNearest);
    colormap gray
    title('Cameraman Scaled Nearest');
    
    figure
    imagesc(cameramanCubic);
    colormap gray
    title('Camerman Scaled Cubic');
    
    PSNR(lenaGrayScale, lenaBilinear)
    PSNR(lenaGrayScale, lenaNearest)
    PSNR(lenaGrayScale, lenaCubic)
    
    PSNR(cameraman, cameramanBilinear)
    PSNR(cameraman, cameramanNearest)
    PSNR(cameraman, cameramanCubic)
end