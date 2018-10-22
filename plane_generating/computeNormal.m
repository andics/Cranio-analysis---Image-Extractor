function [C, normVect] = computeNormal(triangleXData, triangleYData, triangleZData, volumeMidPoint)
%Determine the normal to each triangle which points outwards

%Get vectors of triangle sides
trVect = zeros(3,3);
trVect(1,:) = [triangleXData(1,1)-triangleXData(1,2) triangleYData(1,1)-triangleYData(1,2) triangleZData(1,1)-triangleZData(1,2)];
trVect(2,:) = [triangleXData(1,2)-triangleXData(1,3) triangleYData(1,2)-triangleYData(1,3) triangleZData(1,2)-triangleZData(1,3)];
trVect(3,:) = [triangleXData(1,3)-triangleXData(1,1) triangleYData(1,3)-triangleYData(1,1) triangleZData(1,3)-triangleZData(1,1)];

%compute centroid of triangle
C = [mean(triangleXData), mean(triangleYData), mean(triangleZData)];

vectorMidPoint = volumeMidPoint - C;
vectorMidPoint = vectorMidPoint/norm(vectorMidPoint);

%Determine triangle normal which points outwards by comparing angles between
%the two possible normals and the vector to the midpoint of the volume

%Lets the third vector be the chosen one
normVect = zeros(3:3);

normVect(1,:) = cross(trVect(1,:), trVect(2,:));
normVect(1,:) = normVect(1,:)/norm(normVect(1,:));

normVect(2,:) = cross(trVect(1,:), trVect(3,:));
normVect(2,:) = normVect(2,:)/norm(normVect(2,:));


%Use the fact that the normal pointing outwards will have a larger angle
%with the vector to the midpoint compared to the normal pointing inwards
Alpha = 0; 

for i=1:2
CosAlpha = dot(vectorMidPoint,normVect(i,:)) / (norm(vectorMidPoint) * norm(normVect(i,:)));

if acosd(CosAlpha)>Alpha
Alpha = acosd(CosAlpha);
normVect(3,:) = normVect(i,:);
end
end

%Scale the normal vector according to the area of the triangle
normVect = normVect(3,:);
normVect = normVect*trigArea(trVect);

end

