function [ CLUSTER , test] =  CLUSTERRING_OPTIMUM (SAMPLE , TH_ANGLE , TH_DIS )

distance = 2;
clus=1;          %% number of point after each move in path
number_forward_cluster=1;  %% end number in find point after each move in path
first=1; 
normal_distance=1;
dis=normal_distance;  %% distance that each sample point can be have
t=0;

CLUSTER(1,1)=1;                          %% class number
CLUSTER(1,2)=SAMPLE(1,1);                   %% conditiont of sample point in class
CLUSTER(1,3)=SAMPLE(1,2);         %% conditiont of sample point in class
CLUSTER(1,4)=SAMPLE(1,3);      %% conditiont of sample point in class
CLUSTER(1,5)=SAMPLE(1,4);       %% conditiont of sample point in class
ANGLE = ( SAMPLE(1,3) * 180 )/ pi  
ANGLE = 230

while(distance ~= 0 )
    
    for dis =1:TH_DIS
    
    for m = first : number_forward_cluster  %% search between point of  new class
        
        for fi = ANGLE - TH_ANGLE : ANGLE + TH_ANGLE  %% search around all of probably angle for put  sample in new class
            dis
             r_4 =  CLUSTER(m,2) - dis * sind ( fi )   
             c_4 =  CLUSTER(m,3) + dis * cosd ( fi ) 
            rr_4 =   round(r_4);
             cc_4 = round(c_4);
             t=t+1;
             test(t,1)=rr_4;
             test(t,2)=cc_4;

             size_sample = size(SAMPLE);
             
                for s=1:size_sample(1)  %% search between sampls
                    flag_duplicate_clus = 0; 
                    rr_4 =   round(r_4);
                    cc_4 = round(c_4);
                    sss_1 =round(SAMPLE(s,1));
                    sss_2 = round(SAMPLE(s,2));
                    if ( round(SAMPLE(s,1)) == round(r_4) )  && ( round(SAMPLE(s,2)) == round(c_4) )  %% if sightly point exist on sample 
                        
                        
                        for s_c = 1:clus
                            if (round(r_4) == round(CLUSTER(s_c,2)) )  && ( round(c_4) == round(CLUSTER(s_c , 3 )) )
                                flag_duplicate_clus = 1;
                                break;
                            else
                                flag_duplicate_clus = 0;                                                    
                            end
                       end
                        
                        if  flag_duplicate_clus == 0 %% if point not duplicate 
                            
                            clus = clus+1
                            CLUSTER(clus,1) = 1;  %% class number
                            CLUSTER(clus,2) = r_4;
                            CLUSTER(clus,3) = c_4;
                            CLUSTER(clus,4) = SAMPLE(s,3);
                            CLUSTER(clus,5) = SAMPLE(s,4);
                            
                            break;  %% break search
                            
                        end
                    end
                end
        end
    end
    end  %% end search 
    distance = clus - number_forward_cluster
               
        clus
        first = number_forward_cluster+1 
        number_forward_cluster = clus
%         pause
        
            
        
end  %% end while



