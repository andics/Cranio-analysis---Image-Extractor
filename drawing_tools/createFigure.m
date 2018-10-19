function [figHandle] = createFigure(title, passArgument)
%Create a figure with a certain title

str = sprintf(title, passArgument);
figHandle = figure("Name", str);

end

