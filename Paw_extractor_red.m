%% Preparing interface and clearing all variables
clc
clear all
close all
%% Initial frame processing

A = imread('Frame 0152.png');
A_decorr = decorrstretch(A);

%OLD CONTRAST ENHANCEMENT TECHNIQUES NOT USED AS OF OCTOBER 6TH 2016
%  A_contrast = imadjust(A,[.45 .15 .15; .5 .2 .2],[],1);
%  A_contrast = imadjust(A,[.3 .4 .45; .6 .7 .6],[],1); 
%  A_contrast = imadjust(A,[.2 .4 .45; .6 .7 .6],[],1); 
%  A_contrast = imadjust(A,[.15 .4 .45; .6 .7 .6],[],1); 

%---------------------THE WONDER FIGURES-----------------------------------
% A_contrast = imadjust(A,[.45 .15 .15; .5 .2 .2],[],1); at +0.3 or +0.7


%% Filtering via thresholding for channel values
%  Making dilation and erosion changes for blob detection

for i=1:1:size(A,1)
    for j = 1:1:size(A,2)
        B = A_decorr(i,j,:);
        %THRESHOLDING SECTION
        if(B(1,1,1) > 250 && B(1,1,2) < 2 && B(1,1,3)<150) %SET APPROPRIATE THRESHOLDS
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

%% Blob analysis using built-in MATLAB packages

H = vision.BlobAnalysis;
H.ExcludeBorderBlobs = 0;
H.MinimumBlobArea = 150;
H.LabelMatrixOutputPort = 1;
[AREA,CENTROID,BBOX,LABEL] = step(H,dilatedI);


%% Output
%  Check figure 2 get an idea about how well the stretching algorithm is
%  working for the current lighting conditions
%  Check figure 1 for bounding box outputs


RGB = insertShape(A, 'rectangle', BBOX, 'LineWidth', 2);
figure(1),imshow(RGB);
figure(2),imshow(A_decorr);


