clc
clear all
close all

load STAT_COMPLETE_BBLim0
f = 0;
ff = 0;
for i=1:1:(size(BLOB.AREA,2))
   
   Area = BLOB.AREA{i};
   Centroid = BLOB.CENTROID{i};
   Bbox = BLOB.BBOX{i};
   %SAME AREA AMBIGUITY , was a point of worry
   if(size(Area,1)>1)
      ff= ff + 1; 
   Area_sort = sort(Area,'descend');
   
   indx(1) = find(Area_sort(1) == Area);
   indx(2) = find(Area_sort(2) == Area);
  
   Bbox_sorted(1,:) = Bbox (indx(1),:);
   Bbox_sorted(2,:) = Bbox (indx(2),:);
   Centroid_sorted(1,:) = Centroid (indx(1),:);
   Centroid_sorted(2,:) = Centroid (indx(2),:);
 
   SORTED_STATS.Area_sort{i} = Area_sort(1:2,:);
   SORTED_STATS.Bbox_sort{i} = Bbox_sorted;
   SORTED_STATS.Centroid_sort{i} = Centroid_sorted;
   
   else
      f = f +1;
   SORTED_STATS.Area_sort{i} = Area;
   SORTED_STATS.Bbox_sort{i} = Bbox;
   SORTED_STATS.Centroid_sort{i} = Centroid;
    
   end

   
end