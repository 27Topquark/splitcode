%THIS PROGRAM EXTRACTS THE BOUNDARY FROM ANY GIVEN FRAME
%THIS IS CURRENTL MEANT TO WORK ONLY TO WORK ON ONE PAW AND ONE SIDE
%BOUNDARY AND CAN EXTRACT


%INCOMPLETE BACKGROUND EXTRACTION
%% 

clc
clear all
close all
load Cropcor

file_names_clip = dir('C:\Users\Abhinav Sharma\Documents\Carnegie Mellon Research\CMU Lab Research\2016\Split Belt Analysis\Computer Vision\Paw Tracking\August 3rd 2016\Movie Frames from ClippedMOV005');%for i=1:1:size(file_names_clip,1)
file_name = file_names_clip(593).name;
A = imread(file_name);
A_crop = imcrop(A,Cropcor);
% imcrop(A_crop)


%% 

for i=1:1:size(A,1)
    for j = 1:1:size(A,2)
        B = A(i,j,:);
        
        %For blue boundary detection
     
        if ( (B(1,1,3) > B(1,1,1) && B(1,1,3) > B(1,1,2)) && (B(1,1,1) < 100 && B(1,1,1) > 20) && (B(1,1,2) > 70 ...
                && B(1,1,2) < 130)   )
            A_delta(i,j,:) = uint8([255 255 255]);
        else
            A_delta(i,j,:)=uint8([0 0 0]);
        end
    end
    
end


A_delta_crop = imcrop(A_delta,Cropcor);
gray_thresh = graythresh(A_delta_crop);
A_delta_crop_bin = (im2bw(A_delta_crop,0.2));
A_delta_crop_gray = rgb2gray(A_delta_crop);


%% 

H = vision.BlobAnalysis;
H.ExcludeBorderBlobs = 0;
H.MinimumBlobArea = 1000;
H.LabelMatrixOutputPort = 1;

[AREA,CENTROID,BBOX,LABEL] = step(H,A_delta_crop_bin);
RGB = insertShape(A_delta_crop, 'rectangle', BBOX, 'LineWidth', 2);
imshow(RGB);
hold on
imshow(label2rgb(LABEL));

%% Boundary detection
%Boundary is calculated using the vidoe frame which had the best stable
%wheel boundary selected manually Frame 0589.png

[B,L] = bwboundaries(A_delta_crop_bin,'noholes');

%Selecting the largest boundary components

for bound = 1:1:size(B,1)
    boundary_component(bound) = size(B{bound},1);
end
boundary_component = sort(boundary_component,'descend');
two_largest_components = boundary_component(1,1:2);

%Extracting the largest components 

%After overlaying with other images we dont require the second component 
bc = 1;
for bound = 1:1:size(B,1)
    if (size(B{bound},1)== two_largest_components(1) || size(B{bound},1)==two_largest_components(2))
    boundary_components{bc} = B{bound};
    bc = bc +1;
    end
end

%% 

quadpoints = zeros(two_largest_components(1)+two_largest_components(2),2);
quadpoints(1:two_largest_components(1),:) = boundary_components{1};
quadpoints(two_largest_components(1)+1:end,:) = boundary_components{2};

fitobject = fit(quadpoints(:,1),quadpoints(:,2),'poly2');

clearvars -except fitobject boundary_components
save boundary_components