function MERGE_CLUSTER_1_1(TH_ANGLE_MERGE_CLUSTER , X_BIG)

global sample_t
global class_number

size_cluster = size(sample_t);
k=1;

for i=2:size_cluster(1)
    
               difference =  abs( sample_t(i,16) - sample_t(i,16) );
                if difference > 180
                    difference = 360 - difference ;
                end
                

                if ( difference < TH_ANGLE_MERGE_CLUSTER )
        
               
        sample_t( i-1 , 1 ) =k;
        sample_t( i , 1 ) = k;
        
        S1=[ sample_t(i-1,10) , sample_t(i-1,11) , sample_t(i-1 , 16) ]
        S2=[ sample_t(i,10) , sample_t(i,11) , sample_t(i , 16) ]
        
        distance1 = sqrt( ((S1(1)-X_BIG(1))^2) + ((S1(2)-X_BIG(2))^2) )
        distance2 = sqrt( ((S2(1)-X_BIG(1))^2) + ((S2(2)-X_BIG(2))^2) )
        
        if distance1 <= distance2
            sample_t(i-1,10) = S1(1);
            sample_t(i-1,11) = S1(2);
            sample_t(i,10) = S1(1);
            sample_t(i,11) = S1(2) ;
%             sample_t(i-1,16) = S1(3);
%             sample_t(i,16) = S1(3);
        else
           sample_t(i-1,10) = S2(1);
            sample_t(i-1,11) = S2(2);
            sample_t(i,10) = S2(1);
            sample_t(i,11) = S2(2) ;
%             sample_t(i-1,16) = S2(3);
%             sample_t(i,16) = S2(3);
        end
            
    else
        k=k+1;
        
    end
%             sample_t(i-1,10) 
%            sample_t(i-1,11) 
%     pause
end



