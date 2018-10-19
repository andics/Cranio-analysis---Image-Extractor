function [Area] = trigArea(sides)
%Using Hero's formula to calculate the area of a triangle with sides
%speciffied in sides

lenghts = zeros(1,3);
lenghts(1,1) = norm(sides(1,:));
lenghts(1,2) = norm(sides(2,:));
lenghts(1,3) = norm(sides(3,:));
p = sum(lenghts);

Area = sqrt(p.*(p-lenghts(1,1)).*(p-lenghts(1,2)).*(p-lenghts(1,3)));

end

