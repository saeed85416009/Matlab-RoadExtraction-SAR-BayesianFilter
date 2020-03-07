function [ FLAG_EXCHANGE_PARTICLE , angle_break ] = FIND_BREAK_POINT_2 ( ROW_PARTICLE , COLOUMN_PARTICLE , ANGLE_OLD , GRAY_ELIMINATE_PARTICLE , WIDe , Error_Kalman , Iteration_intersection_particle , iteration_detour_particle)

global contrast_road
global min_wide_break_point
global th_merge_angle_break
global th_max_angle_one_branch
global th_angle_break_point
global min_number_of_branch_in_intersection
global intersection
global detour
global  flag_repetitive_place 


FLAG_EXCHANGE_PARTICLE =1;
k=0;
Angle = [0];
angle_find =[];
REMOVE =[];
for fi =  -180:180
    
        [edge_canny_wide_C , flag_unacceptive_sample ]  = DIFF_MOVE_BREAK_2 ( ROW_PARTICLE ,COLOUMN_PARTICLE  , fi , contrast_road ,  min_wide_break_point);
        
%         fi
%                 edge_canny_wide_C
            if  (edge_canny_wide_C >= min_wide_break_point/2 ) && (flag_unacceptive_sample ~= 1)
               
                
                k = k + 1;
                Angle(k) = fi;
                Wide(k) = edge_canny_wide_C;
                
            end
            
end

add = 1;
ANGLE(1)=Angle(1);
% WIDE(1)=Wide(1)
flag_intersect = 1;
angle_find_branch = 0;
% Angle
% k
% size(Angle)
% pause
for i = 2 : k
    
    %%% merge angle if distance between 2 continusely angle less than th_merge_angle_break
    abs_angle = abs( Angle(i-1) - Angle(i) );
    if abs_angle > 180
        abs_angle = 360 - abs_angle;
    end
    
    if abs_angle <= th_merge_angle_break
        
        add = add+1;
        ANGLE(add) = Angle(i);
%         WIDE(add) = Wide(i);

                                                                                                %%% if number of continuesly angle bigger than th_max_angle_one_branch there is happen intersection 
                                                                                                if add >= th_max_angle_one_branch
                                                                                                    ANGLE
                                                                                                    add
                                                                                                    min_wide_break_point
                                                                                                    flag_intersect = 0
                                                                                                    pause

                                                                                                end

                                                                                            %%% if distance between 2 continusely angle bigger than th_merge_angle_break there has one branch   
    else
%         ANGLE
        
        angle_find_branch = angle_find_branch +1;
        add = 1;
        angle_find(angle_find_branch) = min(ANGLE);
        ANGLE = [];
%         pause
%         wide(angle_find_branch) = min(WIDE);
        ANGLE(1) = Angle(i);
%         WIDE(1) = Wide(i);
        
    end
    
end
%         ANGLE
        
if add >1
        angle_find_branch = angle_find_branch +1;
        add = 1;
        angle_find(angle_find_branch) = min(ANGLE) ;
        ANGLE = [];
end
        
% Angle
Angle = ARRANGE_MATRIX_2(Angle);
% angle_find
% pause
size_angle_find = size(angle_find);
branch =1;

if size_angle_find(1)>0

    angle_break(1) = angle_find(1);
%     pause
    

    
 for i = 2:size_angle_find(2)
%      i

     abs_angle = abs(angle_find(i-1) - angle_find(i));
     if abs_angle >180
         abs_angle = 360 - abs_angle;
     end
     
     if abs_angle>= th_angle_break_point
         branch = branch+1;
          angle_break(branch) = angle_find(i);
%          pause
     end
     
 end
 
 %%% remove angle if near together
 while(1)
     
     size_angle_break = size(angle_break);
     flag_bad_angle = 1;
     for r = 1:size_angle_break(2)
         for p = 1:size_angle_break(2) 

                 abs_angle = abs(angle_break(r) - angle_break(p));
             if abs_angle >180
                 abs_angle = 360 - abs_angle;
             end

               if (abs_angle< th_angle_break_point) && (r ~= p )
                   
                   angle_break(r) =[];
                   flag_bad_angle = 0;
                   break

              end

         end
         
                    if flag_bad_angle == 0
                        break
                    end
     end
     
                    if flag_bad_angle == 0
                        continue
                    end
     break
 end %% end of while
  
%  if numel(REMOVE) ~= 0
%      angle_break(REMOVE)=[];
     size_angle_break = size(angle_break);
     branch = size_angle_break(2);
%  end
end
if (branch >= min_number_of_branch_in_intersection) || ( flag_intersect == 0 )
    
    
    angle_find
    angle_break
    ROW_PARTICLE
    COLOUMN_PARTICLE
    branch
    pause
    
    FUNCTION_PARTICLE_ostad( ROW_PARTICLE , COLOUMN_PARTICLE , ANGLE_OLD , GRAY_ELIMINATE_PARTICLE , WIDe , detour , 4 , Error_Kalman , Iteration_intersection_particle )
                                if flag_repetitive_place == 0
                                    FUNCTION_PARTICLE_ostad( ROW_PARTICLE , COLOUMN_PARTICLE , ANGLE_OLD , GRAY_ELIMINATE_PARTICLE , WIDe , detour , 2 , Error_Kalman ,  iteration_detour_particle )
                                end
                                
    
    %         angle_break
        FLAG_EXCHANGE_PARTICLE =0;
%         wide
        note = 'break_point'
%         pause

end


        


