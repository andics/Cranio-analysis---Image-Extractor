function [surfaceFace, surfaceVertex] = generateSurface(D, image_num)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

slice_D = D(:,:,1:image_num);

[surfaceFace, surfaceVertex] = isosurface(slice_D,0.3);

end

