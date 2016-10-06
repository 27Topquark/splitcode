%Updated SEPTEMBER 13th 2016 10:24 PM
clc
clear all
close all

%Data Structures for saving relevant information
%Saving all the blob analysis output in Struct BLOB
BLOB_COUNTER = 1 ;
%CENTROID_MATRIX
CENTROID_COUNTER = 1 ;
%EMPTY_FRAMES
EMPTY_FRAMES_COUNTER = 1 ;
%BOUNDARY_CENTRE
BOUNDARY_CENTRE_COUNTER = 1;


file_names_clip = dir('C:\Users\Abhinav Sharma\Documents\Carnegie Mellon Research\CMU Lab Research\2016\Split Belt Analysis\Kalman Analysis\untitled folder GITTIS RED\Movie Frames from FILE0006_edit');
for I=1:1:size(file_names_clip,1)
    file_name = file_names_clip(I).name;
      if (size(file_name,2)>5 && strcmp(file_name(1:5),'Frame'))
          
          
          
%% Image Processing 1 Basic contrast enhancement and filtering      
   
%Simple Contrast Enhancement
A_feet = imread(file_name);
A_contrast = imadjust(A_feet,[.45 .15 .15; .5 .2 .2],[],1);
A_decorr = decorrstretch(A_feet);
%Filtering for feet extraction
for i=1:1:size(A_feet,1)
    for j = 1:1:size(A_feet,2)
        B = A_decorr(i,j,:);
        %Condition one for light or illuminted version, Condition two for
        %dark condition
        if(B(1,1,1) > 250 && B(1,1,2) < 3 && B(1,1,3)< 150)
            A_delta(i,j,:) = uint8([255 255 255]);
        else
            A_delta(i,j,:)=uint8([0 0 0]);
        end
    end
    
end


A_delta_bin = (im2bw(A_delta,0.1));
A_delta_bin= bwareaopen(A_delta_bin, 40);
se = strel('square',5);
A_dilated = imdilate(A_delta_bin,se);


%BOUNDARY DETECTION AND STUFF
% for i=1:1:size(A_feet,1)
%     for j = 1:1:size(A_feet,2)
%         B = A_contrast(i,j,:);
%         
%         %For circle centre detection
%      
%         if ( B(1,1,2) > 100 && B(1,1,1) > 200 && B(1,1,3) > 90)
%             Boundary_delta(i,j,:) = uint8([255 255 255]);
%         else
%             Boundary_delta(i,j,:)=uint8([0 0 0]);
%         end
%     end
%     
% end
% Boundary_delta_bin = (im2bw(Boundary_delta,0.2));
% Boundary_delta_bin= bwareaopen(Boundary_delta_bin, 50);

%% Image Processing 2 Blob analysis and connected components

%Processing for feet extraction--------------------------------------------
AH = vision.BlobAnalysis;
AH.ExcludeBorderBlobs = 0;
AH.MinimumBlobArea = 150;
AH.LabelMatrixOutputPort = 1;

[AREA,CENTROID,BBOX,LABEL] = step(AH,A_dilated);

%Struct for saving all outputs of the blob analysis
BLOB.AREA{BLOB_COUNTER} = AREA;
BLOB.CENTROID{BLOB_COUNTER} = CENTROID;
BLOB.BBOX{BLOB_COUNTER} = BBOX;
BLOB_COUNTER = BLOB_COUNTER + 1;
CIRCLE_CENTROID = [CENTROID 5*ones(size(CENTROID,1),1)];
%Let centroid be zero, get centroid for all the frames.
% CENTROID_MATRIX{CENTROID_COUNTER} = CENTROID;
% CENTROID_COUNTER = CENTROID_COUNTER + 1;

%Gives file name of the empty frames.
if (isempty(CENTROID))
    EMPTY_FRAMES{EMPTY_FRAMES_COUNTER} = file_name;
    EMPTY_FRAMES_COUNTER = EMPTY_FRAMES_COUNTER + 1;
end
%Feet extraction ends------------------------------------------------------

%Processing for circle centroid position-----------------------------------
% 
% bound_H = vision.BlobAnalysis;
% bound_H.MinimumBlobArea = 1000;
% 
% 
% [boundAREA,boundCENTROID,boundBBOX] = step(bound_H,Boundary_delta_bin);
% if (isempty(boundCENTROID))
%     return
% 
% else
% BOUNDARY_CENTRE{BOUNDARY_CENTRE_COUNTER} = boundCENTROID;
% BOUNDARY_CENTRE_COUNTER = BOUNDARY_CENTRE_COUNTER + 1;
% end
%Boundary centre extraction ends------------------------------------------------------

%% Writing Movie Frames

RGB = insertShape(A_feet, 'rectangle', BBOX, 'LineWidth', 2);
% RGB = insertShape(RGB, 'FilledCircle',CIRCLE_CENTROID, 'LineWidth', 5,'Color','black');
% RGB = insertShape(RGB, 'FilledCircle',CIRCLE_CENTROID, 'LineWidth', 5,'Color','black');
frame_name = strcat('BBFrame_Lim0',file_name);
imwrite(RGB,frame_name);


      end
end
