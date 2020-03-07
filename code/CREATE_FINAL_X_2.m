function  X_FINAL_TOTAL = CREATE_FINAL_X_2( SAMPLE_TOTAL )

global sample_t
 size_sample_t =size(SAMPLE_TOTAL);
 k=size_sample_t(1);
%  angle_sample = sample_t ( : , 4 ) * 180 / pi;
class_number = max(SAMPLE_TOTAL(:,1))
 
 
 for class = 1 : class_number
     class_number;
     particle_new_row = 0;
     particle_new_column = 0;
     ANGLE=0;
     flag_find_sample_in_class = 1;
     g=0;
        for i = 1 : k
            
            if ( SAMPLE_TOTAL(i,1) == class )
                
                g=g+1;
                class_sample(g , : ) = SAMPLE_TOTAL(i , :);
                flag_find_sample_in_class = 0;
                
            end
        end
            
        for i = 1 : g
                if (flag_find_sample_in_class == 0 )
     
                         particle_new_row=particle_new_row + (  class_sample(i,6) * class_sample(i,2));
                         particle_new_column=particle_new_column + (  class_sample(i,6) * class_sample(i,3));
                         ANGLE = ANGLE + (  class_sample(i,6) * class_sample(i,9));

                end
        end
        
        X_FINAL_TOTAL( class , 1 ) = class;
        X_FINAL_TOTAL( class , 2 ) = particle_new_row;
        X_FINAL_TOTAL( class , 3 ) = particle_new_column;
        X_FINAL_TOTAL( class , 4 ) = ANGLE;
        
 end

 
 
  
 

 
%  size_sample_t = size(sample_t);
%  f=1;
% for class = 1 : class_number
%     
%     for i = 1: size_sample_t(1)
%         
%         if sample_t( i , 1 ) == class
%             
%             sample_t( f : i , : ) = sample_t
%             f=i;
%             
%         end
%         
%     end
%     
% end
    
    


