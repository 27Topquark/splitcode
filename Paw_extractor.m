clc
clear all
close all
A = imread('Frame 0124.png');

A_contrast = imadjust(A,[.45 .15 .15; .5 .2 .2],[],1);%GIVING GOOD POINTS

%  A_contrast = imadjust(A,[.3 .4 .45; .6 .7 .6],[],1); %GIVING GOOD CONTRAST
%  A_contrast = imadjust(A,[.2 .4 .45; .6 .7 .6],[],1); 
%   A_contrast = imadjust(A,[.15 .4 .45; .6 .7 .6],[],1); 

%---------------------THE WONDER FIGURES-----------------------------------
% A_contrast = imadjust(A,[.45 .15 .15; .5 .2 .2],[],1);

% figure(1), imshow(A_contrast);
% figure(2), imshow(A);
% figure(3), imshow(A(:,:,1));
% figure(4), imshow(A(:,:,2));
% figure(5), imshow(A(:,:,3));
% figure(6) , imshow(A_contrast(:,:,3));

%% 

%Filtering for feet extraction
for i=1:1:size(A,1)
    for j = 1:1:size(A,2)
        B = A_contrast(i,j,:);
        %Condition one for light or illuminted version, Condition two for
        %dark condition
        if(B(1,1,1) > 180 && B(1,1,2) < 3 && B(1,1,3)<50)
            A_delta(i,j,:) = uint8([255 255 255]);
        else
            A_delta(i,j,:)=uint8([0 0 0]);
        end
    end
    
end


A_delta_crop_bin = (im2bw(A_delta,0.1));
A_delta_crop_bin= bwareaopen(A_delta_crop_bin, 40);
A_delta_crop_gray = rgb2gray(A_delta);
% imshow(A_delta_crop_bin);
A_delta = im2bw(A_delta);

se = strel('sphere',5); %263 resolved with 5

dilatedI = imdilate(A_delta_crop_bin,se);

%% 

H = vision.BlobAnalysis;
H.ExcludeBorderBlobs = 0;
H.MinimumBlobArea = 150;
H.LabelMatrixOutputPort = 1;

[AREA,CENTROID,BBOX,LABEL] = step(H,dilatedI);%A_delta_crop_bin);


%% 


RGB = insertShape(A, 'rectangle', BBOX, 'LineWidth', 2);
figure(1),imshow(RGB);

figure(3),imshow(A_contrast);

% RGB2 = insertShape(A_crop,'circle',[CENTROID 8],'LineWidth',2);
% imshow(RGB2);

