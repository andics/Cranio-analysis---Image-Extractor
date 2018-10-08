function [pPlane] = generatePlane()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

A = 3;
B = 10;
C = -1;
D = 30;

x = [1 -1 -1 1]; % Generate data for x vertices
y = [1 1 -1 -1]; % Generate data for y vertices
z = -1/C*(A*x + B*y + D); % Solve for z vertices data
pPlane = patch(x, y, z);

end

