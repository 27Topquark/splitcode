%%Paw Extraction main program

%Functions required>> drawEllipse,Bsxfun
% 
% clc
% clear all
% close all

%% IMAGE PROCESSING SECTION

%Reading image
A = imread('Frame 0002.png'); %911

%Simple Contrast Enhancement

A_contrast = imadjust(A,[.05 .4 .45; .6 .7 .6],[],1);

%% DATA MATRIX CREATION
 thresh = 0;
data = zeros(size(A_contrast,1),size(A_contrast,2),255);
data2 = zeros(size(A_contrast,1),size(A_contrast,2),255);
pnt = 1;
for x=1:1:size(A_contrast,1)
    for y = 1:1:size(A_contrast,2)
        B = A_contrast(x,y,:);
        
        if(B(1,1,1) > thresh && B(1,1,2) < 3 && B(1,1,3)<3)
            data(x,y,B(1,1,1)) = B(1,1,1);
            data2(x,y,B(1,1,1)) = 1;
            Xvec1(pnt) = x;
            Yvec1(pnt) = y;
            Zvec1(pnt) = B(1,1,1);
            pnt = pnt + 1;
        end
        
        
    end
end

%% EXPERIMENTAL

ref_matrix = 255*ones(230,451);

for i = 255:-1:1
    
    ref_matrix = ref_matrix - data(:,:,i);
    
end

%% CONVOLUTION


