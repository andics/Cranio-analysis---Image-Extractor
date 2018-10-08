function [] = computeNormal(surfaceVertex, triangleXData, triangleYData, triangleZData)
%UNTITLED2 Summary of this function goes here

volumeMidPoint = [mean(surfaceVertex(:,1)), mean(surfaceVertex(:,2)), 0];

scatter3(volumeMidPoint(1,1),volumeMidPoint(1,2),volumeMidPoint(1,3),'*')
%compute centroid of triangle
C = [mean(triangleXData), mean(triangleYData), mean(triangleZData)]

hold on;
trisurf([1 2 3], triangleXData, triangleYData, triangleZData, 'FaceColor', [1 0.75 0.45], 'EdgeColor', 'r')
hold on;
scatter3(C(1,1),C(1,2),C(1,3),'*')

point = zeroes(3, 1);

end

