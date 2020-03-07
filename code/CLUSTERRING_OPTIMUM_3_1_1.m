%%%-------------------------------------- clusterring -------------------------------------------------------%%

%                             source_cluster(clus,1) = CLASS_NUMBER;  %% class number
%                             source_cluster(clus,7) = r_4;  row of element of class 
%                             source_cluster(clus,8) = c_4;  coloumn of element of class 
%                             source_cluster(clus,9) = ANGLE_radian;
%                             source_cluster(clus,11) = fi;  angle
%%%-------------------------------------------------------------------------------------------------------------%%


function [ CLUSTER , SAMPLE_FOR_CLUSTER , FLAG_ANY_FIND_CLUSTERRING ,  test] =  CLUSTERRING_OPTIMUM_3_1_1 (SAMPLE , SAMPLE_EXT , CLUSTER , SAMPLE_FOR_CLUSTER , SAMPLE_TOTAL , X_BIG , ANGLE ,  TH_ANGLE , TH_DIS , CLASS_NUMBER , TH_ANGLE_FIRST , TH_DIS_FIRST )

s_clusterring = size(CLUSTER);
distance = 2;
clus=s_clusterring(1) + 1  ;         %% number of point after each move in path
first_clus = clus;

normal_distance=1;
dis=normal_distance;  %% distance that each sample point can be have
t=0;
FLAG_FIND_CLUSTERRING = 1;
FLAG_ANY_FIND_CLUSTERRING = 1;
source_cluster = CLUSTER;

source_cluster(clus,1)=CLASS_NUMBER;                          %% class number
source_cluster(clus,7)=X_BIG(1);                   %% conditiont of sample point in class
source_cluster(clus,8)=X_BIG(2);         %% conditiont of sample point in class
source_cluster(clus,9)=X_BIG(3);      %% conditiont of sample point in class
% source_cluster(clus,10)=X_BIG(4);       %% conditiont of sample point in class
% source_cluster(clus,11)=X_BIG(3)*180/pi
% ANGLE=source_cluster(clus,11);

first=clus; 
number_forward_cluster=clus;  %% end number in find point after each move in path
size_sample = size(SAMPLE);
size_total_sample = size( SAMPLE_TOTAL  );
% 
% SAMPLE_FOR_CLUSTER
% source_cluster
% clus

for i=1:size_total_sample(1)
    if (round(SAMPLE_TOTAL(i,7)) == round(source_cluster(clus,7)) ) &&  (round(SAMPLE_TOTAL(i,8)) == round(source_cluster(clus,8) ))
            eliminate_row = i;
            
                           source_cluster(clus,2) = SAMPLE_TOTAL(i,2);
                             source_cluster(clus,3) = SAMPLE_TOTAL(i,3);
                              source_cluster(clus,4) = SAMPLE_TOTAL(i,4);
                               source_cluster(clus,5) = SAMPLE_TOTAL(i,5);
                                source_cluster(clus,6) = SAMPLE_TOTAL(i,6);
                                 source_cluster(clus,10) = SAMPLE_TOTAL(i,10);
                                  source_cluster(clus,11) = SAMPLE_TOTAL(i,11);
                                   source_cluster(clus,12) = SAMPLE_TOTAL(i,12);
            break;
    end
end

for dis = 1.4 :TH_DIS_FIRST 
for fi = ANGLE - TH_ANGLE_FIRST : ANGLE + TH_ANGLE_FIRST
    
    r_4 =  X_BIG(1) - dis * sind ( fi );   
    c_4 =  X_BIG(2) + dis * cosd ( fi );
    
       for s=1:size_sample(1)  %% search between sampls
                    
                    flag_duplicate_clus = 0; 
                    
              
                    if ( round(SAMPLE(s,2)) == round(r_4) )  && ( round(SAMPLE(s,3)) == round(c_4) )  %% if sightly point exist on sample 
                        
                        
                        for s_c = 1:clus
                            if (round(r_4) == round(source_cluster(s_c,7)) )  && ( round(c_4) == round(source_cluster(s_c , 8 )) )
                                flag_duplicate_clus = 1;
                                break;
                            else
                                flag_duplicate_clus = 0;                                                    
                            end
                       end
                        
                        if  flag_duplicate_clus == 0 %% if point not duplicate 
                            
                            clus = clus+1;
                            source_cluster(clus,1) = CLASS_NUMBER;  %% class number
                             source_cluster(clus,7) = SAMPLE(s,2);
                            source_cluster(clus,8) = SAMPLE(s,3);
                            source_cluster(clus,9) = X_BIG(3);
                            source_cluster(clus,13) = X_BIG(3)*180/pi;
                            FLAG_FIND_CLUSTERRING = 0;
                            
                            %%%---------- extra data---------------------------------------------------%%%%%%%%%%%%%%
                            
                            source_cluster(clus,2) = SAMPLE_EXT(s,2);
                             source_cluster(clus,3) = SAMPLE_EXT(s,3);
                              source_cluster(clus,4) = SAMPLE_EXT(s,4);
                               source_cluster(clus,5) = SAMPLE_EXT(s,5);
                                source_cluster(clus,6) = SAMPLE_EXT(s,6);
                                 source_cluster(clus,10) = SAMPLE_EXT(s,10);
                                  source_cluster(clus,11) = SAMPLE_EXT(s,11);
                                   source_cluster(clus,12) = SAMPLE_EXT(s,12);

                           break;
                        end
                    end
       end
end
end  %% end of first search

        first = number_forward_cluster+1 ;
        number_forward_cluster = clus; 

while(distance ~= 0 )
    
    
     
    for m = first : number_forward_cluster  %% search between point of  new class
        
    for dis =1:TH_DIS   
        t=t+1;
        for fi = ANGLE - TH_ANGLE : ANGLE + TH_ANGLE  %% search around all of probably angle for put  sample in new class
%             dis
%             source_cluster(m,7)
%             dis * sind ( fi )
%             fi
             r_4 =  source_cluster(m,7) - dis * sind ( fi )   ;
             c_4 =  source_cluster(m,8) + dis * cosd ( fi );
%              pause
             ANGLE_radian =  ( fi * pi )/180 ;
%              dis;
%              fi;
            
            rr_4 =   round(r_4);
             cc_4 = round(c_4);
            
             test(t,1)=rr_4;
             test(t,2)=cc_4;

             
             
                for s=1:size_sample(1)  %% search between sampls
                    
                    flag_duplicate_clus = 0 ;
                    
                    rr_4 =   round(r_4);
                    cc_4 = round(c_4);
                    sss_1 =round(SAMPLE(s,2));
                    sss_2 = round(SAMPLE(s,3));
                    
                    if ( round(SAMPLE(s,2)) == round(r_4) )  && ( round(SAMPLE(s,3)) == round(c_4) )  %% if sightly point exist on sample 
                        
%                         r_4
%                         c_4
%                         CLASS_NUMBER
%                         pause
                        for s_c = 1:clus
                            if (round(r_4) == round(source_cluster(s_c,7)) )  && ( round(c_4) == round(source_cluster(s_c , 8 )) )
                                flag_duplicate_clus = 1;
%                                 pause
                                break;
                            else
                                flag_duplicate_clus = 0;                                                    
                            end
                        end
                       
                        
                        
                        if  flag_duplicate_clus == 0 %% if point not duplicate 
                            
%                             r_4
%                             c_4
%                             CLASS_NUMBER
%                             pause
                            clus = clus+1;
                            source_cluster(clus,1) = CLASS_NUMBER;  %% class number
                            source_cluster(clus,7) = SAMPLE(s,2);
                            source_cluster(clus,8) = SAMPLE(s,3);
                            source_cluster(clus,9) = ANGLE_radian;
                            source_cluster(clus,13) = fi;
                            FLAG_FIND_CLUSTERRING = 0;
                            FLAG_ANY_FIND_CLUSTERRING = 0;
                            
                            %%%---------- extra data---------------------------------------------------%%%%%%%%%%%%%%
                            
                            source_cluster(clus,2) = SAMPLE_EXT(s,2);
                             source_cluster(clus,3) = SAMPLE_EXT(s,3);
                              source_cluster(clus,4) = SAMPLE_EXT(s,4);
                               source_cluster(clus,5) = SAMPLE_EXT(s,5);
                                source_cluster(clus,6) = SAMPLE_EXT(s,6);
                                 source_cluster(clus,10) = SAMPLE_EXT(s,10);
                                  source_cluster(clus,11) = SAMPLE_EXT(s,11);
                                   source_cluster(clus,12) = SAMPLE_EXT(s,12)
%                                    pause
                            
                            
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            dis
                            fi
                            pause
                            
                            break;  %% break search
                            
                        end
                    end
                    
                end
        end
        
                if FLAG_FIND_CLUSTERRING == 0
                    FLAG_FIND_CLUSTERRING = 1;
                    break;
                end
                
    end
    end  %% end search 
    distance = clus - number_forward_cluster;
               
        
        first = number_forward_cluster+1; 
        number_forward_cluster = clus;
%         pause
        
            
        
end  %% end while



if FLAG_ANY_FIND_CLUSTERRING == 0
    CLUSTER = source_cluster;
%     pause
% else
%     SAMPLE_TOTAL(eliminate_row , : ) = [];
%     pause
end



