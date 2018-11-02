function [suturePoints] = findPts_backup(cursorData, skullFig, skullPatch, numOfPics, radius)
%A working backup of the pathfinding algorithm
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

%Ensure that the point with index of 1 will be at the vertical top of the
%suture. Keeps the top to bottom slice generation consistant
suturePointStart = surfacePoints(find(surfacePoints(:,3) == max(surfacePoints(:,3))),:);%#ok<*FNDSB>
suturePointEnd = surfacePoints(find(surfacePoints(:,3) == min(surfacePoints(:,3))),:);

currentPoint = knnsearch(surfaceVertex,suturePointStart,'k',1);
endPoint = knnsearch(surfaceVertex,suturePointEnd,'k',1);
   
while reachedTarget==0
    
    connectedVertices = findConnectedVertices(currentPoint, surfaceFace, surfaceVertex);
    minDist = inf(1);
    
    for i=1:size(connectedVertices, 1)
        currentDist = pdist([surfaceVertex(connectedVertices(i,1),:); surfaceVertex(endPoint,:)]);
       if currentDist < minDist && ismember(connectedVertices(i,1), visitedPoints) == 0
            minDist = currentDist;
            currentPoint = connectedVertices(i,1);
       end
    end 
    disp(['Distance from suture end point: ', num2str(minDist)]);
    
    visitedPoints = [visitedPoints, currentPoint];
    
    if currentPoint == endPoint
        reachedTarget = 1;
    end
    
end

disp(['Found suture path!']);
visitedPoints = permute(visitedPoints ,[2 1]);
visitedPointsCord = surfaceVertex(visitedPoints,:);

imgPtIndex = round(linspace(1, numel(visitedPoints), numOfPics)');
suturePoints(numel(imgPtIndex),1) = suture_point;


for i=1:numel(imgPtIndex)
    disp(['Generating slice number: ', num2str(i)]);
    index = imgPtIndex(i);
    suturePoints(i,1).init(visitedPointsCord(index,:), visitedPoints(index, 1), skullFig, skullPatch, volumeMidPoint);
    suturePoints(i,1).setNeighbours(20);
    suturePoints(i,1).calcNormal(suturePointStart, suturePointEnd);
    suturePoints(i,1).genSlicePlane(radius);
end
toc;

end

function [ptRow] = findConnectedVertices(pt, surfaceFace, surfaceVertex)
%Consider that the surfaceFace variable is somewhat sorted, so we can
%minimize the range in which neighbouring faces might be

    [trRow, ~] = find(surfaceFace == pt);
    ptRow = unique(surfaceFace(trRow,:));
    ptRow(ptRow == pt) = [];
    
    
end

