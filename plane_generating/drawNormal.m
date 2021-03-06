function [normVect, vectObj] = drawNormal(skullFig, skullPatch, pt, c)
%Draws the normal to the surface at a particular point
%Also displays the triangulated mesh around the point with the
%corresponding normals to each triangle

skullPatch = handle(double(skullPatch));

surfaceVertex = skullPatch.Vertices;
surfaceFace = skullPatch.Faces;
neighbours = 50;
numOfTriangles = 0;
volumeMidPoint = [mean(surfaceVertex(:,1)), mean(surfaceVertex(:,2)), mean(surfaceVertex(:,3))];

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


figure;


axis ij
axis tight
grid on;
daspect([1,1,1])
rotate3d on;



%setDisplaySettings(volume)
%Compute normals for each triangle
normVect = zeros(size(triangleCord,1), 3);

for i=1:size(triangleCord,1)
    
    triangleXData = triangleCord(i,:,1);
    triangleYData = triangleCord(i,:,2);
    triangleZData = triangleCord(i,:,3);
    hold on;

    trisurf([1 2 3], triangleXData, triangleYData, triangleZData, 'FaceColor', [1 0.75 0.45], 'EdgeColor', 'r');
    [C, normVect(i,:)] = computeNormal(triangleXData, triangleYData, triangleZData, volumeMidPoint);
    drawLine3(C, C + normVect(i,:));
%{
    hold on;
    arrow3(C,C + normVect,'b',0.8);
    pbaspect([1 1 1]);
%}
end

normVect = sum(normVect);
normVect = normVect/norm(normVect);
drawOnFig(skullFig);
vectObj = arrow3(pt, pt + 40*normVect, c);
set(vectObj, 'Tag', 'Normal Vector');

end

