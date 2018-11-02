function [surfacePoints] = genPts(cursorData)
%Generate suture start, end and normal points of given cursor data

numOfPoints = size(cursorData, 2);
surfacePoints = zeros(numOfPoints, 4);

for i=1:numOfPoints
surfacePoints(i,1:3) = cursorData(1,i).Position;
end

%Ensure that the point with index of 1 will be at the vertical top of the
%suture. Keeps the top to bottom slice generation consistant
[minVal, minIdx] = min(surfacePoints(:,3));
[pointEndRow, ~] = ind2sub(size(surfacePoints(:,3)),minIdx);
suturePointEnd = surfacePoints(pointEndRow, 1:3);

for i=1:numOfPoints
surfacePoints(i,4) = pdist([surfacePoints(i,1:3); suturePointEnd]);
end

surfacePoints = sortrows(surfacePoints, 4, 'descend');
surfacePoints = surfacePoints(:,1:3);

end

