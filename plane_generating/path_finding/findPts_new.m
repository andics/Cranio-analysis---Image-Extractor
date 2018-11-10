function [suturePoints] = findPts_new(cursorData, skullFig, skullPatch, numOfPics, radius)
%Use a geometric path finding approach to find a suture path.
%Generate equally spaced points with normals along the lenght of the suture
%Works with an unlimited number of suture defining points

tic;

%How many surrounding points should be considered to generate the surface
%normal at a particular point
neighboursNorm = 20;

skullPatch = handle(double(skullPatch));
surfaceFace = skullPatch.Faces;
surfaceVertex = skullPatch.Vertices;
volumeMidPoint = [mean(surfaceVertex(:,1)), mean(surfaceVertex(:,2)), mean(surfaceVertex(:,3))];

reachedTarget = 0;
visitedPoints = [];

surfacePoints = genPts(cursorData);

suturePointStart = surfacePoints(1, 1:3);
suturePointEnd = surfacePoints(end, 1:3);

currentPoint = knnsearch(surfaceVertex,suturePointStart,'k',1);
endPoint = knnsearch(surfaceVertex,suturePointEnd,'k',1);

figure;
axis ij
axis tight
grid on;
daspect([1,1,1])
rotate3d on;



%Make sure the path finding never decides to start going in the
%opposite to the end point direction, only because the smallest angle
%vector is in that direction
minDist = Inf(1);
activateBruteThePathDestroyer = 0;
indexOfStartPoint = 1;
changeStartEndPoint = 1;

while reachedTarget==0
    
    %Every time our path reaches the perpendicular point foot, we want to
    %change the start, end and the perpendicular point which the path
    %follows.
    if indexOfStartPoint + 2 <= size(surfacePoints, 1) && changeStartEndPoint == 1
    linePointStart = surfacePoints(indexOfStartPoint,1:3);
    linePointEnd = surfacePoints(indexOfStartPoint+2,1:3);
    [~, currentPerpIntersec, currentPerpVect] = genPerp(surfacePoints(indexOfStartPoint,:),...
        surfacePoints(indexOfStartPoint+2,:), surfacePoints(indexOfStartPoint+1,:), 1);
    changeStartEndPoint = 0;
    %Orientation of the current path line
    normFootDistLineEnd = pdist([currentPerpIntersec; linePointEnd])
    minDistLineEnd = Inf(1);
    disp(['Index of new line starting point: ', num2str(indexOfStartPoint)]);
    end
    
    connectedVertices = findConnectedVertices(currentPoint, surfaceFace);
    minAlpha = 360;

    for i=1:size(connectedVertices, 1)
        currentDist = pdist([surfaceVertex(connectedVertices(i,1),:); surfaceVertex(endPoint,:)]);
        [isOnLine, ptInter, compareVector] = genPerp(linePointStart, linePointEnd, surfaceVertex(connectedVertices(i,1),:), 1);
        currentDistLineEnd = pdist([surfaceVertex(connectedVertices(i,1),:); linePointEnd]);
        CosAlpha = dot(currentPerpVect,compareVector) / (norm(currentPerpVect) * norm(compareVector));
        Alpha = acosd(CosAlpha);
       if currentDist > 3 && activateBruteThePathDestroyer == 0
       if Alpha < minAlpha && ismember(connectedVertices(i,1), visitedPoints) == 0 && isOnLine == 1
           if currentDistLineEnd<minDistLineEnd
            minAlpha = Alpha;
            currentPoint = connectedVertices(i,1);
            chosenPointDistLineEnd = currentDistLineEnd;
            chosenPointPtInter = ptInter;
           end
       end
       else
         %Activate the inaccurate algorithm at the end of the suture to
         %make sure we don't miss the end point
         activateBruteThePathDestroyer = 1;
           if currentDist < minDist && ismember(connectedVertices(i,1), visitedPoints) == 0
                minDist = currentDist;
                currentPoint = connectedVertices(i,1);
           end
       end
    end 
    disp(['Distance from suture end point: ', num2str(currentDist)]);
    disp(['Angle of chosen point: ', num2str(minAlpha)]);
   
    visitedPoints = [visitedPoints, currentPoint];
    pathEndDist = pdist([chosenPointPtInter; linePointEnd]);
   
    %Make sure to change the start end point once the perp point is reached
    %if chosenPointPtInter(3) < currentPerpIntersec(3)
    if normFootDistLineEnd > pathEndDist
        changeStartEndPoint = 1;
        indexOfStartPoint = indexOfStartPoint + 1;
    end
    
    %Ensure that the chosen path point won't be in the opposite to the end
    %point direction
    if chosenPointDistLineEnd<minDistLineEnd
        minDistLineEnd = chosenPointDistLineEnd;
    end
    
    if currentPoint == endPoint
        reachedTarget = 1;
    end
    
end

disp(['Found suture path!']);
visitedPoints = permute(visitedPoints, [2 1]);
visitedPointsCord = surfaceVertex(visitedPoints(:,1),:);

imgPtIndex = round(linspace(1, numel(visitedPoints), numOfPics)');
suturePoints(numel(imgPtIndex),1) = suture_point;


for i=1:numel(imgPtIndex)
    disp(['Generating plane number: ', num2str(i)]);
    index = imgPtIndex(i);
    suturePoints(i,1).init(visitedPointsCord(index,:), visitedPoints(index, 1), skullFig, skullPatch, volumeMidPoint);
    suturePoints(i,1).setNeighbours(neighboursNorm);
    suturePoints(i,1).calcNormal(suturePointStart, suturePointEnd);
    suturePoints(i,1).genSlicePlane(radius);
end
toc;

end

function [ptRow] = findConnectedVertices(pt, surfaceFace)
%Consider that the surfaceFace variable is somewhat sorted, so we can
%minimize the range in which neighbouring faces might be

    [trRow, ~] = find(surfaceFace == pt);
    ptRow = unique(surfaceFace(trRow,:));
    ptRow(ptRow == pt) = [];
    
end


