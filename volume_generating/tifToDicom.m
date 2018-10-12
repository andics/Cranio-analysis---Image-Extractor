function [] = tifToDicom(imageFolder)
%Save a a chosen region from a tif as a dicom

tif_file = fullfile(imageFolder);

obj = Tiff(tif_file,'r');

imageFile = obj.read();

imshow(imageFile, []);

hFH = imrect();
xy = hFH.getPosition;
binaryCropp = hFH.createMask();
imageCropped = imcrop(imageFile, xy);
figure;
imshow(imageCropped, []);
drawnow;

dicomwrite(imageFile, 'currentImage.dcm');

end

