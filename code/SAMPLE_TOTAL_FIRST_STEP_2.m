function SAMPLE_TOTAL_FIRST_STEP_2(   )

global clusterring
global sample_t
global x_0

   global contrast_road
   global  WMM
   global th_angle_measurement
   global th_angle_measurement_intersection

sample_t=[];
size_cluster = size(clusterring);

for i=1:size_cluster(1)
    
    %%% class number
    sample_t( i , 1 ) = clusterring( i , 1 );
    
    %%% sample
    sample_t( i , 2 ) = clusterring( i , 2 );
    sample_t( i , 3 ) = clusterring( i , 3 );
    sample_t( i , 4 ) = clusterring( i , 4 );
    sample_t( i , 5 ) = clusterring( i , 5 );
    
    %%% weight
    sample_t( i , 6 ) = clusterring( i , 6 );
    
    %%% measurement
    sample_t( i , 7 ) = clusterring( i , 7 );
    sample_t( i , 8) = clusterring( i , 8 );
    sample_t( i , 9 ) = clusterring( i , 9 );
    
    %%% total class number
    sample_t(i , 13) = clusterring(i , 13); 
    
     %%% average angle
    sample_t(i , 14) = clusterring(i , 14); 

end

%% baiad taghir konad zamani k x kol ra sakhtim baiad barabare 3 parametr an shavad va x_total ham dar marahel digare proje barasas an tanzim shavad


class_number_old=max(sample_t(:,1));
% x_0
for class = 1 : class_number_old
    
    min_distance = 100;
    for  i = 1 : size_cluster(1)
        
        if clusterring(i , 1) == class
            
            distance = sqrt( ((x_0(1) - clusterring(i , 2))^2) + ( (( x_0(2) - clusterring(i , 3))^2) ) );
            
                if distance < min_distance
                    
                    min_distance = distance;
                    row_total = clusterring(i , 2);
                    coloumn_total = clusterring(i , 3);
                    zavie = clusterring(i , 14)*pi/180;
                    
                end
            
        end
        
    end
    
%     angle_sample_weight = zavie*180/pi;
% %     row_total
% %     coloumn_total
%     [row_total , coloumn_total ] = MEASUREMENT_PARTICLE(row_total , coloumn_total  , contrast_road , WMM , angle_sample_weight , th_angle_measurement , th_angle_measurement_intersection   );
% %     row_total
% %     coloumn_total                                                                                                                                                                                                                                                     
    
    for  i = 1 : size_cluster(1)
        
        if clusterring(i , 1) == class
     
                    
                    sample_t(i , 10) = row_total;
                    sample_t(i , 11) = coloumn_total;
                    sample_t(i , 12) = zavie;
                                        
              
            
        end
        
    end
    
end %%% end of searc


            
            




