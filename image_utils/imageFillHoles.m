function [imageNoHoles] = imageFillHoles(imageFile)
%Fill holes in the image and binarize it for further surface generation

holeFillThresh = round((size(imageFile, 1) * size(imageFile, 2)) * 0.55);

imageFile = bwmorph(imageFile, 'thicken', 7);
imageFile = bwmorph(imageFile, 'bridge', Inf);

%imageNoHoles = imageFile;
%imageNoHoles = ~bwareaopen(~imageFile, holeFillThresh);

imageNoHoles = imclearborder(imageFile);
imageNoHoles = imfill(imageFile, 'holes');

end

