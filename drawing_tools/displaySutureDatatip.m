function [] = displaySutureDatatip(cursor_data, skull_patch)
%Dispay the previouslt marked suture datatips on the provided skull

%Not finished
suture_points = round(genPts(cursor_data));
suture_points = suture_points(1,:)';
datatips = makedatatip(skull_patch, suture_points)

end

