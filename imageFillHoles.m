function [imageNoHoles] = imageFillHoles(imageFile)
%Fill holes in the image and binarize it for further surface generation

holeFillThresh = round((size(imageFile, 1) * size(imageFile, 2)) * 0.009);

imageFile = bwmorph(imageFile, 'thicken', 3);
imageFile = bwmorph(imageFile, 'bridge', Inf);

imageNoHoles = ~bwareaopen(~imageFile, holeFillThresh);

end

