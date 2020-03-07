function SAMPLE = MEDIAN_ANGLE_2 (SAMPLE , ANGLE_EACH_SAMPLE , AVG_ANGLE , CLASS_POSITION)

m = ANGLE_EACH_SAMPLE;
n = AVG_ANGLE;
S = CLASS_POSITION;
class_number = max(SAMPLE(:,S));
size_SAMPLE = size(SAMPLE);
f=size_SAMPLE(2)+100;
% SAMPLE(:,20)=[];
M_SAMPLE = SAMPLE;
M_SAMPLE(:,f)=SAMPLE(:,m)*180/pi;

for j = 1:class_number
    
    k = 0;
    sum = 0;
    median_angle=[];
    
    for i=1:size_SAMPLE(1)
        
        if ( M_SAMPLE(i,S) == j )
            
            k=k+1;
            median_angle(k,1) = M_SAMPLE(i,f);
            
        end
    end
    
    avg = sum/k;
    
    for i=1:size_SAMPLE(1)
       
        if ( M_SAMPLE(i,S) == j )
        
            SAMPLE(i,n) = median(median_angle)*pi/180;
%             pause
        end
    end
    
end
            
%   SAMPLE(:,n+1:end)=[];  
    
    
    
    