function [sutureVect] = findSurfVect(startPoint, endPoint)
%Find the vector pointing along the suture such that it is as close as
%possible to pointing upwards.
%This can be particularly usefull when generating slices, so that their
%orientation is consistant

inputVect = endPoint - startPoint;
inputVect = reshape(inputVect, 1, 3);

sutureVect = upVect(inputVect);

end

