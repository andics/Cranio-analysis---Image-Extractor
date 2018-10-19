function [] = recolorTest(mainPatch)
%Recolor patch

newColor = [0 1 0];

newCTriangles = reshape([3, 5, 2],3,1);

colorData = mainPatch.FaceVertexCData;

for i=1:size(newCTriangles,1)
colorData(newCTriangles(i,1),:) = newColor
end

set(mainPatch, 'FaceVertexCData', colorData);

end

