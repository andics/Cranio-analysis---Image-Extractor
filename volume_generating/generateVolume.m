function [skullFig, pSurface] = generateVolume(volumeBW, endLayerNum)
%Generate volume surface and inside and combine them

skullFig = createFigure("Main Skull Figure", 0);
mainColor = [1 .75 .65];
if strcmp(endLayerNum, 'all')==1
    endLayerNum = size(volumeBW, 3); 
end

[surfaceFace, surfaceVertex] = generateSurface(volumeBW, endLayerNum);

cData = surfaceColorize(surfaceFace, mainColor);

pSurface = patch('Faces',surfaceFace,'Vertices',surfaceVertex);       % draw the outside of the volume
pSurface.FaceAlpha = 1;
pSurface.EdgeColor = 'none';
pSurface.FaceColor = 'flat';
pSurface.FaceVertexCData = cData;
pSurface.SpecularColorReflectance = 0.5;
pSurface.SpecularStrength = 0.3;

%{
[insideFace, insideVertex, insideColor] = generateInside(volume, endLayerNum);

pInside = patch('Faces', insideFace, 'Vertices', insideVertex, 'FaceVertexCData', insideColor); % draw the outside of the volume
pInside.FaceColor = 'interp';
pInside.EdgeColor = 'none';
pInside.FaceAlpha = 1;
%}


setDisplaySettings(volumeBW);

end

