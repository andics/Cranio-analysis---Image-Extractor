function [zMax] = findMaxZ(Img)
%Find the largest size of an image array from the dataset that can be
%currently loaded

volume = zeros(size(Img, 1), size(Img, 2), 1);
volume(:,:,1) = Img;
volumeBytes = whos('volume');
volumeBytes = volumeBytes.bytes;

info = memory;
info = info.MaxPossibleArrayBytes;

zMax = floor(info/volumeBytes) - 30;

end

