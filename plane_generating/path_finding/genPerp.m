function [isOnLine, xInter, perpVect] = genPerp(startPt, endPt, perpPoint)
%Generate a vector to a point, perpendicular to the suture vector
%Return 1 if the intersection point belongs to the line, and 0 if it
%doesn't
isOnLine = 0;

ab = endPt - startPt; %// find line vect
abLenght = norm(ab);

%// -(x1 - x0).(x2 - x1) / (|x2 - x1|^2)
t = -(startPt - perpPoint)*(ab.') / (ab*ab.'); 

%// Find foot of perpendicular on the suture line
%Return the foot cordinates
xInter = startPt + (endPt - startPt)*t;

perpVect = perpPoint - xInter;

drawLine3(startPt, endPt);
drawLine3(xInter, xInter + perpVect);

perpVect = perpVect/norm(perpVect);

if norm(xInter - startPt) <= abLenght && norm(endPt - xInter) <= abLenght
    isOnLine = 1;
end

end

