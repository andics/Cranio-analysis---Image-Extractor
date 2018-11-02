classdef suture < handle
    %A suture class containing all suture properties required for image
    %generating
    properties
        suture_points
        label
        save_folder
    end 
    
    methods
        function obj = suture(cursorData, label, save_folder, skullFig, skullPatch, numOfPics, radius)
            %Initialization
            obj.label = label;
            obj.save_folder = fullfile(save_folder,label);
            obj.verifyExpFolder;
            obj.suture_points = findPts_new(cursorData, skullFig, skullPatch, numOfPics, radius);
         %  obj.digitKeeper = join('%0', , '.f')
        end
        
        function obj = drawNormal(obj,ptIndex,c)
            %Draw surface and slice normals at pt
            %pt is an index of the coressponding point in suture_points
            if ptIndex ~= 'all'
            obj.suture_points(ptIndex).drawNormal(c);
            return;
            end
            
            for i=1:numel(obj.suture_points)
               obj.suture_points(i).drawNormal(c); 
            end
        end
         
        function obj = colorPoint(obj, ptIndex, c)
           if ptIndex ~= 'all'
               obj.suture_points(ptIndex).colorPoint(c);
               return;
           end
           trColorize(obj.suture_points(1).skullPatch, vertcat(obj.suture_points(:).neighbourTrRows), c);  
        end
        
        
        function obj = genSliceImg(obj, volume, scale_factor, ptIndex, volumeIndex)
            ptXCord = obj.suture_points(ptIndex).ptCord(1);
            ptYCord = obj.suture_points(ptIndex).ptCord(2);
            slicePlaneX = obj.suture_points(ptIndex).slicePlaneX + ptXCord * (1/scale_factor);
            slicePlaneY = obj.suture_points(ptIndex).slicePlaneY + ptYCord * (1/scale_factor);
            slicePlaneZ = obj.suture_points(ptIndex).slicePlaneZ + volumeIndex;
            
            sliceImg = interp3(volume, slicePlaneX, slicePlaneY,...
            slicePlaneZ, 'cubic');
            sliceImg = mat2gray(sliceImg);
            obj.exportSliceImg(sliceImg, ptIndex);
            
            obj.suture_points(ptIndex).imgLoaded = 1;
            clearvars('slicePlaneX', 'slicePlaneY', 'slicePlaneZ');
        end
        
        
        function obj = generateSingleImg(obj, scan_folder, assoc_list, scale_factor, ptIndex) 
            fprintf(join(['Starting single image generation of point ', num2str(ptIndex), ', from ', obj.label, ' suture\n']));
            
            [tif_files,~] = getDatasetOrder(scan_folder);
            tif_names = {tif_files.name};
            tif_names = string(tif_names);
            tif_names = permute(tif_names, [2 1]);
            
            objImg = Tiff(tif_files(1).name,'r');
            objImg = objImg.read();
            volToAdd = 0;
            max_vol_lim = 433;
            
            planeCenterImg = getZImg(obj.suture_points(ptIndex).ptCord(3), assoc_list);
            centerImgIndex = find(strcmp(tif_names(:,1),planeCenterImg));
            
            %Top is a smaller image index than bottom, because volume is
            %assumed to be starting from the top slice
            topImgIndex = floor(centerImgIndex - obj.suture_points(ptIndex).planeZMax - 5);
            bottomImgIndex = ceil(centerImgIndex + obj.suture_points(ptIndex).planeZMax + 5);
            
            if topImgIndex < 1
               %If the image plane goes outside the volume provided by the dataset,
               %artificially add a volume chunk full of zeros at the top
               volToAdd = abs(topImgIndex);
               fprintf(join(['Plane goes outside of provided dataset volume. Artificially adding ', num2str(volToAdd),...
               ' more images full of black color! \n']));
               topImgIndex = 0;
            end
               volToAdd = zeros(size(objImg, 1), size(objImg,2 ), volToAdd);
               maxVolHeight = floor(findMaxZ(objImg)*(2/3));
               if maxVolHeight > max_vol_lim
                   maxVolHeight = max_vol_lim; 
               end
               fprintf(join(['Max height of volume chunk: ', num2str(maxVolHeight), '\n']));
               
            
            if maxVolHeight < bottomImgIndex - topImgIndex + size(volToAdd, 3)
                str = ['Not enough RAM memory to load point number ', num2str(ptIndex), ' from the ',... 
                    obj.label, ' suture.'];
                strRAM = ['RAM for ', num2str((bottomImgIndex - topImgIndex + size(volToAdd,3)) - maxVolHeight),...
                    ' more pictures is needed!'];
                disp(str);
                disp(strRAM);
                return;
            end
            
            [volume, assoc_list_new] = tiff_read_volume(scan_folder, bottomImgIndex, topImgIndex, 1, 1);
            if size(volToAdd, 3) ~= 0
            volume = cat(3, volToAdd, volume);
            end

            loadedStartImg = str2double(assoc_list_new(1,1));
            loadedEndImg = str2double(assoc_list_new(end,1)) + size(volToAdd, 3);
            
            index = find(assoc_list_new(:,2) == planeCenterImg);
            obj.genSliceImg(volume, scale_factor, ptIndex, index);
            
            clearvars;
        end
        
        
        function obj = verifyExpFolder(obj)
            if ~exist(obj.save_folder, 'dir')
              mkdir(obj.save_folder);
            end
        end
        
        function obj = exportSliceImg(obj, img, ptIndex)
            imgName = [obj.label, num2str(ptIndex, '%04.f'), '.png'];
            imwrite(img, fullfile(obj.save_folder, imgName));
            
            fprintf(join(['\nExported image: ', imgName, ' \n \n']));
        end 
        
        function obj = resetGeneratedImages(obj)
           for i=1:size(obj.suture_points, 1)
               obj.suture_points(i).imgLoaded = 0;
           end
        end
    end
end

