%KALMAN DATA CREATOR
%11:06 AM SEPTEMBER 14TH 2016
%CURRENT VERSION ONLY USES DATA FROM THE FRAMES THAT HAVE TWO BOUNDING
%BOXES ONLY.

%CENTROID FORMAT >> [X1 Y1]
%                   [X2 Y2]
clc
clear all
load BLOB
counter = 1;
for i = 1:1:size(BLOB.CENTROID,2)
    centres = BLOB.CENTROID{i};
    if (size(centres,1)==2)
        Xs = centres(:,1);
        Xpos = find(Xs == max(Xs));
        Hind(counter,:) = centres(Xpos,:);
        Xpos = find(Xs == min(Xs));
        Front(counter,:) = centres(Xpos,:);
        counter = counter + 1;
        
    end
end

centre = [262,203];
vect = BLOB.CENTROID;
fun = @(a,b) (a-b).*(a-b);
for i=1:1:size(BLOB.CENTROID,2)
    mat = vect{i};
    sqr = bsxfun(fun,mat,centre);
end
