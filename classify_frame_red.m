
function [ ] = classify_frame_red( framestate,i,j,condition )
make_global
% INPUT ARGUMENTS
% frame_state - frame state number that tells whether the frame on the
% basis of which classification of the current frame has to take place has
% one bbox or two
%j - the i-kth frame which has been found such that it contains only either
%a single bounding box or two bboxes 
%condition - as this is a generic function that caters to two conditions 
%a) the one in which the current frame has only one bbox to classify
%b) the one in which the current frame has more than one bbox to classify
%that will require averaging
centres = BLOB.CENTROID{i};


switch condition
    
    
    
    case 1
        
        switch framestate
              
              case 1
                  if (strcmp('F',frame_state.tag(j)))
                      
                     delta_X = abs(Front(j,1) - centres(1,1));
                     if delta_X <= 50
                         Front(i,:) = centres;
                         frame_state.number(i) = 1;
                         frame_state.tag(i) = 'F';
                     else 
                         vec2 = bsxfun(@minus,[centre 0],[centres 0]);
                       %either the foot has been lifted and put forward
                       if (abs(centres(1,1) - 1) < abs(Front(j,1) - 1))
                           Front(i,:) = centres;
                           frame_state.number(i) = 1;
                           frame_state.tag(i) = 'F';
                         %for some outlier cases if the problem is not
                        %resolved using the above methods, just as a final
                        %check we would calculate the angle of the centroid
                        %with respect to the centre of the wheel
                       
                        
                       elseif ( acosd(dot(vec1,vec2)/(norm(vec1)*norm(vec2) )) < 95 )
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
                      delta_X = abs(Hind(j,1) - centres(1,1));
                     if delta_X <= 50
                         Hind(i,:) = centres;
                         frame_state.number(i) = 1;
                         frame_state.tag(i) = 'H';
                     else 
                       %either the foot has been lifted and put forward
                       if (abs(centres(1,1) - 451) > abs(Hind(j,1) - 451))
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
                 
                delta_Xfront = abs(centres(1,1) - Front(j,1)) ; 
                delta_Xhind = abs(centres(1,1) - Hind(j,1)) ;
                if (delta_Xfront > delta_Xhind)
                    Hind(i,:) = centres;
                    frame_state.tag(i) = 'H';
                else
                    Front(i,:) = centres;
                    frame_state.tag(i) = 'F';
                    
                end
        end
        
        
        
    otherwise
        front_counter = 1;
        hind_counter = 1;
        for sz = 1:1:(size(centres,1))
            front_distance = abs((centres(sz,1)-Front(j,1)));
            hind_distance = abs((centres(sz,1)-Hind(j,1)));
            if(front_distance <= hind_distance)
                front_temp_points(front_counter,:) = centres(sz,:);
                front_counter = front_counter + 1;
            else 
                hind_temp_points(hind_counter,:) = centres(sz,:);
                hind_counter = hind_counter + 1;
             
            end
            
         end   
            
            if (front_counter>1)
                front_temp_points = mean(front_temp_points,1);
                Front(i,:) = front_temp_points;
            end
                
            if (hind_counter > 1)
                hind_temp_points = mean(hind_temp_points,1);
                Hind(i,:) = hind_temp_points;
            end
            
            if (hind_counter > 1 && front_counter > 1)
                frame_state.number(i) = 2;
                frame_state.tag(i) = 'B';
            end   
             
            if (hind_counter > 1 && front_counter == 1)
                frame_state.number(i) = 1;
                frame_state.tag(i) = 'H';
            end
            
             if (hind_counter == 1 && front_counter > 1)
                frame_state.number(i) = 1;
                frame_state.tag(i) = 'F';
            end   
            
            
        
        
        
        
        

end
