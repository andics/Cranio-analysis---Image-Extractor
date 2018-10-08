function [] = generateSliceTest()
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

pt = [640 300 140];
vec = [740 340 170];

normVect = vec - pt
planeVect = [0 0 30]

radius = 50;

plane = surf(linspace(-radius,radius,2*radius+1),linspace(-radius,radius,2*radius+1),zeros(2*radius+1));

drawLine3([0 0 0], normVect);
drawLine3([0 0 0], planeVect);

CosTheta = dot(normVect,planeVect)/(norm(normVect)*norm(planeVect));
ThetaInDegrees = acosd(CosTheta);



rotationVector = vrrotvec(normVect, planeVect);
drawLine3([0 0 0], rotationVector(1:3)*10);

%rotate(plane,rotationVector(1:3)', ThetaInDegrees)

end

