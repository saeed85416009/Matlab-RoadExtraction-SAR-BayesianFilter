function [ REMAIN_C , FLAG_FINISH_REMAIN , CLASS_NUMBER ] = REMAIN_CLUSTERRING_2 ( SAMPLE , CLUSTERRING , CLASS_NUMBER )


FLAG_FINISH_REMAIN = 1;
remain_clus =0;

s_sample = size(SAMPLE);
s_class = size(CLUSTERRING);
for s_r_c = 1 : s_sample(1)
    
    flag_duplicate_remain = 0;
    
    
        for s_clusterring = 1: s_class (1)
        
            if (round(SAMPLE(s_r_c , 7)) == round(CLUSTERRING(s_clusterring , 7 )) )   
                
                if (round(SAMPLE(s_r_c , 8)) == round(CLUSTERRING(s_clusterring , 8 )) )
                    
                    flag_duplicate_remain = 1;
%                     break;
                    
                end
                
            end %% end if point exist between cluster               
         
        end %% end search between classes
        
        if flag_duplicate_remain == 0 
            
            remain_clus = remain_clus +1;
%             REMAIN_C(remain_clus , 1 ) = CLASS_NUMBER ;
            REMAIN_C(remain_clus , 1 ) = SAMPLE ( s_r_c , 1);
            REMAIN_C(remain_clus , 2 ) = SAMPLE ( s_r_c , 2);
            REMAIN_C(remain_clus , 3 ) = SAMPLE ( s_r_c , 3);
            REMAIN_C(remain_clus , 4 ) = SAMPLE ( s_r_c , 4);
            REMAIN_C(remain_clus , 5 ) = SAMPLE ( s_r_c , 5);
            REMAIN_C(remain_clus , 6 ) = SAMPLE ( s_r_c , 6);
            REMAIN_C(remain_clus , 7 ) = SAMPLE ( s_r_c , 7);
            REMAIN_C(remain_clus , 8 ) = SAMPLE ( s_r_c , 8);
            REMAIN_C(remain_clus , 9 ) = SAMPLE ( s_r_c , 9);
            REMAIN_C(remain_clus , 10 ) = SAMPLE ( s_r_c , 10);
            REMAIN_C(remain_clus , 11 ) = SAMPLE ( s_r_c , 11);
            REMAIN_C(remain_clus , 12 ) = SAMPLE ( s_r_c , 12);
            FLAG_FINISH_REMAIN = 0;
        end %% end create matrix with remain point that dont assign in any cluster
            
        
end

if FLAG_FINISH_REMAIN == 1
    REMAIN_C=[ 0 0 0 0 0 0 0 0 0 0 ];
end


