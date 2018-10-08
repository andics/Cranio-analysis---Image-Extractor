function [] = createFigure(title, passArgument)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

str = sprintf(title, passArgument);
figure("Name", str);

end

