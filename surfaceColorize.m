function [surfaceColors] = surfaceColorize(F, mainColor, newColor)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

sizeF = size(F,1);
newColorStart = round(sizeF/2);

surfaceColors = zeros(sizeF, 3);

for i=1:sizeF
    
    surfaceColors(i,:) = mainColor;
    
end


for i=newColorStart:newColorStart+100000
   
    surfaceColors(i,:) = newColor;
    
end

end

