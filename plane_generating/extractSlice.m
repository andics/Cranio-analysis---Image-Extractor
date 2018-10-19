function [sliceData, xData, yData, zData] = extractSlice(volume, pt, normVect, radius)
%Extract a slice with center at pt and normal vector normVect
%The output is a square matrix representing color values at each image
%pixel on the coresponding plane in volume
planeVect = [0 0 1];

plane = surf(linspace(-radius,radius,2*radius+1),linspace(-radius,radius,2*radius+1),zeros(2*radius+1));

%Find a vector perpendicular to the plane vector and perpendicular to the
%desired normal
%This will be the vector along which we'll rotate the surface
rotationVect = cross(normVect, planeVect);
rotationVect = rotationVect / norm(rotationVect);
acosineVal = dot(normVect, planeVect)/(norm(normVect)*norm(planeVect));
angleDeg = -acosd(acosineVal);
%angleDeg = 0;

%When the desired normal is the same as the plane normal
rotationVect(isnan(rotationVect)) = 1e-12;

rotate(plane, rotationVect, angleDeg, [0 0 0]);

xData = get(plane, 'XData') + pt(1);
yData = get(plane, 'YData') + pt(2);
zData = get(plane, 'ZData') + pt(3);

delete(plane);

sliceData = interp3(volume, xData, yData, zData, 'cubic');

end
