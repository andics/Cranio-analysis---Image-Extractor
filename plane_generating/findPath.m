function [sliceImg] = findPath(skullFig, skullPatch, volume, cursorData)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
numOfPoints = size(cursorData, 2);
surfacePoints = zeros(numOfPoints, 3);

for i=1:numOfPoints
surfacePoints(i,:) = cursorData(1,i).Position;
end

sutureVect = findSurfVect(surfacePoints(1,:), surfacePoints(end,:));

pt = surfacePoints(1,:)

[normVect, ~] = drawNormal(skullFig, skullPatch, pt);

sliceNorm = findSliceNorm(sutureVect, pt, normVect);

drawOnFig(skullFig);
drawLine3(pt, pt+150*sliceNorm);

sliceImg = generateSlice(skullFig, volume, pt, sliceNorm, 60);

end

