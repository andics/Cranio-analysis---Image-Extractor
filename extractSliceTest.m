function [slice] = extractSliceTest()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

figure;
 load mri;
 D = squeeze(D);
 pt = [64 60 14];
 vec = [0 1 0];
 [slice, sliceInd,subX,subY,subZ] = extractSlice(D,pt(1),pt(2),pt(3),vec(1),vec(2),vec(3),64);
 surf(subX,subY,subZ,slice,'FaceColor','texturemap','EdgeColor','none');
 axis([1 130 1 130 1 40]);
 drawnow;

end

