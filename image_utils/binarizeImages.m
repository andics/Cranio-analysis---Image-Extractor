function [imageFile] = binarizeImages(D, imageStart, imageEnd)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
close all;
image_num = imageEnd - round((imageEnd - imageStart)/2)
imageFile = D(:,:,image_num);


threshValue = calcGThresh(imageFile)

for i=imageStart:imageEnd


imageFile = D(:,:,i);
createFigure("Image number %d Threshheld", i)
imshow(imageFile, [])

bwImage = imbinarize(imageFile, threshValue);
bwImage = imageFillHoles(bwImage);
createFigure("Image number %d BW - Fill Holes", i)
imshow(bwImage, [])


grayImage = imbinarize(imageFile, threshValue);

imageNoHoles = imageFillHoles(grayImage);
%imageNoHoles = grayImage;
createFigure("Image number %d BW - Thick - Bridge - FillHoles", i)
imshow(imageNoHoles, [])

%{
createFigure("Image number %d BW - Thick - Bridge - FillHoles - Contour Slice", i)
imshow(imageEdges, [])
%}



end

%{
bwImage = imbinarize(imageFile, threshValue);
imageFile = imageFile.*bwImage;

createFigure("Image number %d Original", i)
imshow(imageFile, [])
%}

end