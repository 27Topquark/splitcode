function [ ellipse_centres ] = drawEllipse(A_delta)

%% Ellipse centre generation and image creation for visualisation only can skip


% A_ellipse = insertShape(A_delta,'circle',[21 21 20],'color','white');

x = 21;

y = 21;
%Storing ellipse centres for calcuation of distances and everything later

ellipse_centres(1,:) = [x y];
cntr_count = 1;

while y < 230
    
   
    
    while x < 451
        
        x = x + 20;
        
        cntr_count = cntr_count + 1;
        
        ellipse_centres(cntr_count,:) = [x y];
        
%         A_ellipse = insertShape(A_ellipse,'circle',[x y 20],'color','white');
        
    
    end
    x = 0;
    y = y + 20;
end

%--------------END OF ELLIPSE CENTRE GENERATION------------------------
