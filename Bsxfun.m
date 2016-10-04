function [  blob_ellipse_manhattan ] = Bsxfun( pixels,ellipse_centres )
for i=1:1:size(ellipse_centres,1)
    BLOB(:,:,i) = pixels;
    ELLIPSE(:,:,i) = ellipse_centres(i,:);
end

blob_ellipse_manhattan = bsxfun(@minus,BLOB,ELLIPSE);

%squeeze command then transpose;