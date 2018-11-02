function [suturePoints] = findPts(cursorData, skullFig, skullPatch, numOfPics, radius)
%Use A* search algorithm to find verticies of the graph describing the shortest path
%between the two ends of the suture. Use those points to
%generate equally spaced points with normals along the lenght of the suture
tic;

skullPatch = handle(double(skullPatch));
surfaceFace = skullPatch.Faces;
surfaceVertex = skullPatch.Vertices;
volumeMidPoint = [mean(surfaceVertex(:,1)), mean(surfaceVertex(:,2)), mean(surfaceVertex(:,3))];

reachedTarget = 0;
visitedPoints = zeros(1,2);

surfacePoints = genPts(cursorData);

suturePointStart = surfacePoints(1, 1:3);
suturePointEnd = surfacePoints(end, 1:3);
suturePointsPerp = surfacePoints(2:end-1,1:3);

currentPoint = knnsearch(surfaceVertex,suturePointStart,'k',1);
endPoint = knnsearch(surfaceVertex,suturePointEnd,'k',1);

figure;
axis ij
axis tight
grid on;
daspect([1,1,1])
rotate3d on;
[~, currentPerpIntersec, currentPerpVect] = genPerp(suturePointStart, suturePointEnd, suturePointsPerp(1,:))


%Make sure the path finding never decides to start going in the
%opposite to the end point direction, only because the smallest angle
%vector is in that direction
minZInter = Inf(1);
minDist = Inf(1);
activateBruteThePathDestroyer = 0;
indexOfPerpVect = 1;
maxIndexOfPerpVect = size(suturePointsPerp, 1);

while reachedTarget==0
    
    connectedVertices = findConnectedVertices(currentPoint, surfaceFace, surfaceVertex);
    minAlpha = 360;

    for i=1:size(connectedVertices, 1)
        currentDist = pdist([surfaceVertex(connectedVertices(i,1),:); surfaceVertex(endPoint,:)]);
        [isOnLine, ptInter, compareVector] = genPerp(suturePointStart, suturePointEnd, surfaceVertex(connectedVertices(i,1),:));
        CosAlpha = dot(currentPerpVect,compareVector) / (norm(currentPerpVect) * norm(compareVector));
        Alpha = acosd(CosAlpha);
       if currentDist > 3 && activateBruteThePathDestroyer == 0
       if Alpha < minAlpha && ismember(horzcat(connectedVertices(i,1), indexOfPerpVect), visitedPoints, 'rows') == 0 && isOnLine == 1 && ptInter(3)<=minZInter
            minAlpha = Alpha;
            currentPoint = connectedVertices(i,1);
            zInter = ptInter(3);
       end
       else
         %Actiavte the inaccurate algorithm at the end of the suture to
         %make sure we don't miss the end point
         activateBruteThePathDestroyer = 1;
           if currentDist < minDist && ismember(horzcat(connectedVertices(i,1), indexOfPerpVect), visitedPoints, 'rows') == 0
                minDist = currentDist;
                currentPoint = connectedVertices(i,1);
           end
       end
    end 
    disp(['Distance from suture end point: ', num2str(currentDist)]);
    disp(['Angle of chosen point: ', num2str(minAlpha)]);
    
    %Ensure that the chosen path point won't be in the opposite ti teh end
    %point direction
    if zInter<minZInter
        minZInter = zInter;
    end
   
    visitedPoints = vertcat(visitedPoints, horzcat(currentPoint, indexOfPerpVect));
   
    if ptInter(3) < currentPerpIntersec(3)
      if indexOfPerpVect + 1 <= maxIndexOfPerpVect
        suturePointStart = surfaceVertex(currentPoint,:);
        minZInter = Inf(1);
        indexOfPerpVect = indexOfPerpVect + 1
        [~, currentPerpIntersec, currentPerpVect] = genPerp(suturePointStart, suturePointEnd, suturePointsPerp(indexOfPerpVect,:));
      end
    end
    
    if currentPoint == endPoint
        reachedTarget = 1;
    end
    
end

disp(['Found suture path!']);
visitedPoints(1,:) = [];
visitedPoints = visitedPoints
visitedPointsCord = surfaceVertex(visitedPoints(:,1),:);

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

