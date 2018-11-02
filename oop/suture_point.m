classdef suture_point < handle
    %An object representing a point on a suture and all of it's properties
    
    properties
        ptRow 
        ptCord
        neighbourRows
        neighbourCords
        neighbourTrCords
        neighbourTrRows
        sutureLabel
        suturePtNumber
        ptSurfaceNorm
        ptSurfaceNormObj
        ptSliceNorm
        ptSliceNormObj
        slicePlaneX
        slicePlaneY
        slicePlaneZ
        planeZMax
        planeZMin
        skullPatch
        skullFig
        volumeMidPoint
        imgLoaded = 0;
    end
    
    methods
        function obj = suture_point
            %Initialize initial point properties
            obj.ptCord = zeros(1,3);
            obj.imgLoaded = 0;
        end
        
        function obj = init(obj, ptCord, ptRow, skullFig, skullPatch, volumeMidPoint)
           %Initialize basic point properties
            obj.ptCord = ptCord;
            obj.ptRow = ptRow;
            obj.skullFig = skullFig;
            obj.skullPatch = skullPatch;
            obj.volumeMidPoint = volumeMidPoint;
            
        end
        
        function obj = setNeighbours(obj, neighbours)
            %Find and set properties of the point's neighbours
            %Later used to calculate point normal to the surface
            surfaceFace = obj.skullPatch.Faces;
            surfaceVertex = obj.skullPatch.Vertices;
            
            obj.neighbourRows = permute(knnsearch(surfaceVertex, obj.ptCord, 'k', neighbours),[2 1]);
            obj.neighbourCords = surfaceVertex(obj.neighbourRows, :);
            
            c = ismember(surfaceFace, obj.neighbourRows);
            % Extract the elements of a at those indexes.
            [obj.neighbourTrRows, ~] = find(c);
            
            obj.neighbourTrCords = zeros(size(obj.neighbourTrRows, 1), 3, 3);

            numTriangle = 1;

            for i=1:size(obj.neighbourRows, 2)

            vertexRow = obj.neighbourRows(1,i);

            [triangleRows, ~] = find(surfaceFace == vertexRow);

            for j=1:size(triangleRows,1)
            triangleAddress = surfaceFace(triangleRows(j,1), :);
            obj.neighbourTrCords(numTriangle,:,:) = surfaceVertex(triangleAddress,:);
            numTriangle = numTriangle + 1;
            end
            end
            
        end
   
        function obj = drawNormal(obj, c)
            
        drawOnFig(obj.skullFig);
        obj.ptSurfaceNormObj = arrow3(obj.ptCord, obj.ptCord + 40*obj.ptSurfaceNorm, c);
        set(obj.ptSurfaceNormObj, 'Tag', 'Normal Vector');
        
        obj.ptSliceNormObj = drawLine3(obj.ptCord, obj.ptCord + 60*obj.ptSliceNorm);
        
        end
        
        
        function obj = calcNormalBuiltIn(obj, startPoint, endPoint)  
        obj.ptSurfaceNorm = obj.ptSurfaceNorm/norm(obj.ptSurfaceNorm);
        sutureVect = findSutureVect(startPoint, endPoint);
        obj.ptSliceNorm = findSliceNorm(sutureVect, obj.ptSurfaceNorm);
        end
        
        
        function obj = calcNormal(obj, startPoint, endPoint)  
        obj.ptSurfaceNorm = zeros(size(obj.neighbourTrCords,1), 3);
        for i=1:size(obj.neighbourTrCords,1)
            triangleXData = obj.neighbourTrCords(i,:,1);
            triangleYData = obj.neighbourTrCords(i,:,2);
            triangleZData = obj.neighbourTrCords(i,:,3);

            [C, obj.ptSurfaceNorm(i,:)] = computeNormal(triangleXData, triangleYData, triangleZData, obj.volumeMidPoint);
        end
        
        obj.ptSurfaceNorm = sum(obj.ptSurfaceNorm);
        obj.ptSurfaceNorm = obj.ptSurfaceNorm/norm(obj.ptSurfaceNorm);
        
        sutureVect = findSutureVect(startPoint, endPoint);
        obj.ptSliceNorm = findSliceNorm(sutureVect, obj.ptSurfaceNorm);
        end
        
        
        function obj = colorPoint(obj, newColor)
        colorData = obj.skullPatch.FaceVertexCData;

        colorData(obj.neighbourTrRows,:) = repmat(newColor, size(obj.neighbourTrRows, 1), 1);
        
        set(obj.skullPatch, 'FaceVertexCData', colorData);
        end
        
        function obj = genSlicePlane(obj, radius)
            
            planeVect = [0 0 1];

            hold on;
            
            plane = surf(linspace(-radius,radius,2*radius+1),linspace(-radius,radius,2*radius+1),zeros(2*radius+1));

            %Find a vector perpendicular to the plane vector and perpendicular to the
            %desired normal
            %This will be the vector along which we'll rotate the surface
            rotationVect = cross(obj.ptSliceNorm, planeVect);
            rotationVect = rotationVect / norm(rotationVect);
            acosineVal = dot(obj.ptSliceNorm, planeVect)/(norm(obj.ptSliceNorm)*norm(planeVect));
            angleDeg = -acosd(acosineVal);

            %When the desired normal is the same as the plane normal
            rotationVect(isnan(rotationVect)) = 1e-12;

            rotate(plane, rotationVect, angleDeg, [0 0 0]);

            obj.slicePlaneX = get(plane, 'XData');
            obj.slicePlaneY = get(plane, 'YData');
            obj.slicePlaneZ = get(plane, 'ZData');
            
            obj.planeZMax = max(obj.slicePlaneZ(:)); 
            obj.planeZMin = min(obj.slicePlaneZ(:));

            delete(plane);
            hold off;
            
        end 
        
        
    end
end

