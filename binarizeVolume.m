function [D] = binarizeVolume(D)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
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

figure; imshow(D(:,:,image_num), []);

end

