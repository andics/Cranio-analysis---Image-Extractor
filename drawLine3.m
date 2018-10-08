function [] = drawLine3(point1, point2)
%Draw a line between 2 points in a 3d space

hold on;

xData = [point1(2), point2(2)];
yData = [point1(1), point2(1)];
zData = [point1(3), point2(3)];

plot3(yData, xData, zData, 'r')

hold off;

end

