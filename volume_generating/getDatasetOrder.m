function [tif_files, imageFolder] = getDatasetOrder(imageFolder)
%Check for a text file defining the order of the dataset as ascending or
%decending
%Decending means that the dataset starts from the top of the skull and
%continues down to the bottom


txt_files = dir(fullfile(imageFolder,'*.txt'));
tif_files = dir(fullfile(imageFolder,'*.tif'));
numOfFiles = size(txt_files,1);

if exist(fullfile(imageFolder, 'new_order'), 'dir')
       imageFolder = fullfile(imageFolder, 'new_order');
       addpath(imageFolder);
       tif_files = dir(fullfile(imageFolder,'*.tif'));
       return;
end
if numOfFiles == 0 
    disp('No .txt file found in dataset folder. Assuming the dataset to be in correct order!');
    return;
end
if numOfFiles > 1
    error('Please make sure that there is only one text file in the dataset folder!');
    return;
end

if numOfFiles == 1
    order = strcat(fileread(fullfile(imageFolder, txt_files(1).name)));
    if strcmp(order, 'descending')==1
       return;
  
    elseif strcmp(order, 'ascending')==1
        saveFolder = fullfile(imageFolder, 'new_order');
        mkdir(saveFolder);
        addpath(saveFolder);
        tif_files_flipped = flip(tif_files);
        h = waitbar(0,'Flipping order of image names, please wait...');
        numOfFiles = length(tif_files);
       for id = 1:numOfFiles
        % Flip the names of the images from the dataset
            waitbar(id/numOfFiles,h);
            tif_files(id).name
            tif_files_flipped(id).name
            movefile(fullfile(imageFolder, tif_files(id).name), fullfile(saveFolder, tif_files_flipped(id).name));
       end
       close(h);
       tif_files = dir(fullfile(saveFolder,'*.tif'));
       txtFile = fopen(fullfile(imageFolder, txt_files(1).name),'w');
       fprintf(txtFile, 'descending');
       fclose(txtFile);
       imageFolder = saveFolder;
    else
      error('Please make sure that the text file contains only one of the following words: ascending, descending');
    end
end

end

