function [Area] = trigArea(sides)
%Get the area of a triangle with lenghts sides(:,:)
%Use Heron's formula

lenghts = zeros(1,3);
lenghts(1,1) = norm(sides(1,:));
lenghts(1,2) = norm(sides(2,:));
lenghts(1,3) = norm(sides(3,:));
p = sum(lenghts);

Area = sqrt(p.*(p-lenghts(1,1)).*(p-lenghts(1,2)).*(p-lenghts(1,3)));

end

