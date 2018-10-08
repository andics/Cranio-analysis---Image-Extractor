function [threshValue] = calcGThresh(imageFile)
%Calculate grayscale threshhold value

threshValue = (graythresh(imageFile)*255)*(2/4);

end

