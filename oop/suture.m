classdef suture < handle
    %A suture class containing all suture properties required for image
    %generating
    properties
        suture_points
        label
        export_folder
        scan_folder
    end 
    
    methods
        function obj = suture(cursorData, label, scan_folder, export_folder, skullFig, skullPatch, numOfPics, radius)
            %Initialization
            obj.label = label;
            obj.scan_folder = scan_folder;
            obj.export_folder = fullfile(export_folder,label);
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
            
            minZPlane = min(slicePlaneZ(:));
            fprintf(join(['Slice lowest Z value in provided volume: ', num2str(minZPlane), '\n \n']));
            szVol = size(volume)
            
            tic;
            sliceImg = interp3(volume, slicePlaneX, slicePlaneY,...
            slicePlaneZ, 'cubic', 0);
            toc;
            
            sliceImg = mat2gray(sliceImg);
            obj.exportSliceImg(sliceImg, ptIndex);
            
            obj.suture_points(ptIndex).imgLoaded = 1;
            clearvars('slicePlaneX', 'slicePlaneY', 'slicePlaneZ');
        end
        
        
        function obj = generateSingleImg(obj, assoc_list, scale_factor, ptIndex) 
            fprintf(join(['Starting single image generation of point ', num2str(ptIndex), ', from ', obj.label, ' suture\n']));
            
            [tif_files,~] = getDatasetOrder(obj.scan_folder);
            tif_names = {tif_files.name};
            tif_names = string(tif_names);
            tif_names = permute(tif_names, [2 1]);
            
            objImg = Tiff(tif_files(1).name,'r');
            objImg = objImg.read();
            volToAdd = 0;
            max_vol_lim = 311;
            ES = 5;
            
            planeCenterImg = getZImg(obj.suture_points(ptIndex).ptCord(3), assoc_list);
            [centerImgIndex, ~] = find(strcmp(tif_names(:,1),planeCenterImg));
            
            %Top is a smaller image index than bottom, because volume is
            %assumed to be starting from the top slice
            topImgIndex = floor(centerImgIndex - obj.suture_points(ptIndex).planeZMax - ES);
            bottomImgIndex = ceil(centerImgIndex + obj.suture_points(ptIndex).planeZMax + ES);
            
            if topImgIndex < 1
               %If the image plane goes outside the volume provided by the dataset,
               %artificially add a volume chunk full of zeros at the top
               volToAdd = abs(topImgIndex);
               fprintf(join(['Plane goes outside of provided dataset volume. Artificially adding ', num2str(volToAdd),...
               ' more images full of black color! \n']));
               topImgIndex = 0;
            end
            
               fprintf('Height of slice is %i \n', abs(bottomImgIndex - topImgIndex));

               maxVolHeight = floor(findMaxZ(objImg)*(2/3));
               if maxVolHeight > max_vol_lim
                   maxVolHeight = max_vol_lim; 
               end
               fprintf(join(['Max height of volume chunk: ', num2str(maxVolHeight), '\n']));
               
            
            if maxVolHeight < bottomImgIndex - topImgIndex
                str = ['Not enough RAM memory to load point number ', num2str(ptIndex), ' from the ',... 
                    obj.label, ' suture.'];
                strRAM = ['RAM for ', num2str(bottomImgIndex - topImgIndex - maxVolHeight),...
                    ' more pictures is needed!'];
                disp(str);
                disp(strRAM);
                return;
            end
            
            [volume, assoc_list_new] = tiff_read_volume(obj.scan_folder, bottomImgIndex, topImgIndex, 1, 1);

            fprintf(join(['Passed starting image:', assoc_list_new(1,2), '\n']));
            fprintf(join(['Passed end image: ', assoc_list_new(end, 2), '\n']));
            
            index = find(assoc_list_new(:,2) == planeCenterImg);
            obj.genSliceImg(volume, scale_factor, ptIndex, index);
            
            clearvars;
        end
        
        
        function obj = verifyExpFolder(obj)
            if ~exist(obj.export_folder, 'dir')
              mkdir(obj.export_folder);
            end
        end
        
        function obj = exportSliceImg(obj, img, ptIndex)
            imgName = [obj.label, num2str(ptIndex, '%04.f'), '.jpg'];
            imwrite(img, fullfile(obj.export_folder, imgName));
            
            fprintf(join(['\nExported image: ', imgName, ' \n \n']));
        end 
        
        function [] = resetGeneratedImages(obj, index)
          if nargin < 2
           for i=1:size(obj.suture_points, 1)
               obj.suture_points(i).imgLoaded = 0;
           end
          else
              obj.suture_points(index).imgLoaded = 0;
          end
        end
    end
end

