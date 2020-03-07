function PARTICLE_POINT = FIND_FINAL_POINT_PARTICLE ()

global sample_t
global x_0
size_sample_t = size(sample_t);
k = size_sample_t(1);
class_number = max(sample_t(:,1));

for class = 1 : class_number
    
    t=0;
    sample = [];
    for i = 1:k
        if sample_t(i,1) == class
            
            t=t+1;
            sample(t,:) = sample_t(i,:);
            
        end
    end
    
    max_distance = 0;
    
    for j = 1 : t
        
        distance = sqrt ( ( ((x_0(1) - sample(j,2)))^2 ) + ( ((x_0(2) - sample(j,3)))^2 ) );
        
        if distance > max_distance
            
            max_distance = distance;
            r_4 = sample(j,2);
            c_4 = sample(j,3);
            angle = sample(j,12)*180/pi;
            
        end
        
    end
    
    PARTICLE_POINT(class,1) = class;
    PARTICLE_POINT(class,2) = r_4;
    PARTICLE_POINT(class,3) = c_4;
    PARTICLE_POINT(class,4) = angle;
    
end %% end of search in all class


    
            








