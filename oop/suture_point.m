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
        skullPatch
        skullFig
        volumeMidPoint
    end
    
    methods
        function obj = suture_point
            %Initialize initial point properties
            obj.ptCord = zeros(1,3);
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
   
        function obj = drawNormal(obj)
           
        obj.ptSurfaceNorm = zeros(size(obj.neighbourTrCords,1), 3);

        for i=1:size(obj.neighbourTrCords,1)

            triangleXData = obj.neighbourTrCords(i,:,1);
            triangleYData = obj.neighbourTrCords(i,:,2);
            triangleZData = obj.neighbourTrCords(i,:,3);

            [C, obj.ptSurfaceNorm(i,:)] = computeNormal(triangleXData, triangleYData, triangleZData, obj.volumeMidPoint);

        end
        
        obj.ptSurfaceNorm = sum(obj.ptSurfaceNorm);
        obj.ptSurfaceNorm = obj.ptSurfaceNorm/norm(obj.ptSurfaceNorm);
        drawOnFig(obj.skullFig);
        obj.ptSurfaceNormObj = arrow3(obj.ptCord, obj.ptCord + 40*obj.ptSurfaceNorm);
        set(obj.ptSurfaceNormObj, 'Tag', 'Normal Vector');
        
        end
        
        function obj = colorPoint(obj)
        newColor = [0 0 1];
           
        colorData = obj.skullPatch.FaceVertexCData;

        for i=1:size(obj.neighbourTrRows,1)
        colorData(newCTriangles(i,1),:) = newColor;
        end

        set(obj.skullPatch, 'FaceVertexCData', colorData);
        end
    end
end

