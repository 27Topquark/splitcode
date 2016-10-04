
%KALMAN DATA CREATOR
%1:04 AM SEPTEMBER 22nd 2016
%DETECTS FRAME IN ALL POSSIBLE CONDITIONS AND BOUNDING BOXES 
%CURRENT VERSION ONLY USES DATA FROM THE FRAMES THAT HAVE TWO BOUNDING
%BOXES ONLY.


%CENTROID FORMAT >> [X1 Y1]
%                   [X2 Y2]
% frame_state.number = 1,2 or 3 >> 1 means single frame 2 means 2 and 3 means
% greater than 2
% frame_state.tag = 'F' for front 'H' and 'B' for front hind 
clc
clear all
load BLOB
make_global
%counter = 1; 
%mcount = 1;
first_frame_tag = 1 ;%one for front and 2 for hind required if both feet are not captured
%in the first frame


for i = 1:1:size(BLOB.CENTROID,2)
    centres = BLOB.CENTROID{i};
    size_of_centres = size(centres,1);
    
    if size_of_centres == 2
        areas = BLOB.AREA{i};
        small_area = areas(find(areas==min(areas)));
        if(small_area < 200)
            small_area = find(areas==min(areas));
            centres(small_area,:) = [];
            size_of_centres = size(centres,1);
        end
    end
    
    if ( size_of_centres ==2) 
        
        frame_state.number(i) = 2;
        frame_state.tag(i)  = 'B';
        
        Xs = centres(:,1);
        Xpos = find(Xs == max(Xs));
        Hind(i,:) = centres(Xpos,:);
        Xpos = find(Xs == min(Xs));
        Front(i,:) = centres(Xpos,:);
        
        
    elseif (size_of_centres > 2)
         framestate = frame_state.number(i-1);
                  init = 1;
                  j = i-init;
                  while (framestate ~= 2 && j > 0)
                      init = init + 1;
                      j = i - init;
                      framestate = frame_state.number(j);
                  end
                  if j>0
                  classify_frame(framestate,i,j,size(centres,1));
%                   else LETS BOTHER ABOUT THE ELSE LATER
                     
                  end
               
        
     
    %modifying to catch multiple bounding box frames
    multi_box_frame (i) = 1;
      
    elseif (size_of_centres == 1)
        frame_state.number(i) = 1;
        
        if ( i == 1)
            switch first_frame_tag
                case 1
                
                Front(i,:) = centres;
                frame_state.tag(i) = 'F';
                case 2
                    
                Hind(i,:) = centres;
                frame_state.tag(i) = 'H';
                    
            end
        else
          switch frame_state.number(i-1)
              
              case 1
                  if (strcmp('F',frame_state.tag(i-1)))
                      
                     delta_X = abs(Front(i-1,1) - centres(1,1));
                     if delta_X <= 15
                         Front(i,:) = centres;
                         frame_state.number(i) = 1;
                         frame_state.tag(i) = 'F';
                     else 
                       %either the foot has been lifted and put forward
                       if (abs(centres(1,1) - 1) < abs(Front(i-1,1) - 1))
                           Front(i,:) = centres;
                           frame_state.number(i) = 1;
                           frame_state.tag(i) = 'F';
                        %or the foot in this frame is not the front foot 
                        %this is an extreme case where we are assuming that
                        %in the previous frame there was only front foot
                        %and now suddenly this frame has a single bbox but
                        %with the hind foot. This issue can be solved for
                        %the front foot but is difficult to be resolved for
                        %the hind foot so we will omit this check for the
                        %hind foot
                       else 
                           Hind(i,:) = centres;
                           frame_state.number(i) = 1;
                           frame_state.tag(i) = 'H';
                       end
                     end
                     
                      
                  else
                      delta_X = abs(Hind(i-1,1) - centres(1,1));
                     if delta_X <= 15
                         Hind(i,:) = centres;
                         frame_state.number(i) = 1;
                         frame_state.tag(i) = 'H';
                     else 
                       %either the foot has been lifted and put forward
                       if (abs(centres(1,1) - 451) > abs(Hind(i-1,1) - 451))
                           Hind(i,:) = centres;
                           frame_state.number(i) = 1;
                           frame_state.tag(i) = 'H';
                        %or the foot in this frame is not the hind foot 
                        %We are omitting this kind of check for the hind
                        %foot.
%                        else 
%                            Hind(i,:) = centres;
%                            frame_state.number(i) = 1;
%                            frame_state.tag(i) = 'F';
                       end
                     end
                      
                  end
                  
              case 2
                 frame_state.number(i) = 1;
                 
                delta_Xfront = abs(centres(1,1) - Front(i-1,1)) ; 
                delta_Xhind = abs(centres(1,1) - Hind(i-1,1)) ;
                if (delta_Xfront > delta_Xhind)
                    Hind(i,:) = centres;
                    frame_state.tag(i) = 'H';
                else
                    Front(i,:) = centres;
                    frame_state.tag(i) = 'F';
                    
                end
                  
              case 3
                  framestate = frame_state.number(i-1);
                  init = 1;
                  j = i-init;
                  while (framestate > 2 && j > 0)
                      init = init + 1;
                      j = i - init;
                      framestate = frame_state.number(j);
                  end
                  if j>0
                  classify_frame(framestate,i,j,size(centres,1));
                  
                  end
                     
                  
          end
        end
        
        
    end
end
        
        

% centre = [262,203];
% vect = BLOB.CENTROID;
% fun = @(a,b) (a-b).*(a-b);
% for i=1:1:size(BLOB.CENTROID,2)
%     mat = vect{i};
%     sqr = bsxfun(fun,mat,centre);
% end

