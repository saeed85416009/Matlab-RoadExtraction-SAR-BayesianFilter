function  CREATE_FIRST_SOURCE_POINT_2_1(X_BIG)

global sample_t
global x_total



x_total =[];

s_s = size(sample_t);


class_number_old = max(sample_t(:,1));
for class = 1 : class_number_old

    s=0; 
    sample=[];
    for i = 1 : s_s(1)
        
        if sample_t(i , 1) == class
            
            s=s+1;
            sample(s , 1) = sample_t(i , 7);
            sample(s , 2) = sample_t(i , 8);
            sample(s , 3) = sample_t(i , 4);
            
        end
    end
    
%     sample
%     pause
    angle_sum = 0;
    min_distance = 100;
    
    for i = 1 : s
        
        angle_sum = angle_sum +sample(i , 3);
        distance = sqrt( ((sample(i , 1) - X_BIG(1))^2) + ((sample(i , 2) - X_BIG(2))^2) );
        
        if distance < min_distance
            
            min_distance = distance;
            x_total(class , 1) = sample(i , 1);
            x_total(class , 2) = sample(i , 2);
            
        end
    end
    
    x_total(class , 3) = angle_sum / s
%     pause
     for i = 1 : s_s(1)
         
         if sample_t(i , 1) ==class
             
             sample_t(i , 10) = x_total(class , 1);
             sample_t(i , 11) = x_total(class , 2);
             sample_t(i , 12) = x_total(class , 3);
             
         end

    end
    
end

x_total ( : , 4 ) = 0;



        
        
    