function [xDim, yDim] = getXYLim(V)
%Get the X and Y limits of an image plot
%To be used by 3d graphing functions

imageFile = V(:,:,1);

f = figure;
imshow(imageFile, [])
xDim = xlim;
yDim = ylim;
close(f);

end

