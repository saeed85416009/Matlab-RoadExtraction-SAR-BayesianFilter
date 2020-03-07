function [ CLUSTER , SAMPLE_FOR_CLUSTER , FLAG_FIND_CLUSTERRING ,  test] =  CLUSTERRING_OPTIMUM_2 (SAMPLE , CLUSTER , SAMPLE_FOR_CLUSTER , X_BIG , ANGLE ,  TH_ANGLE , TH_DIS , CLASS_NUMBER )

s_clusterring = size(CLUSTER);
distance = 2;
clus=s_clusterring(1) + 1 ;          %% number of point after each move in path
first_clus = clus;

normal_distance=1;
dis=normal_distance;  %% distance that each sample point can be have
t=0;
FLAG_FIND_CLUSTERRING = 1;
source_cluster = CLUSTER;

source_cluster(clus,1)=CLASS_NUMBER;                          %% class number
source_cluster(clus,2)=X_BIG(1);                   %% conditiont of sample point in class
source_cluster(clus,3)=X_BIG(2);         %% conditiont of sample point in class
source_cluster(clus,4)=X_BIG(3);      %% conditiont of sample point in class
source_cluster(clus,5)=X_BIG(4);       %% conditiont of sample point in class
source_cluster(clus,6)=X_BIG(3)*180/pi;
ANGLE=source_cluster(clus,6);


first=clus; 
number_forward_cluster=clus;  %% end number in find point after each move in path
size_sample = size(SAMPLE);
size_total_sample = size( SAMPLE_FOR_CLUSTER  );
% 
% SAMPLE_FOR_CLUSTER
% source_cluster
% clus

for i=1:size_total_sample(1)
    if (round(SAMPLE_FOR_CLUSTER(i,2)) == round(source_cluster(clus,2)) ) &&  (round(SAMPLE_FOR_CLUSTER(i,3)) == round(source_cluster(clus,3) ))
            eliminate_row = i;
            break;
    end
end


% d(1) = SAMPLE(1,2);
% d(2) = SAMPLE(1,3);
% e(1) = X_BIG(1);
% e(2) = X_BIG(2);
% ANGLE =ANGLE_FIND ( d , e );

while(distance ~= 0 )
    
    for dis =1:TH_DIS
    
    for m = first : number_forward_cluster  %% search between point of  new class
        
        for fi = ANGLE - TH_ANGLE : ANGLE + TH_ANGLE  %% search around all of probably angle for put  sample in new class
            
             r_4 =  source_cluster(m,2) - dis * sind ( fi );   
             c_4 =  source_cluster(m,3) + dis * cosd ( fi );
             ANGLE_radian =  ( fi * pi )/180 ;
%              dis;
%              fi;
            
            rr_4 =   round(r_4);
             cc_4 = round(c_4);
             t=t+1;
             test(t,1)=rr_4;
             test(t,2)=cc_4;

             
             
                for s=1:size_sample(1)  %% search between sampls
                    
                    flag_duplicate_clus = 0; 
                    
                    rr_4 =   round(r_4);
                    cc_4 = round(c_4);
                    sss_1 =round(SAMPLE(s,2));
                    sss_2 = round(SAMPLE(s,3));
                    
                    if ( round(SAMPLE(s,2)) == round(r_4) )  && ( round(SAMPLE(s,3)) == round(c_4) )  %% if sightly point exist on sample 
                        
                        
                        for s_c = 1:clus
                            if (round(r_4) == round(source_cluster(s_c,2)) )  && ( round(c_4) == round(source_cluster(s_c , 3 )) )
                                flag_duplicate_clus = 1;
                                break;
                            else
                                flag_duplicate_clus = 0;                                                    
                            end
                       end
                        
                        if  flag_duplicate_clus == 0 %% if point not duplicate 
                            
                            clus = clus+1;
                            source_cluster(clus,1) = CLASS_NUMBER;  %% class number
                            source_cluster(clus,2) = r_4;
                            source_cluster(clus,3) = c_4;
                            source_cluster(clus,4) = ANGLE_radian;
                            source_cluster(clus,5) = SAMPLE(s,5);
                            source_cluster(clus,6) = fi;
                            FLAG_FIND_CLUSTERRING = 0;
%                             dis
%                             fi
%                             pause
                            
                            break;  %% break search
                            
                        end
                    end
                end
        end
    end
    end  %% end search 
    distance = clus - number_forward_cluster;
               
        
        first = number_forward_cluster+1 ;
        number_forward_cluster = clus;
%         pause
        
            
        
end  %% end while



if FLAG_FIND_CLUSTERRING == 0
    CLUSTER = source_cluster;
else
    SAMPLE_FOR_CLUSTER(eliminate_row , : ) = [];
%     pause
end



