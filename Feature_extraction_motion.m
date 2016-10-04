%% Main section with filters
clc
clear all
close all
load Cropcor
load boundary_components
file_names_clip = dir('C:\Users\Abhinav Sharma\Documents\Carnegie Mellon Research\CMU Lab Research\2016\Split Belt Analysis\Computer Vision\Paw Tracking\August 3rd 2016\Movie Frames from ClippedMOV005');%for i=1:1:size(file_names_clip,1)
    file_name = file_names_clip(5).name;
    %if (size(file_name,2)>5 && strcmp(file_name(1:5),'Frame'))
       
   
A = imread(file_name); %Frame 0019,0067

%FILTER ONE , TO REMOVE MAJORITY OF THE WHITE WHEEL PART

% for i=1:1:size(A,1) %for traversing Y of the image 1 to 230
%     for j = 1:1:size(A,2) %for traversing the X of the image 1 to 451
%         B = A(i,j,:);
%         if((B(1,1,1)>200 && B(1,1,2)> 200 && B(1,1,3) > 200) || (B(1,1,1)>200 && B(1,1,2)> 200 && B(1,1,3) > 150))
%             A_delta(i,j,:) = [0 0 0];
%         else
%             A_delta(i,j,:)=A(i,j,:);
%         end
%     end
%     
% end
% 
% for i=1:1:size(A_delta,1) %for traversing Y of the image 1 to 230
%     for j = 1:1:size(A_delta,2) %for traversing the X of the image 1 to 451
%         B = A_delta(i,j,:);
%         if((B(1,1,3)> B(1,1,1) && B(1,1,3) > B(1,1,2)))
%             A_delta(i,j,:) = [0 0 0];
%         end
%     end
%     
% end

for i=1:1:size(A,1)
    for j = 1:1:size(A,2)
        B = A(i,j,:);
        %Condition one for light or illuminted version, Condition two for
        %dark condition
        if(((B(1,1,1)>130 && B(1,1,1)<190) && B(1,1,2)<60 && B(1,1,3) < 60) || ((B(1,1,1)>80 ...
                && B(1,1,1)<120) && B(1,1,2)<13 && B(1,1,3) < 13) || ((B(1,1,1)>115 ...
                && B(1,1,1)<155) && (B(1,1,2)<30 && B(1,1,2)> 13) && (B(1,1,3) >=19 && B(1,1,3)<=30)))
            A_delta(i,j,:) = uint8([255 255 255]);
        else
            A_delta(i,j,:)=uint8([0 0 0]);
        end
    end
    
end

A_crop = imcrop(A,Cropcor);
A_delta_crop = imcrop(A_delta,Cropcor);
gray_thresh = graythresh(A_delta_crop);
A_delta_crop_bin = (im2bw(A_delta_crop,0.2));
A_delta_crop_gray = rgb2gray(A_delta_crop);

%% 

H = vision.BlobAnalysis;
H.ExcludeBorderBlobs = 0;
H.MinimumBlobArea = 30;
H.MaximumCount = 4;
H.LabelMatrixOutputPort = 1;

[AREA,CENTROID,BBOX,LABEL] = step(H,A_delta_crop_bin);


%% 


%RGB = insertShape(A_crop, 'rectangle', BBOX, 'LineWidth', 2);
%imshow(RGB);

% RGB2 = insertShape(A_crop,'circle',[CENTROID 8],'LineWidth',2);
% imshow(RGB2);

label = 1;
RGB3 = insertObjectAnnotation(A_crop,'circle',[CENTROID 8],label,'LineWidth',3,'Color','yellow','TextColor','black');
imshow(RGB3);
hold on
for bound = 1:length(boundary_components)
   boundary = boundary_components{bound};
   plot(boundary(:,2), boundary(:,1), 'k', 'LineWidth', 3)
end
plot(fitobject);






%% 

RGB2 = label2rgb(LABEL);
imshow(RGB2);



%% Display
hImage = subplot(3,2,1);
image(A);
hImage = subplot(3,2,2);
image(A_delta);
hImage = subplot(3,2,3);
image(A_crop);
hImage = subplot(3,2,4);
image(A_delta_crop);
hImage = subplot(3,2,5);
image(A_delta_crop_bin);
hImage = subplot(3,2,5);
image(uint8(A_delta_crop_bin));
hImage = subplot(3,2,6);
image(RGB);

%% Multithresh Methods
% A_delta_crop_gray = rgb2gray(A_delta_crop);
[thresh,metric]= multithresh(A_delta_crop_gray,3);
seg = imquantize(A_delta_crop_gray,thresh);
RGB3 = label2rgb(seg);
imshow(RGB3)



%% Higher Feature Extraction


   I = rgb2gray(A_delta_crop);
  imshow(I);  
  points = detectSURFFeatures(I);
 [f,p] = extractFeatures(I,points,'Method','SURF','SurfSize',128);
 imshow(A_delta_crop); hold on;
plot(points);
