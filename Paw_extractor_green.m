clc
clear all
close all
A = imread('Frame 0666.png');

A_contrast = imadjust(A,[.45 .15 .15; .5 .2 .2],[],1);%GIVING GOOD POINTS
A_decorr = decorrstretch(A);


%---------------------THE WONDER FIGURES-----------------------------------
% A_contrast = imadjust(A,[.45 .15 .15; .5 .2 .2],[],1); at +0.3 or +0.7

%% Filtering for feet extraction
for i=1:1:size(A,1)
    for j = 1:1:size(A,2)
        B = A_decorr(i,j,:);
        
        if(B(1,1,1) < 70 && B(1,1,2) > 150 && B(1,1,3)< 5)
            A_delta(i,j,:) = uint8([255 255 255]);
        else
            A_delta(i,j,:)=uint8([0 0 0]);
        end
    end
    
end


A_delta_crop_bin = (im2bw(A_delta,0.1));
A_delta_crop_bin= bwareaopen(A_delta_crop_bin, 40);
A_delta_crop_gray = rgb2gray(A_delta);
A_delta = im2bw(A_delta);

se = strel('sphere',5); 
dilatedI = imdilate(A_delta_crop_bin,se);

%% Blob analysis
H = vision.BlobAnalysis;
H.ExcludeBorderBlobs = 0;
H.MinimumBlobArea = 150;
H.LabelMatrixOutputPort = 1;
[AREA,CENTROID,BBOX,LABEL] = step(H,dilatedI);


%% Output
RGB = insertShape(A, 'rectangle', BBOX, 'LineWidth', 2);
figure(1),imshow(RGB);
figure(2),imshow(A_decorr);