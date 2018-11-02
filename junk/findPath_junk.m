function [] = findPath_junk(cursorData, skullFig, skullPatch, volumeBW, numOfPics)
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

n = isonormals(volumeBW,surfacePoints(1,:))
drawOnFig(skullFig);
arrow3(surfacePoints(1,:), surfacePoints(1,:) + 40*n);

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

suturePoints(numel(visitedPoints),1) = suture_point;

visitedPointsCord = surfaceVertex(visitedPoints,:);

imgPtIndex = round(linspace(1, numel(suturePoints), numOfPics)')


for i=1:numel(suturePoints)
    suturePoints(i,1).init(visitedPointsCord(i,:), visitedPoints(i, 1), skullFig, skullPatch, volumeMidPoint);
    if ismember(i, imgPtIndex) == 1
        suturePoints(i,1).setNeighbours(100);
        suturePoints(i,1).calcNormal(surfacePoints(1,:), surfacePoints(end,:));
        suturePoints(i,1).drawNormal
    end
end

%Calculate the slice normals using the built in isonormals function
%Save this method, just in case. Continuing to use my custom slice normal
%calculation algorithm, as it is much cheaper in RAM memory and performs more
%accurately
%{
imgPtSurfNorm = isonormals(volumeBW, visitedPointsCord(imgPtIndex, :))

for i=1:numel(imgPtIndex)
    index = imgPtIndex(i);
    suturePoints(index,1).ptSurfaceNorm = imgPtSurfNorm(i,:);
    suturePoints(index,1).calcNormalBuiltIn(surfacePoints(1,:), surfacePoints(end,:));
    suturePoints(index,1).drawNormal('r');
end
%}

%colorPtIndexx = find(arrayfun(@(suturePoints) ~isempty(suturePoints.neighbourTrRows),suturePoints))

trColorize(skullPatch, vertcat(suturePoints(imgPtIndex).neighbourTrRows));
%suturePoints(imgPtIndex(10,1)).drawNormal;

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

