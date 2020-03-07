function [ ANGLE_FIND_CLUSTERRING , sample_angle_find ] = ANGLE_FIND_CLUSTERRING_TIME_1( X_NEW , SAMPLE_FOR_CLUSTER , M , N  )

global th_angle_find
global th_dis_angle_find

Angle_New_Point = X_NEW(3)*180/pi;
size_SAMPLE_FOR_CLUSTER = size(SAMPLE_FOR_CLUSTER);
sample_angle_find=[];
k=0;
flag_find_point = 1;

for dis = 1 : th_dis_angle_find
    
    for angle = Angle_New_Point - th_angle_find : Angle_New_Point+ th_angle_find
        
             
             flag_duplicate = 0;
             r_4 =  X_NEW(1) - dis * sind ( angle )   ;
             c_4 =  X_NEW(2) + dis * cosd ( angle );
%              pause
             
                for i = 1 : size_SAMPLE_FOR_CLUSTER(1)
                       
%                         r_4
%                         SAMPLE_FOR_CLUSTER( i , M )
%                         c_4
%                         SAMPLE_FOR_CLUSTER( i , N )
%                         pause
                    
                    if ((round(r_4) == round(SAMPLE_FOR_CLUSTER( i , M )) ) && (round( c_4 )== round(SAMPLE_FOR_CLUSTER( i , N )) ))
                        
                         for s_c = 1:k
                            if (round(r_4) == round(sample_angle_find(s_c,2)) )  && ( round(c_4) == round(sample_angle_find(s_c , 3 )) )
                                flag_duplicate = 1;
                                break;
                            else
                                flag_duplicate = 0;                                                    
                            end
                       end
                        
                        if flag_duplicate == 0
                         k = k + 1;
                         sample_angle_find(k,2) = r_4;
                         sample_angle_find(k,3) = c_4;
%                         note='find'
%                         pause
                        sample_angle_find(k,1) = angle;
                        Angle_Find(k) = angle;
                        flag_find_point = 0;
                        end
                        
                    end
                end
    end
end

if  flag_find_point == 0
ANGLE_FIND_CLUSTERRING = median(Angle_Find)*pi/180;
else
    ANGLE_FIND_CLUSTERRING = X_NEW(3);
end









