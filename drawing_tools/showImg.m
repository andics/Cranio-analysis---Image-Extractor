function [] = showImg(inputImage, title)
%Show an image in a new Figure

if nargin<2 
    title = 'Image';
end

createFigure(title, 0);
imshow(inputImage, []);

end

