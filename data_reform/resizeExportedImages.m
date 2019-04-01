function [] = resizeExportedImages(filePath, outputSize)
%Uniformly crop images to desired dimensions

imageFiles = ReadFileNames(filePath);

imageSize = imread(imageFiles{1});
[rows, cols, ~] = size(imageSize);

space_left_horizontal = round((cols - outputSize(2))/2)
space_right_horizontal = cols - outputSize(2) - space_left_horizontal

space_up_vertical = round((rows - outputSize(1))/2)
space_down_vertical = rows - outputSize(1) - space_up_vertical


for i=1:numel(imageFiles)
   currentImage = imread(imageFiles{i});
   
   currentImage_cropped = currentImage(1 + space_down_vertical:end - space_up_vertical, 1 + space_left_horizontal:end - space_right_horizontal, :);

   size(currentImage_cropped)
   
   imwrite(currentImage_cropped, imageFiles{i});
  
   fprintf("Found and cropped image in path %s \n", imageFiles{i});
end

fprintf("Finished image cropping! \n");

end

