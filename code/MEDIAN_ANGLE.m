function SAMPLE = MEDIAN_ANGLE (SAMPLE , ANGLE_EACH_SAMPLE , AVG_ANGLE)

m = ANGLE_EACH_SAMPLE;
n = AVG_ANGLE;
class_number = max(SAMPLE(:,1));
size_SAMPLE = size(SAMPLE);
f=size_SAMPLE(2)+4;
M_SAMPLE = SAMPLE;
M_SAMPLE(:,f)=SAMPLE(:,m)*180/pi;

for j = 1:class_number
    
    k = 0;
    sum = 0;
    median_angle=[];
    
    for i=1:size_SAMPLE(1)
        
        if ( SAMPLE(i,1) == j )
            
            k=k+1;
            median_angle(k,1) = M_SAMPLE(i,f);
            
        end
    end
    
    avg = sum/k;
    
    for i=1:size_SAMPLE(1)
       
        if ( SAMPLE(i,1) == j )
        
            SAMPLE(i,n) = median(median_angle)*pi/180;
%             pause
        end
    end
    
end
            
%   SAMPLE(:,n+1:end)=[];  
    
    
    
    