clc
clear all
close all
load Cropcor
%FOR COUNTING EMPTY FRAMES
empt = 1;
%FOR STORING NON EMPTY CENTROID
nt_empt = 1;
file_names_clip = dir('C:\Users\Abhinav Sharma\Documents\Carnegie Mellon Research\CMU Lab Research\2016\Split Belt Analysis\Computer Vision\Paw Tracking\August 3rd 2016\Movie Frames from ClippedMOV005');
for i=1:1:size(file_names_clip,1)
    file_name = file_names_clip(i).name;
      if (size(file_name,2)>5 && strcmp(file_name(1:5),'Frame'))
       
   
A = imread(file_name); 
for k=1:1:size(A,1)
    for j = 1:1:size(A,2)
        B = A(k,j,:);
        %Condition one for light or illuminted version, Condition two for
        %dark condition
        if(((B(1,1,1)>130 && B(1,1,1)<190) && B(1,1,2)<60 && B(1,1,3) < 60) || ((B(1,1,1)>80 ...
                && B(1,1,1)<120) && B(1,1,2)<13 && B(1,1,3) < 13) || ((B(1,1,1)>115 ...
                && B(1,1,1)<155) && (B(1,1,2)<30 && B(1,1,2)> 13) && (B(1,1,3) >=19 && B(1,1,3)<=30)))
            A_delta(k,j,:) = uint8([255 255 255]);
        else
            A_delta(k,j,:)=uint8([0 0 0]);
        end
    end
    
end

A_crop = imcrop(A,Cropcor);
A_delta_crop = imcrop(A_delta,Cropcor);
gray_thresh = graythresh(A_delta_crop);
A_delta_crop_bin = (im2bw(A_delta_crop,0.6));
%A_delta_crop_gray = rgb2gray(A_delta_crop);

%% 

H = vision.BlobAnalysis;
H.ExcludeBorderBlobs = 0;
H.MinimumBlobArea = 30;
H.MaximumCount = 4;
H.LabelMatrixOutputPort = 1;

[AREA,CENTROID,BBOX,LABEL] = step(H,A_delta_crop_bin);



%% 
frame_name = strcat('D',file_name);

    if(isempty(BBOX))
        EMPTY_FRAMES{empt} = frame_name;
        empt = empt + 1;
    end
    
    if(~isempty(CENTROID))
        CNTRD{nt_empt} = CENTROID;
        nt_empt = nt_empt + 1;
    end

RGB = insertShape(A_crop, 'rectangle', BBOX, 'LineWidth', 2);


% imwrite(RGB,frame_name);

      end
end