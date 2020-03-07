function IMSHOW_IMAGE_KALMAN( IMAGE , M , N , T )

global x
global color
global white
global black
    size_IMAGE = size(IMAGE);
    final_image=[];
    final_image = x;
    if color == white
        gray = 0;
    else
        gray=255;
    end
    
        for i = 2:size_IMAGE(1)
            
%                 pause
                final_image(round(IMAGE(i,M)) , round(IMAGE(i,N))) = gray;
                
            
            
        end

 
     

   

  figure(T)  %% eliminate random
  imshow(uint8(final_image ))
