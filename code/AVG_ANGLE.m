function SAMPLE = AVG_ANGLE (SAMPLE , ANGLE_EACH_SAMPLE , AVG_ANGLE)

m = ANGLE_EACH_SAMPLE;
n = AVG_ANGLE;
class_number = max(SAMPLE(:,1));
size_SAMPLE = size(SAMPLE);
% SAMPLE(:,20)=[];
SAMPLE(:,20)=SAMPLE(:,m)*180/pi;

for j = 1:class_number
    
    k = 0;
    sum = 0;
    
    for i=1:size_SAMPLE(1)
        
        if ( SAMPLE(i,1) == j )
            
            sum = sum+SAMPLE(i,20);
            k=k+1;
            
        end
    end
    
    avg = sum/k;
    
    for i=1:size_SAMPLE(1)
       
        if ( SAMPLE(i,1) == j )
        
            SAMPLE(i,n) = avg*pi/180;
        end
    end
    
end
            
  SAMPLE(:,20)=[];  
    
    
    
    