function [p] = drawLine3(point1, point2, c, width)
%Draw a line between 2 points in a 3d space

%Set default color and width
if nargin<3
    c = 'r';
    width = 0.5;
end
    
hold on;

xData = [point1(2), point2(2)];
yData = [point1(1), point2(1)];
zData = [point1(3), point2(3)];

p = plot3(yData, xData, zData, 'Color', c, 'LineWidth', width);
set(p, 'Tag', 'Line')

hold off;

end

