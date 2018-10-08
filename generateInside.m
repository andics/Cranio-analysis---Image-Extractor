function [insideFace, insideVertex, insideColor] = generateInside(D, image_num)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

slice_D = D(:,:,1:image_num);

[insideFace, insideVertex, insideColor] = isocaps(slice_D,10);

end

