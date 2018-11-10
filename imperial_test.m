function [] = imperial_test()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

box = string(10);
box(2) = 'A';
box(3) = 'C';
box(4) = 'E';
box(5) = 'P';
box(6) = 'I';
box(7) = 'G';
box(8) = 'T';
box(9) = 'A';
box(10) = 'G';


for j=1:9
        k = mod((j + 4), 8)
        box(j) = box(k+1);
end

box = box

end

