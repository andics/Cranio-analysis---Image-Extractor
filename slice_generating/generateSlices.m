function [] = generateSlices(scan_folder, scale_factor, assoc_list, sutures)
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
max_vol_lim = 383;
%How many extract images to add to the boudrries of the slice.
%This is useful for interpolation, as  it needs some data outside the
%desired values to interpolate better.
ES = 5;

%{
setImages=assoc_list(:,2)~='0';
maxVolImg = max(str2double(assoc_list(setImages,1)));
%}


while true
maxCenterZVal = 0;
maxPlaneZVal = 0;
volToAdd = 0;
currentSuture = 1; 
currentPoint = 1;

for i=1:numel(sutures)
    for j=1:numel(sutures(i).suture_points)
        if sutures(i).suture_points(j).imgLoaded == 0 && sutures(i).suture_points(j).ptCord(3) > maxCenterZVal
           maxCenterZVal =  sutures(i).suture_points(j).ptCord(3);
           maxPlaneZVal = sutures(i).suture_points(j).planeZMax;
           currentSuture = i; 
           currentPoint = j; 
        end
    end
end

if maxCenterZVal == 0
   break;
end

maxCenterZVal = maxCenterZVal;
maxPlaneZVal = maxPlaneZVal;
planeCenterImg = getZImg(maxCenterZVal, assoc_list);

fprintf(join(['Loading volume for point number ', num2str(currentPoint),...
    ' from ', sutures(currentSuture).label, ' suture \n']));
fprintf(join(['Highest unloaded plane found at point: ', num2str(maxCenterZVal), '\n']));


%Find the index corresponding to the top of the slice plane
%Load pictures from there to as much as possible downwards
topImgIndex = find(strcmp(tif_names(:,1),planeCenterImg));
topImgIndex = topImgIndex - ceil(maxPlaneZVal) - ES;
if topImgIndex < 0
   %If the image plane goes outside the volume provided by the dataset,
   %artificially add a volume chunk full of zeros at the top
   volToAdd = abs(topImgIndex);
   %Adding 1 to include the zero
   fprintf(join(['Plane goes outside of provided dataset volume. Artificially adding ', num2str(volToAdd),...
       ' more images full of black color! \n']));
   topImgIndex = 0;
end

%Determine the maximum size of the volume chunk that can be loaded at the
%moment
maxVolHeight = round(findMaxZ(obj)*(2/3));
if maxVolHeight > max_vol_lim
   maxVolHeight = max_vol_lim; 
end
fprintf(join(['Max height of volume chunk: ', num2str(maxVolHeight), '\n']));

bottomImgIndex = topImgIndex + maxVolHeight;
fprintf('Height of slice is %i \n', 2*abs(ceil(maxPlaneZVal)));
%startImgName = tif_names(startImg+1,:);
if bottomImgIndex > size(tif_names,1)
   bottomImgIndex = size(tif_names,1)-1;
end

if (bottomImgIndex - topImgIndex + volToAdd) < 2*(ceil(maxPlaneZVal)) + ES
    str = ['Not enough RAM memory to load point number ', num2str(currentPoint), ' from the ',... 
        sutures(currentSuture).label, ' suture. Moving to next point'];
    strRAM = ['RAM for ', num2str((ceil(maxPlaneZVal)*2 + ES) -(bottomImgIndex - topImgIndex + volToAdd)),...
        ' more pictures is needed!'];
    sutures(currentSuture).suture_points(currentPoint).imgLoaded = 2;
    disp(str);
    disp(strRAM);
    continue;
end

[volume, assoc_list_new] = tiff_read_volume(scan_folder, bottomImgIndex, topImgIndex, 1, 1);

loadedStartImg = str2double(assoc_list_new(1,1));
loadedEndImg = str2double(assoc_list_new(end,1)) + volToAdd;


for i=1:numel(sutures)
    for j=1:numel(sutures(i).suture_points)
        if sutures(i).suture_points(j).imgLoaded == 0
        planeCenterImg = getZImg(sutures(i).suture_points(j).ptCord(3), assoc_list);
        index = find(assoc_list_new(:,2) == planeCenterImg);
        if ~isempty(index)
                fprintf(['Image center loaded for point ', num2str(j), ' from ',...
                sutures(i).label, ' suture.', ' Checking if the whole slice can be generated.', '\n']);
                fprintf(join(['Loaded starting image:', assoc_list_new(loadedStartImg,2), '\n']));
                fprintf(join(['Loaded end image: ', assoc_list_new(loadedEndImg-volToAdd, 2), '\n']));
                fprintf(join(['Current point center image: ', planeCenterImg, '\n']));
                fprintf(sprintf('Image one-sided height: %0.4f', sutures(i).suture_points(j).planeZMax));
                fprintf('\n \n');
            
                
            if sutures(i).suture_points(j).planeZMin + index - ES - 1 >=  loadedStartImg && sutures(i).suture_points(j).planeZMax + index + ES - 1 <= loadedEndImg
                planeZMax = sutures(i).suture_points(j).planeZMax;
                minZToLoad = floor(index - planeZMax - ES - 1)
                maxZToLoad = ceil(index + planeZMax + ES - 1)
                if maxZToLoad > size(volume, 3)
                   maxZToLoad = size(volume, 3);
                end

                indexToAdd = index - (minZToLoad - 1);
                fprintf(join(['Generating slice with image number ', num2str(j), ' from ', sutures(i).label, ' suture.\n']));
                fprintf(join(['Passed starting image:', assoc_list_new(minZToLoad,2), '\n']));
                fprintf(join(['Passed end image: ', assoc_list_new(maxZToLoad, 2), '\n']));
                fprintf('\n');
                
                sutures(i).genSliceImg(volume(:,:,minZToLoad:maxZToLoad), scale_factor, j, indexToAdd);
            end  
        end
        end
    end
end
clearvars('-except', 'tif_files', 'tif_names', 'obj', 'scan_folder', 'scale_factor', 'assoc_list',...
    'sutures', 'max_vol_lim', 'ES');
end
end

