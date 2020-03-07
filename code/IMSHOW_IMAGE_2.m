function IMSHOW_IMAGE_2( IMAGE , M , N,T )

global x
    size_IMAGE = size(IMAGE);
    final_image=[];
    final_image = x;
    gray=255;
        
        for i = 1:size_IMAGE(1)
            
%                 pause
                final_image(round(IMAGE(i,M)) , round(IMAGE(i,N))) = gray;
                
            
            
        end

 
     

   

  figure(T)  %% eliminate random
  imshow(uint8(final_image ))
