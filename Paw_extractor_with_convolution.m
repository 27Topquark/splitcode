%%Paw Extraction main program

%Functions required>> drawEllipse,Bsxfun

clc
clear all
close all

%% IMAGE PROCESSING SECTION

%Reading image
A = imread('Frame 0404.png'); %911

%Simple Contrast Enhancement

A_contrast = imadjust(A,[.05 .4 .45; .6 .7 .6],[],1);

%Filtering for red feet extraction

for i=1:1:size(A_contrast,1)
    for j = 1:1:size(A_contrast,2)
        B = A_contrast(i,j,:);
        
        if(B(1,1,1) > 180 && B(1,1,2) < 3 && B(1,1,3)<50)
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

%% 
