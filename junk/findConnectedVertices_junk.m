function [connectedVertices] = findConnectedVertices_junk(pt, surfaceFace, surfaceVertex)
%Consider that the surfaceFace variable is sorted and use a binary search
%to speed up the search

%Conclusion: Don't try to optimize existing matlab functions like find. You
%can't make it run faster than the matlab one

uncertaintyNumber = 10000;

foundVert = 0;
index = round(size(surfaceFace, 1)/2);
prevIndex = 1;

while foundVert == 0
    currentValue = surfaceFace(index,1);
    indexOld = index;
    
    if (pt-3<currentValue && currentValue<pt+3) == 0
    if currentValue < pt    
        index = round(index + abs(index-prevIndex)/2);
    end
    
    if currentValue > pt  
        index = round(index - abs(index-prevIndex)/2);
    end
    end
    if abs(index-prevIndex)/2 < 200
                foundVert = 1;
    end
    prevIndex = indexOld;
end 

    [trRow, ~] = find(surfaceFace(index-uncertaintyNumber:index+uncertaintyNumber,:) == pt);
    trRow = trRow+index-uncertaintyNumber-1
    connectedVertices = surfaceVertex(unique(surfaceFace(trRow,:)),:);


%{
ptRow = pt;

[trRow, ~] = find(surfaceFace == ptRow)

c = ~ismember(surfaceFace(trRow, :), ptRow);

[vertexRow, vertexColumn] = find(c == 1);

connectedVertices = [];

for i=1:size(vertexRow, 1)
connectedVertices = [connectedVertices, surfaceFace(trRow(vertexRow(i)),vertexColumn(i))];
end

connectedVertices = connectedVertices;
connectedVertices = unique(connectedVertices);
connectedVertices = surfaceVertex(connectedVertices, :);
%}

end