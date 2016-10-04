%%Paw Extraction main program

%Functions required>> drawEllipse,Bsxfun

clc
clear all
close all

%% IMAGE PROCESSING SECTION

%Reading image
A = imread('Frame 0002.png'); %911

%Simple Contrast Enhancement

A_contrast = imadjust(A,[.05 .4 .45; .6 .7 .6],[],1);

%Filtering for red feet extraction

for i=1:1:size(A_contrast,1)
    for j = 1:1:size(A_contrast,2)
        B = A_contrast(i,j,:);
        
        if(B(1,1,1) >150  && B(1,1,2) < 3 && B(1,1,3)<50)
            A_delta(i,j,:) = uint8([255 255 255]);
        else
            A_delta(i,j,:)=uint8([0 0 0]);
        end
    end
    
end

%Converting for noise removal to binary

A_delta_bin_1 = (im2bw(A_delta,0.2));

%Clearing unwanted noise using image opening

A_delta_bin_2= bwareaopen(A_delta_bin_1, 50);

%Converting back to RGB uint8 for further ease matrix multiplication and
%operations

for i=1:1:size(A_delta_bin_2,1)
    
    for j = 1:1:size(A_delta_bin_2,2)
        
        B = A_delta_bin_2(i,j,:);
       
        if(B == 1)
            A_delta(i,j,:) = uint8([255 255 255]);
        else
            A_delta(i,j,:)=uint8([0 0 0]);
        end
    end
    
end

%% BASIC BLOB ANALYSIS
H = vision.BlobAnalysis;
H.ExcludeBorderBlobs = 0;
H.MinimumBlobArea = 0;
H.LabelMatrixOutputPort = 1;

[AREA,CENTROID,BBOX,LABEL] = step(H,A_delta_bin_2);


%% ELLIPSE CENTRE GENERATION

%Run centre generation only once during the processing of all video frames

%If one then >> drawEllipse

ellipse_centres = drawEllipse(A_delta);

%% WHITE PIXEL LOCATIONS

%Remeber x goes from 1 to 451 or whatever the size
%Y goes from 1 to 230

[col,row] = find(A_delta_bin_2);
 
blob_pixels(:,:) = [row col];

%% CALCULATING MANHATTAN DISTANCE BETWEEN WHITE PIXELS AND ELLIPSE CENTRES

%This section computes the distance of each white pixel with each ellipse
%centre

blob_ellipse_manhattan = Bsxfun(blob_pixels,ellipse_centres);

%% LEAST MANHATTAN CENTRE

 for i=1:1:size(blob_pixels,1)
    
   BLELM = blob_ellipse_manhattan(i,:,:);
   
   %Removing singleton dimension and transposing the matrix
   
    BLELM = squeeze(abs(BLELM));
    BLELM = BLELM';
    BLELM_SUM = sum(BLELM,2);
    
    %Selecting the smallest sum also selecting the first whichever comes in
    %the list first 
    BLELM_MIN = find(BLELM_SUM == min(BLELM_SUM),1);
    
    minelps_centre(i,:) = [ellipse_centres(BLELM_MIN,:) 20];
   
   
   
    
 end
 U = unique(minelps_centre,'rows');
 


 %% REDUCING NUMBER OF CIRCLES TO BEGIN OPTIMISATION

 centre_manhattan = Bsxfun(U(:,1:2),U(:,1:2));
 
  for i=1:1:size(U,1)
    
   CM = centre_manhattan(i,:,:);
   
   %Removing singleton dimension and transposing the matrix
   
    CM = squeeze(abs(CM));
    CM = CM';
    CM_SUM = sum(CM,2);
    zero_remove = find(CM_SUM==0);
    CM_SUM(zero_remove) = Inf;
    
    %Selecting the smallest sum also selecting the first whichever comes in
    %the list first 
    CM_MIN = find(CM_SUM == min(CM_SUM),1);
    
    min_centre(i,:) = [U(CM_MIN,1:2) 20];
    
   
  end
    U2 = unique(min_centre,'rows');

    %% FINDING POINTS OF INTERSECTION OF THE REDUCED CIRCLES
    
    %use circcirc function
    j=1;
    for i=1:1:size(U,1)
       [Xs Ys] = circcirc(U(i,1),U(i,2),U(i,3),min_centre(i,1),min_centre(i,2),...
            min_centre(i,3));
        intersection(j,:) = [Xs(1) Ys(1) 3] ;
        intersection(j+1,:) = [Xs(2) Ys(2) 3] ;
        j = j+2;
    end

    intersection = ceil(intersection);
    
    
    
    
    
    
    
 %% INSERTING ELLIPSES FOR VISUAL INSPECTION
 
 figure(1),imshow(A);
 figure(2),imshow(A_contrast);
 figure(3),imshow(A_delta);
%  
 A_ellipse = insertShape(A_delta,'circle',minelps_centre,'color','white');
 figure(4),imshow(A_ellipse);

 A_ellipse_2 = insertShape(A_delta,'circle',U,'color','white');
 figure(4),imshow(A_ellipse_2);
 
 A_ellipse_3 = insertShape(A_delta,'circle',U2,'color','white');
 figure(5),imshow(A_ellipse_3);
 
  A_ellipse_4 = insertShape(A_ellipse_3,'filledcircle',intersection,'color','yellow');
 figure(6),imshow(A_ellipse_4);

 figure(7),imshow(A_contrast(:,:,1));
 
 figure(8),imshow(insertShape(A_delta,'rectangle',BBOX,'color','yellow'));