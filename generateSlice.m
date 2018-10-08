function [] = generateSlice(V, pt, vec, radius)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


[xDim, yDim] = getXYLim(V);

hold on;

[slice,sliceInd,subX,subY,subZ] = extractSlice(V,pt(1),pt(2),pt(3),vec(1),vec(2),vec(3),radius);
surf(subX,subY,subZ,slice,'FaceColor','texturemap','EdgeColor','none')

setDisplaySettings(xDim, yDim);

drawLine3(pt, pt+vec);

drawnow;

end

