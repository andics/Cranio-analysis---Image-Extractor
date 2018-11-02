function [] = trColorize(skullPatch, trRows, newColor)
%Colorize a set of triangle rows in the FaceVertexCData
%Usually used to color lines on the skull's surface. 
%Lines can also be drawn be individually coloring each point along the line,
%but this requires multiple writings on the FaceVertexCData of the patch,
%which is computationally more inefficient compared to doing it ones for
%all.

skullPatch = handle(double(skullPatch));

colorData = skullPatch.FaceVertexCData;


for i=1:size(trRows,1)
colorData(trRows(i,1),:) = newColor;
end

set(skullPatch, 'FaceVertexCData', colorData);

end

