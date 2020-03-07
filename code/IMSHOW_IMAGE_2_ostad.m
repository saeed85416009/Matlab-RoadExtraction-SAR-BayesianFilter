function IMSHOW_IMAGE_2_ostad( IMAGE , M , N,T )

global x
global color
global white
global black
global image
    size_IMAGE = size(IMAGE);
    final_image=[];
    final_image = image;
    if color == white
        gray = 0;
    else
        gray=255;
    end
        
        for i = 1:size_IMAGE(1)
            
%                 pause
                final_image(round(IMAGE(i,M)) , round(IMAGE(i,N))) = gray;
                
            
            
        end

 
     

   

  figure(T)  %% eliminate random
  imshow(uint8(final_image ))
