function [mainPatch] = patchTest()
mainColor = [1 0 0];

vert = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
face = [1 2 6;5 2 3;7 6 3;4 8 7;4 1 5;8 1 2;3 4 5;6 7 8];

%Use one color for each face (An RGB triplet)
colorData = zeros(size(face,1), 3);

for i=1:size(colorData,1)
    colorData(i,:) = mainColor;
end 
figure;
axis ij
axis tight
grid on;
daspect([1,1,1])
rotate3d on;

mainPatch = patch('Faces',face,'Vertices',vert);
mainPatch.FaceAlpha = 1;
mainPatch.EdgeColor = 'b';
mainPatch.FaceColor = 'flat';
mainPatch.FaceVertexCData = colorData;

end

