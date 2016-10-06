clc
clear all
close all

v = VideoWriter('Labelled_movie.mp4');
open(v);

file_names_clip = dir('C:\Users\Abhinav\Documents\Abhinav Sharma Projects\Carnegie Mellon\Movie Frames from Low_def_13');
for i=1:1:size(file_names_clip,1)
    file_name = file_names_clip(i).name;
      if (size(file_name,2)>5 && strcmp(file_name(1:7),'BBFrame'))
       
   
A = imread(file_name); %Frame 0019,0067

writeVideo(v,A);



      end
end