function [X_NEW ,  FLAG_find_new_point , FI , test  ] =  FIND_SOURCE_POINT_FOR_NEW_CLUSTER ( REMAIN_SAMPLE , CLUSTER , X_BIG , TH_angle_new_point , MOVE , TH_forward_dis , TH_angle )

global test_number
test = [];
ANGLE = ( X_BIG(3) * 180 )/pi 
FLAG_find_new_point = 1;
X_NEW = [];
s_remain = size(REMAIN_SAMPLE);
s_cluster = size(CLUSTER);


for angle = ANGLE : MOVE : ANGLE + TH_angle_new_point
    
    for dis = 1 : TH_forward_dis
        
        
        for FI = angle - TH_angle : angle + TH_angle
            
            r_4 = X_BIG(1) - dis * sind( FI ) ;
            c_4 = X_BIG(2) + dis * cosd(FI);
                                  
            for i = 1 : s_remain(1)
                
                flag_duplicate_cluster = 0;
                
                if (( round(r_4) == round(REMAIN_SAMPLE(i,2) )) && ( round(c_4) == round(REMAIN_SAMPLE(i,3) ))) || (( ceil(r_4) == round(REMAIN_SAMPLE(i,2) )) && ( ceil(c_4) == round(REMAIN_SAMPLE(i,3) ))) ||(( floor(r_4) == round(REMAIN_SAMPLE(i,2) )) && ( floor(c_4) == round(REMAIN_SAMPLE(i,3) )))
                    
                    for j =1:s_cluster(1)
                        if ( round(r_4) == round(CLUSTER(j,2) )) && ( round(c_4) == round(CLUSTER(j,3) )) 
                            flag_duplicate_cluster = 1;
                            break;
                        end
                    end
                        
                        if  flag_duplicate_cluster == 0
                               
                                X_NEW(1) = r_4;
                                X_NEW(2) = c_4;
                                X_NEW(3) = (FI*pi)/180;
                                X_NEW(4) = 0 
                                FLAG_find_new_point = 0;
                                break;
                    
                        end
                   
                    test_number=test_number+1
                    test(test_number,:)=X_NEW;
                                        
                    
                    
                end
            end
                
                            if FLAG_find_new_point == 0
                                break;
                            end
        end
                    
                            if FLAG_find_new_point == 0
                                break;
                            end
                            
    end
    
                            if FLAG_find_new_point == 0
                                break;
                            end
end


