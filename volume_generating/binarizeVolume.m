function [D] = binarizeVolume(D, toSmooth)
%Binarize the volume of images, as not much detail is needed on the Skull's
%3d modell for the selection of the sutures. This saves a lot of resources
%when generating the 3d skull model
close all;

image_num = round(size(D, 3)/2);
imageFile = D(:,:,image_num);
num_of_img = size(D, 3);

imshow(imageFile, [])

threshValue = calcGThresh(imageFile);

for i=1:num_of_img
    i
    D(:,:,i) = imageBinarize(D(:,:,i), threshValue);
end

if nargin == 2
   D = smooth3(D); 
end

figure; imshow(D(:,:,image_num), []);

end

