function [outputVect] = upVect(inputVect)
%Transform a vector to be as close as possible from pointing upwards
vectUp = [0 0 1];

normVect = zeros(3, 3);
normVect(1,:) = inputVect;
normVect(2,:) = -inputVect;

%Use the fact that the vector pointing upwards will have a smaller angle
%with the vector [0 0 1]
Alpha = 359; 

for i=1:2
CosAlpha = dot(vectUp,normVect(i,:)) / (norm(vectUp) * norm(normVect(i,:)));
if acosd(CosAlpha)<Alpha
Alpha = acosd(CosAlpha);
normVect(3,:) = normVect(i,:);
end
end

outputVect = normVect(3,:);

end

