function IMSHOW_IMAGE_3( IMAGE , M , N , G )

global x
class_number_old = max(IMAGE(:,G));
    size_IMAGE = size(IMAGE);
    final_image=[];
    final_image = x;
    gray=255;
    gray_change = 255 /class_number_old;
    for class = 1:class_number_old
        
        for i = 1:size_IMAGE(1)
            
            if(IMAGE(i,G)==class)
%                 final_image(round(IMAGE(i,M)) , round(IMAGE(i,N)))
%                 round(IMAGE(i,M))
%                 round(IMAGE(i,N))
%                 pause
                final_image(round(IMAGE(i,M)) , round(IMAGE(i,N))) = gray;
                
            end
            
        end
        gray=gray-gray_change;
        
    end
 
     

   

  figure(3)  %% eliminate random
  imshow(uint8(final_image ))
