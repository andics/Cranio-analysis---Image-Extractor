function [isOnLine, xInter, perpVect] = genPerp(startPt, endPt, perpPoint, drawLine)
%Generate a vector to a point, perpendicular to the startPt-endPt vector
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

if drawLine == 1
drawLine3(startPt, endPt, [0 1 0], 2);
drawLine3(xInter, xInter + perpVect, [0 1 1], 2);
end

perpVect = perpVect/norm(perpVect);

if norm(xInter - startPt) <= abLenght && norm(endPt - xInter) <= abLenght
    isOnLine = 1;
end

end

