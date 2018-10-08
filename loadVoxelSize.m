function [] = loadVoxelSize(scan_folder)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

imageFile = fullfile(scan_folder, 'cranium0520.tif')
imageFile = Tiff(imageFile, 'r');
tags = Tiff.getTagNames;
tags = squeeze(tags);
imageInfo = strings(size(tags,1),2);

for i=1:size(tags)
    imageInfo(i,1) = char(tags(i));
    
    try
    imageInfo(i,2) = getTag(imageFile, char(tags(i)));
    catch ME 
       imageInfo(i,2) = "NULL"; 
       fprintf(ME.identifier)
       fprintf("\n")
    end

end
imageInfo

end

