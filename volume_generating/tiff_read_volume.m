function Volume = tiff_read_volume(imageFolder, startImage, endImage, rescalingFactorDepth, rescalingFactorImage)
% function for reading volume of Tif files

tif_files = dir(fullfile(imageFolder,'*.tif'));
numOfFiles = size(tif_files,1)

if(numOfFiles>0)
obj = Tiff(tif_files(startImage).name,'r');
Volume = imresize(obj.read(),rescalingFactorImage);

if(numOfFiles>1)
    % Initialize voxelvolume
    depth = round((startImage-endImage)*rescalingFactorDepth) + 1;
    Volume=zeros(size(Volume,1),size(Volume,2),depth);
    % Create a waitbar
    h = waitbar(0,'Please wait...');
    for i=1:depth
        index = startImage - round(i/rescalingFactorDepth) + 1
        waitbar(i/depth,h)
        if index<=numOfFiles && index>=1
		obj = Tiff(tif_files(index).name,'r');
        Volume(:,:,i) = imresize(obj.read(),rescalingFactorImage);
        end
    end
    close(h);
end
end


