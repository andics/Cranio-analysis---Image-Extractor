function test3d(D, image_num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
close all;
if(nargin<2)
image_num = size(D, 3);
end
image = D(:,:,image_num);

imshow(image, [])
cmap = get(gcf,'Colormap');
xDim = xlim;
yDim = ylim;

%# view slices as countours
slice_D = D(:,:,1:image_num);
figure;

[surfaceFace, surfaceVertex] = isosurface(slice_D,20);

pSurface = patch('Faces',surfaceFace,'Vertices',surfaceVertex);       % draw the outside of the volume

pSurface.FaceColor = [1,.75,.65];
pSurface.EdgeColor = 'none';
pSurface.FaceAlpha = 1;

setDisplaySettings(xDim, yDim, cmap);

%{
figure;

inside = isocaps(slice_D,10);

pInside = patch(inside);       % draw the outside of the volume
pInside.FaceColor = 'interp';
pInside.EdgeColor = 'none';
pInside.FaceAlpha = 1;



setDisplaySettings(xDim, yDim, cmap);


figure;
[surfaceFaceReduced,surfaceVertexReduced] = reducepatch(pSurface,0.01);
pSurfaceReduced = patch('Faces',surfaceFaceReduced,'Vertices',surfaceVertexReduced);
pSurfaceReduced.FaceColor = [1,.75,.65];
pSurfaceReduced.EdgeColor = 'none';
pSurfaceReduced.FaceAlpha = 1;
setDisplaySettings(xDim, yDim, cmap);
%}

end
