function [] = generateSlices_w(scan_folder, scale_factor, assoc_list, sutures)
%Generate slices for all of the sutures and export the generated images
%The strategy is to start from the top and to generate all of the slices
%contained in the currently loaded chunk of the volume. Generating the
%slices from top to bottom

[tif_files,~] = getDatasetOrder(scan_folder);
tif_names = {tif_files.name};
tif_names = string(tif_names);
tif_names = permute(tif_names, [2 1]);        

obj = Tiff(tif_files(1).name,'r');
obj = obj.read();
max_vol_lim = 433;
%How many extract images to add to the boudrries of the slice.
%This is useful for interpolation, as  it needs some data outside the
%desired values to interpolate better.
ES = 5;

%{
setImages=assoc_list(:,2)~='0';
maxVolImg = max(str2double(assoc_list(setImages,1)));
%}


while true
maxZVal = 0;
maxPlaneZVal = 0;
volToAdd = 0;
currentSuture = 1; 
currentPoint = 1;

for i=1:numel(sutures)
    for j=1:numel(sutures(i).suture_points)
        if sutures(i).suture_points(j).imgLoaded == 0 && sutures(i).suture_points(j).ptCord(3) > maxZVal
           maxZVal =  sutures(i).suture_points(j).ptCord(3);
           maxPlaneZVal = sutures(i).suture_points(j).planeZMax;
           currentSuture = i; 
           currentPoint = j; 
        end
    end
end

if maxZVal == 0
   break;
end

maxZVal = maxZVal;
maxPlaneZVal = maxPlaneZVal;
planeCenterImg = getZImg(maxZVal,assoc_list);

fprintf(join(['Loading volume for point number ', num2str(currentPoint),...
    ' from ', sutures(currentSuture).label, ' suture \n']));
fprintf(join(['Highest unloaded plane found at point: ', num2str(maxZVal), '\n']));


%Find the index corresponding to the top of the slice plane
%Load pictures from there to as much as possible downwards
endImg = find(strcmp(tif_names(:,1),planeCenterImg));
endImg = floor(endImg - maxPlaneZVal - 5);
if endImg < 0
   %If the image plane goes outside the volume provided by the dataset,
   %artificially add a volume chunk full of zeros at the top
   volToAdd = abs(endImg);
   fprintf(join(['Plane goes outside of provided dataset volume. Artificially adding ', num2str(volToAdd),...
       ' more images full of black color! \n']));
   endImg = 0;
end
volToAdd = zeros(size(obj, 1), size(obj,2 ), volToAdd);

%Determine the maximum size of the volume chunk that can be loaded at the
%moment
maxVolHeight = round(findMaxZ(obj)*(2/3));
if maxVolHeight > max_vol_lim
   maxVolHeight = max_vol_lim; 
end
fprintf(join(['Max height of volume chunk: ', num2str(maxVolHeight), '\n']));

startImg = endImg + maxVolHeight;
%startImgName = tif_names(startImg+1,:);
if startImg > size(tif_names,1)
   startImg = size(tif_names,1)-1;
end
if (startImg - endImg + size(volToAdd,3) - 5) < maxPlaneZVal*2
    str = ['Not enough RAM memory to load point number ', num2str(currentPoint), ' from the ',... 
        sutures(currentSuture).label, ' suture. \n Moving to next point'];
    strRAM = ['RAM for ', num2str(ceil(maxPlaneZVal*2-(startImg - endImg - 5))), ' more pictures is needed!'];
    sutures(currentSuture).suture_points(currentPoint).imgLoaded = 2;
    disp(str);
    disp(strRAM);
    continue;
end

[volume, assoc_list_new] = tiff_read_volume(scan_folder, startImg, endImg, 1, 1);
if size(volToAdd, 3) ~= 0
volume = cat(3, volToAdd, volume);
end

loadedStartImg = str2double(assoc_list_new(1,1));
loadedEndImg = str2double(assoc_list_new(end,1)) + size(volToAdd, 3);


for i=1:numel(sutures)
    for j=1:numel(sutures(i).suture_points)
        if sutures(i).suture_points(j).imgLoaded == 0
        planeCenterImg = getZImg(sutures(i).suture_points(j).ptCord(3), assoc_list);
        index = find(assoc_list_new(:,2) == planeCenterImg);
        if ~isempty(index)
                fprintf(['Image center loaded for point ', num2str(j), ' from ',...
                sutures(i).label, ' suture.', ' Checking if the whole slice can be generated.', '\n']);
                fprintf(join(['Loaded starting image:', assoc_list_new(loadedStartImg,2), '\n']));
                fprintf(join(['Loaded end image: ', assoc_list_new(loadedEndImg-size(volToAdd, 3),2), '\n']));
                fprintf(join(['Current point center image: ', planeCenterImg, '\n']));
                fprintf(sprintf('Image one-sided height: %0.4f', sutures(i).suture_points(j).planeZMax));
                fprintf('\n \n');
            
                planeZData = sutures(i).suture_points(j).slicePlaneZ + index;    
            if sutures(i).suture_points(j).planeZMin + index - ES >=  loadedStartImg && sutures(i).suture_points(j).planeZMax + index + ES <= loadedEndImg
                fprintf(join(['Generating slice with image number ', num2str(j), ' from ', sutures(i).label, ' suture.\n']));
                fprintf('\n \n');
                tic;
                sutures(i).genSliceImg(volume, scale_factor, j, index);
                toc;
            end  
        end
        end
    end
end
clearvars('-except', 'tif_files', 'tif_names', 'obj', 'scan_folder', 'scale_factor', 'assoc_list', 'sutures', 'max_vol_lim');
end
end

