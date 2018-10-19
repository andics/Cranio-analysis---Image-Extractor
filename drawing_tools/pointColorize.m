function [] = pointColorize(skullPatch, surfaceFace, surfaceVertex, pt, neighbours)
%Colorize a circle with center pt and area of neighbours on the surface in color c
%Can later be used to draw lines by individually drawing circles around
%each point of a line 

skullPatch = handle(double(skullPatch));
newColor = [0 0 1];
ptRow = knnsearch(surfaceVertex,pt,'k',neighbours);

% Give "true" if the element in "a" is a member of "b".
c = ismember(surfaceFace, ptRow);
% Extract the elements of a at those indexes.
[newCTriangles, ~] = find(c);
colorData = skullPatch.FaceVertexCData;


for i=1:size(newCTriangles,1)
colorData(newCTriangles(i,1),:) = newColor;
end

set(skullPatch, 'FaceVertexCData', colorData);

end

