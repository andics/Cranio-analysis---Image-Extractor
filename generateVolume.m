function [surfaceFace, surfaceVertex] = generateVolume(volume, volumeBW, endLayerNum)
%Generate volume surface and inside and combine them

imageFile = volume(:,:,round(endLayerNum/2));
mainColor = [1 0.75 .65];
newColor = [0 1 0];

imshow(imageFile, [])
xDim = xlim;
yDim = ylim;

figure;


[surfaceFace, surfaceVertex] = generateSurface(volumeBW, endLayerNum);

surfaceColors = surfaceColorize(surfaceFace, mainColor, newColor);
size(surfaceColors)
size(surfaceFace)

pSurface = patch('Faces',surfaceFace,'Vertices',surfaceVertex);       % draw the outside of the volume
pSurface.FaceAlpha = 1;
%pSurface.EdgeColor = 'none';
pSurface.FaceColor = 'flat';
pSurface.FaceVertexCData = surfaceColors;



%{
[insideFace, insideVertex, insideColor] = generateInside(volume, endLayerNum);

pInside = patch('Faces', insideFace, 'Vertices', insideVertex, 'FaceVertexCData', insideColor); % draw the outside of the volume
pInside.FaceColor = 'interp';
pInside.EdgeColor = 'none';
pInside.FaceAlpha = 1;
%}

setDisplaySettings(volume);

end

