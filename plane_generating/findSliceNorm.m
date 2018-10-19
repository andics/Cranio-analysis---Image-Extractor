function [sliceNorm] = findSliceNorm(sutureVect, pt, normVect)
%Given the vector of a suture line on the surface and the normal vect at at
%pt, generate a new normal, tangental to the surface and perpendicular to
%the depth of the bone.
%Also make sure that the generated normal is pointing upwards for
%consistancy in the generated slices

vectUp = [0 0 1];

tempNorm = cross(sutureVect, normVect);
tempNorm = tempNorm/norm(tempNorm);

%Now take tempNorm and normVect to generate the actual normal of the slice

sliceNorm = cross(tempNorm, normVect);
sliceNorm = sliceNorm/norm(sliceNorm);

sliceNorm = upVect(sliceNorm);

end

