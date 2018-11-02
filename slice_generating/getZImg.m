function [imageName] = getZImg(zCord, assoc_list)
%Sometimes the chosen point has a non- integer Z cordinate
%Therefore, there is no corresponding image for the associated
%z-value in the assoc_list(it contains only whole z values).
%Here, we use interpolation to find the corresponding image at the
%particular Z value
if floor(zCord) == zCord
imageName  = assoc_list((assoc_list(:,1) == num2str(zCord)),2);
else
    zCordUp = ceil(zCord);
    zCordDown = floor(zCord);
    
    imageNameDown  = assoc_list((assoc_list(:,1) == num2str(zCordDown)),2);
    imageNameUp  = assoc_list((assoc_list(:,1) == num2str(zCordUp)),2);
    
    %Extract only the numbers from the names of the neighbouring images
    imageNumDown = str2double(regexp(imageNameDown,'\d*','Match'));
    imageNumUp = str2double(regexp(imageNameUp,'\d*','Match'));
    
    %Generate 1/scale_factor new indicies, between the neighbouring
    %indicies and find the closest to the actual zCord value
    newIndices = abs(imageNumDown - imageNumUp) + 1;
    matchZCord = linspace(zCordDown, zCordUp, newIndices);
    newIndices = linspace(imageNumDown, imageNumUp, newIndices);
    
    [val,idx]=min(abs(matchZCord-zCord));
    matchZImgNum=newIndices(idx);
    
    imageName = strrep(imageNameDown,num2str(imageNumDown),num2str(matchZImgNum));
    
end

end

