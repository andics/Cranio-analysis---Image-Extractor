function [] = showImg(inputImage)
%Show an image in a new Figure

createFigure("Suture Slice Image", 0);
imshow(inputImage, []);

end

