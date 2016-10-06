%Inserting actual output
%Insert Kalman predictions
%Insert classification labels

clc
clear all
close all
%load Kalman_smoothed_allframes
load Feet_position_allframes

%% Rearranging data for correct insertion
% nu_hind_allframes = nu_hind_allframes';
% nu_front_allframes = nu_front_allframes';

Hind_x = Hind(:,1);
Hind_y = Hind(:,2);
Front_x = Front(:,1);
Front_y = Front(:,2);
Hind = [Hind_x(Hind_x~=0), Hind_y(Hind_y~=0)];
Front = [Front_x(Front_x~=0), Front_y(Front_y~=0)];

%clearvars -except Hind nu_hind_allframes Front nu_front_allframes frame_state


%% 

%Counters for keeping track as indexing is highly variable
insert_front = 1;
insert_hind = 1;

file_names_clip = dir('C:\Users\Abhinav Sharma\Documents\Carnegie Mellon Research\CMU Lab Research\2016\Split Belt Analysis\Kalman Analysis\untitled folder GITTIS RED\Movie Frames from FILE0006_edit');

for i=1:1:size(file_names_clip,1)
    file_name = file_names_clip(i).name;
      if (size(file_name,2) == 14)
          if strcmp(file_name(1:5),'Frame')
              frame = imread(file_name);
              frame_number = str2double(file_name(7:10));
              index_number = frame_number - 1; %due to indexing issues
              framestate = frame_state.tag(index_number);
              frame_name = strcat('Kalman ',file_name);
              
              switch framestate
                  
                  case 'F'
                      %inserting actual output
                      RGB = insertShape(frame, 'filledcircle',...
                          [Front(insert_front,:) 6], 'color', 'green');
                      %inserting Kalman output
%                       RGB = insertShape(RGB, 'filledcircle',...
%                           [nu_front_allframes(insert_front,:) 6], 'color', 'yellow');
                      %inserting classification annotation
                      RGB = insertObjectAnnotation(RGB,'circle',[Front(insert_front,:) 20],...
                          'Front Paw','LineWidth',2,'Color','white','TextColor','white');
                      
                      insert_front = insert_front + 1;
                      
                      
                      imwrite(RGB,frame_name);
                      
                      
                  case 'H'
                      
                       %inserting actual output
                      RGB = insertShape(frame, 'filledcircle',...
                          [Hind(insert_hind,:) 6], 'color', 'green');
                       %inserting Kalman output
%                       RGB = insertShape(RGB, 'filledcircle',...
%                           [nu_hind_allframes(insert_hind,:) 6], 'color', 'yellow');
                      %inserting classification annotation
                      RGB = insertObjectAnnotation(RGB,'circle',[Hind(insert_hind,:) 20],...
                          'Hind Paw','LineWidth',2,'Color','white','TextColor','white');
                      
                      insert_hind = insert_hind + 1;
                      
                      
                      imwrite(RGB,frame_name);
                      
                  case 'B'
                      %inserting actual output
                      RGB = insertShape(frame, 'filledcircle',...
                          [Front(insert_front,:) 6], 'color', 'green');
                      %inserting Kalman output
%                       RGB = insertShape(RGB, 'filledcircle',...
%                           [nu_front_allframes(insert_front,:) 6], 'color', 'yellow');
                      %inserting classification annotation
                      RGB = insertObjectAnnotation(RGB,'circle',[Front(insert_front,:) 20],...
                          'Front Paw','LineWidth',2,'Color','white','TextColor','white');
                      
                      
                      
                       %inserting actual output
                      RGB = insertShape(RGB, 'filledcircle',...
                          [Hind(insert_hind,:) 6], 'color', 'green');
                      %inserting Kalman output
%                       RGB = insertShape(RGB, 'filledcircle',...
%                           [nu_hind_allframes(insert_hind,:) 6], 'color', 'yellow');
                      %inserting classification annotation
                      RGB = insertObjectAnnotation(RGB,'circle',[Hind(insert_hind,:) 20],...
                          'Hind Paw','LineWidth',2,'Color','white','TextColor','white');
                      
                      insert_front = insert_front + 1;
                      insert_hind = insert_hind + 1;
                      
                      imwrite(RGB,frame_name);
                      
              end
              
              
          end

      end
end