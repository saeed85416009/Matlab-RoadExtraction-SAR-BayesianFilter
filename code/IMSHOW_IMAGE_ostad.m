function IMSHOW_IMAGE_ostad( IMAGE , M , N )

global image
global color
global white
global black
class_number_old = max(IMAGE(:,1));
    size_IMAGE = size(IMAGE);
    final_image=[];
    final_image = image;
    if color == white
        gray = 0;
    else
        gray=255;
    end
    gray_change = 255 /class_number_old;
    for class = 1:class_number_old
        
        for i = 1:size_IMAGE(1)
            
            if(IMAGE(i,1)==class)
%                 final_image(round(IMAGE(i,M)) , round(IMAGE(i,N)))
%                 round(IMAGE(i,M))
%                 round(IMAGE(i,N))
%                 pause
                final_image(round(IMAGE(i,M)) , round(IMAGE(i,N))) = gray;
                
            end
            
        end
        if color == white
            gray=gray+gray_change;
        else
            gray=gray-gray_change;
        end
        
    end
 
     

   

  figure(3)  %% eliminate random
  imshow(uint8(final_image ))
