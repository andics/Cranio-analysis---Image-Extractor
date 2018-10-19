function [] = cleanFig()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

toDie = findobj('Tag', 'Normal Vector');
delete(toDie)

toDie = findobj('Tag', 'Slice Surface');
delete(toDie)

toDie = findobj('Tag', 'Line');
delete(toDie)

end

