function [surfaceColors] = surfaceColorize(F, mainColor)
%Initialize a list of FaceVertexCData for the skull, to be able to color
%specific points on the surface later on

sizeF = size(F, 1);
surfaceColors = zeros(sizeF, 3);

for i=1:sizeF
    
    surfaceColors(i,:) = mainColor;
    
end
end

