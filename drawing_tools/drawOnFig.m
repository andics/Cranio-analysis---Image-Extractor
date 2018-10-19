function [] = drawOnFig(figureHandle)
%Set current figure to the desired to draw on figure and prepare it for
%being drawn on by setting hold to on

set(0, 'CurrentFigure', figureHandle);
hold on; 

end

