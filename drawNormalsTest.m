function [triangleCord] = drawNormalsTest(volume ,surfaceFace, surfaceVertex, pt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

neighbours = 500;
numOfTriangles = 0;
volumeMidPoint = computeNormal(surfaceVertex);

ptRow = knnsearch(surfaceVertex,pt,'k',neighbours);

for i=1:size(ptRow,2)
numOfTriangles = numOfTriangles + size(find(surfaceFace==ptRow(1,i)),1);
end

triangleCord = zeros(numOfTriangles, 3, 3);

numTriangle = 1;

for i=1:size(ptRow, 2)
    
vertexRow = ptRow(1,i);

[triangleRows, ~] = find(surfaceFace == vertexRow);

for j=1:size(triangleRows,1)
    
triangleAddress = surfaceFace(triangleRows(j,1), :);
triangleCord(numTriangle,:,:) = surfaceVertex(triangleAddress,:);
numTriangle = numTriangle + 1;

end
end

%figure;

%{
axis ij
axis tight
grid on;
daspect([1,1,2])
rotate3d on;
%}

%setDisplaySettings(volume)
%Compute normals for each triangle

for i=1:size(triangleCord,1)
    
    triangleXData = triangleCord(i,:,1);
    triangleYData = triangleCord(i,:,2);
    triangleZData = triangleCord(i,:,3) + 3;
    hold on;

    trisurf([1 2 3], triangleXData, triangleYData, triangleZData, 'FaceColor', [1 0.75 0.45], 'EdgeColor', 'r');
    
end

end

