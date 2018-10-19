function [slice] = generateSlice(skullFig, volume, pt, vec, radius)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
pt = reshape(pt, 1, 3);
vec = reshape(vec, 1, 3);

drawOnFig(skullFig);
[slice,subX,subY,subZ] = extractSlice(volume,pt,vec,radius);
sliceSurf = surf(subX,subY,subZ,slice,'FaceColor','texturemap','EdgeColor','none');
set(sliceSurf, 'Tag', 'Slice Surface')

drawnow;

end

