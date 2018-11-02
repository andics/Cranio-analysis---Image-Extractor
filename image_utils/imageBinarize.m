function [imageBW] = imageBinarize(imageFile, colorThresh)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

    imageBW = imbinarize(imageFile, colorThresh);

  %  imageBW = bwmorph(imageBW, 'thicken', 3);
    imageBW = bwmorph(imageBW, 'bridge', Inf);

    imageBW = imageFillHoles(imageBW);

end

