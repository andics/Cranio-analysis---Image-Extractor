function [outputArg1,outputArg2] = setArrayProp(array, propList)
%Set a certain property of all objects in array

propList=num2cell(propList);
[array]=deal(propList{:}); 

end

