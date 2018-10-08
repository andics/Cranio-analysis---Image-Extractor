function setDisplaySettings(V)

[xDim, yDim] = getXYLim(V);

gcf;


axis ij
axis tight
grid on;
xlim(xDim)
ylim(yDim)
daspect([1,1,2])
rotate3d on;
colormap('gray');

camlight(00,10)                                % create two lights
camlight(180,10)
lighting gouraud

end