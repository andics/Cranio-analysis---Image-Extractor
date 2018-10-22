function [] = findPath(cursorData, skullFig, skullPatch)
%Use A* search algorithm to find verticies of the graph describing the shortest path
%between the two ends of the suture. We'll use those points later to
%generate equally spaced images along the lenght of the suture
tic;

skullPatch = handle(double(skullPatch));
surfaceFace = skullPatch.Faces;
surfaceVertex = skullPatch.Vertices;
volumeMidPoint = [mean(surfaceVertex(:,1)), mean(surfaceVertex(:,2)), mean(surfaceVertex(:,3))];

numOfPoints = size(cursorData, 2);
surfacePoints = zeros(numOfPoints, 3);
reachedTarget = 0;
visitedPoints = [];

for i=1:numOfPoints
surfacePoints(i,:) = cursorData(1,i).Position;
end

%Keep point cordinates as rows in surfaceVertex in order to save time when
%accessing them during the graph search
currentPoint = knnsearch(surfaceVertex,surfacePoints(1,:),'k',1)

endPoint = knnsearch(surfaceVertex,surfacePoints(end,:),'k',1);

while reachedTarget==0
    
    connectedVertices = findConnectedVertices(currentPoint, surfaceFace, surfaceVertex);
    minDist = inf(1);
    
    for i=1:size(connectedVertices, 1)
        currentDist = pdist([surfaceVertex(connectedVertices(i,1),:); surfaceVertex(endPoint,:)]);
       if currentDist < minDist
            minDist = currentDist
            currentPoint = connectedVertices(i,1);
       end
    end 
    
    visitedPoints = [visitedPoints, currentPoint];
    
    if currentPoint == endPoint
        reachedTarget = 1;
    end
    
end
visitedPoints = permute(visitedPoints ,[2 1]);



suturePoints(size(visitedPoints, 1),1) = suture_point;

visitedPointsCord = surfaceVertex(visitedPoints,:);

for i=1:size(suturePoints,1)
    suturePoints(i,1).init(visitedPointsCord(i,:), visitedPoints(i, 1), skullFig, skullPatch, volumeMidPoint);
    i = i
    if mod(i,20) == 0
        suturePoints(i,1).setNeighbours(20)
    end
end

colorPtIndex = find(arrayfun(@(suturePoints) ~isempty(suturePoints.neighbourTrRows),suturePoints));
colorPtIndex = vertcat(suturePoints(colorPtIndex).neighbourTrRows);

trColorize(skullPatch, colorPtIndex);

%connectedVertices = findConnectedVertices(currentPoint, surfaceFace, surfaceVertex)


toc;

end

function [ptRow] = findConnectedVertices(pt, surfaceFace, surfaceVertex)
%Consider that the surfaceFace variable is somewhat sorted, so we can
%minimize the range in which neighbouring faces might be

    [trRow, ~] = find(surfaceFace == pt);
    ptRow = unique(surfaceFace(trRow,:));
    ptRow(ptRow == pt) = [];
    
    
end

