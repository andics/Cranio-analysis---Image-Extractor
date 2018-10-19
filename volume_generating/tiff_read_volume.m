function [Volume, assoc_list] = tiff_read_volume(imageFolder, startImage, endImage, rescalingFactorDepth, rescalingFactorImage)
% function for reading volume of Tif files

tif_files = dir(fullfile(imageFolder,'*.tif'));
numOfFiles = size(tif_files,1)

if(numOfFiles>0)
obj = Tiff(tif_files(startImage).name,'r');
Volume = imresize(obj.read(),rescalingFactorImage);
else
    display('No tiff files found in the directiory');
   return;
end
   
if(numOfFiles>1)
    % Initialize voxelvolume
    depth = round((startImage-endImage)*rescalingFactorDepth) + 1;
    Volume=zeros(size(Volume,1),size(Volume,2),depth);
    assoc_list = strings(depth, 2);
    assoc_list(:,:) = 0;
    % Create a waitbar
    h = waitbar(0,'Please wait...');
    for i=1:depth
        index = startImage - round(i/rescalingFactorDepth) + 1
        assoc_list(i,1) = i;
        waitbar(i/depth,h)
        if index<=numOfFiles && index>=1
        assoc_list(i,2) = tif_files(index+1).name;
		obj = Tiff(tif_files(index+1).name,'r');
        Volume(:,:,i) = imresize(obj.read(),rescalingFactorImage);
        end
    end
    close(h);
end
end


