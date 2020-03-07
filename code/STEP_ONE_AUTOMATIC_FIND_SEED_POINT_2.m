function [ ROAD_LINE , FLAG_FIND_LINE ] = STEP_ONE_AUTOMATIC_FIND_SEED_POINT_2(TH_SEARCH , TH_ANGLE , TH_DIS_FIRST , TH_DIS )



global edge_point
global prob_point
global M
global N

    size_prob_point = size(prob_point);
    add = size_prob_point(1);
    add_remove = 0;
    Remove =[];
    FLAG_FIND_LINE = 1;
for p_point = 1 : add
    
        road_points=[];   
        %%%%%%%%%% search for find next point of find first point for find angle for later %%%%%%%%%%%%%%%%%%  
        flag_find_any_point = 1; 
        
        for dis = 1.45 : TH_DIS_FIRST
            for fi = 180 : -1 : -180

                 r_prob =  round(prob_point(p_point , 1) - dis * sind ( fi )) ;   
                 c_prob =  round(prob_point(p_point , 2) + dis * cosd ( fi ));             %% measurement cordinate point
                 
                 if (edge_point(round(r_prob) , round(c_prob) ) ) > 0
                     
                     d(1) = r_prob;
                     d(2) = c_prob;
                     e(1) = prob_point(p_point , 1);
                     e(2) = prob_point(p_point , 2);
                     
                     angle =ANGLE_FIND( d , e );
                     flag_find_any_point =0;
                     
                     road_points(1,1) = prob_point(p_point , 1);
                     road_points(1,2) = prob_point(p_point , 2);
                     road_points(1,3) = angle;
                     road_points(2,1) = r_prob;
                     road_points(2,2) = c_prob;
                     road_points(2,3) = angle
                     pause
                     break;
                     
                 end
                 
                 
            end
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
                 if flag_find_any_point == 0
                     r_priori =  road_points(2,1);
                     c_priori = road_points(2,2);
                     break
                 end
               
        end %% end of find twice point
        
        
        %%%%%%%%%% if find two point then we know  angle for search around first probably point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if flag_find_any_point == 0
                        
            for Search = 1 : TH_SEARCH
                                
                for dis = 1 : TH_DIS
                    
                      flag_find_next_point=2;
                      for fi = 179 : -1 : -179

                    
                            r_next =  round(r_priori - dis * sind ( fi ))   ; 
                            c_next =  round(c_priori + dis * cosd ( fi ))   ;          %% measurement cordinate point
                            
                            size_road_points = size(road_points);
                            flag_duplicate_point = 1;
                            for s_r = 1 : size_road_points(1)
                                if ( round(r_next) == round(road_points(s_r,1) ) ) &&  ( round(c_next) == round(road_points(s_r,2) ) )
                                    flag_duplicate_point = 0;
                                end
                            end
                            
                            if ( round(r_next) > M-10 ) || ( round(r_next) < 10 ) || ( round(c_next) > N-10 ) || ( round(c_next) < 10 )
                                flag_duplicate_point = 0;
                            end
                                    
                            if flag_duplicate_point == 1
                                
                                        if  (edge_point(round(r_next) , round(c_next) ) ) > 0

                                              d(1) = r_next;
                                              d(2) = c_next;
                                              e(1) = prob_point(p_point , 1);
                                              e(2) = prob_point(p_point , 2);
                                              angle_prob =ANGLE_FIND( d , e );
%                                               pause
                                 

                                              abs_angle = abs(angle  - angle_prob);
                                              while(abs(abs_angle) >= 180)
                                                 if abs_angle >=180
                                                     abs_angle = abs_angle - 360;
                                                 elseif abs(abs_angle)>=180
                                                     abs_angle = 360 + abs_angle;
                                                 end
                                              end
%                                                       flag_find_any_point
%                                                      note='2'
%                                                       pause
                                              if abs_angle <= TH_ANGLE

                                                size_road_points = size(road_points);  
                                                add_road_points =size_road_points(1) +1;
                                                road_points(add_road_points , 1) = r_next;
                                                road_points(add_road_points , 2) = c_next;
                                                road_points(add_road_points,3) = angle_prob;
                                                r_priori = r_next;
                                                c_priori = c_next;
                                                flag_find_next_point = 0;
%                                                              flag_find_any_point
%                                                      note='2.1'
%                                                       pause
                                                break
                                            else
                                                flag_find_next_point = 1;
%                                                 break
                                              end
                                        end
                            end

                      end
%                                                     flag_find_any_point
%                                                     fi
%                                                      note='4'
%                                                      pause
                                          if flag_find_next_point < 2
                                              break
                                          end
                                          
%                                           if flag_find_next_point == 0
%                                               break
%                                           end
                      
                end
                
                if flag_find_next_point ~= 0
                    note='this point is not on the road line'
                    flag_find_any_point = 1;
                    pause
                    break
                end
                    
            end
        end
        
        add_remove = add_remove + 1;
        Remove(add_remove) = p_point; %%% remove checked point from probability points
        
                if flag_find_next_point == 0
                    note='this point is on the road line'
                    FLAG_FIND_LINE = 0;
                    road_points
                    pause
                    break
                end
end



road_points = REGULATE_ANGLE_180(road_points,3);
 if  FLAG_FIND_LINE == 0     
     
    prob_point(Remove,:) =[];
    ROAD_LINE = road_points;
 else
     note = ' Warning !!!! this program didnt work '
     note = ' there didnt find any line like road line !!'
     pause
     pause
     pause
     ERROR
    
 end
















