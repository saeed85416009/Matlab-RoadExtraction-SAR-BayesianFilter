function [ ROAD_LINE , FLAG_FIND_LINE ] = AUTOMATIC_FIND_ADJANCENCY_LINE(FIRST_POINT , ROAD_POINT , MARGIN_WIDE ,  TH_SEARCH , TH_ANGLE  , TH_DIS )



global edge_point
global prob_point
global M
global N
    size_prob_point = size(prob_point);
    add = size_prob_point(1);
    add_remove = 0;
    Remove =[];
    FLAG_FIND_LINE = 1;
    
    road_points(1 , 1) = FIRST_POINT(1,1);
    road_points(1 , 2) = FIRST_POINT(1,2);
    road_points(1,3) =FIRST_POINT(1,3);
                                                
    r_priori = FIRST_POINT(1,1);
    c_priori = FIRST_POINT(1,2);
    angle = FIRST_POINT(1,3);
    wide = MARGIN_WIDE * FIRST_POINT(1,5);
        %%%%%%%%%% if find two point then we know  angle for search around first probably point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
            for Search = 1 : TH_SEARCH
                                
                for dis = 1 : TH_DIS
                    
                      flag_find_next_point=2;
                      for fi = angle +90 : -1 : angle - 90

                    
                            r_next =  round(r_priori - dis * sind ( fi ))   ; 
                            c_next =  round(c_priori + dis * cosd ( fi ))   ;          %% measurement cordinate point
                            
                            
                            
                            flag_duplicate_point = 1;
                            %%% out band %%%%%%%%%%%%%%%%%%%%%%%%%%%
                            if (r_next > M-10 ) ||(r_next <= 10 ) || (c_next > N-10 ) ||(c_next <= 10 )
                                flag_duplicate_point = 0;
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            %%%% repeat check in road line step one %%%%%%%%%%%%
                            size_road_points = size(ROAD_POINT);
                            for s_r = 1 : size_road_points(1)
                                if ( round(r_next) == round(ROAD_POINT(s_r,1) ) ) &&  ( round(c_next) == round(ROAD_POINT(s_r,2) ) )
                                    flag_duplicate_point = 0;
                                end
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            %%% repeat check in road line step two %%%%%%%%%%%%%%%%%
                            size_road_points = size(road_points);
                            for s_r = 1 : size_road_points(1)
                                if ( round(r_next) == round(road_points(s_r,1) ) ) &&  ( round(c_next) == round(road_points(s_r,2) ) )
                                    flag_duplicate_point = 0;
                                end
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
                            
                            if flag_duplicate_point == 1
                                
                                        if  (edge_point(round(r_next) , round(c_next) ) ) > 0

                                              d(1) = r_next;
                                              d(2) = c_next;
                                              e(1) = FIRST_POINT(1,1);
                                              e(2) = FIRST_POINT(1,2);
                                              angle_prob =ANGLE_FIND( d , e );
%                                               pause
                                 

                                              abs_angle = abs(angle  - angle_prob);
                                              while(abs(abs_angle) > 180)
                                                 if abs_angle >180
                                                     abs_angle = abs_angle - 360;
                                                 elseif abs(abs_angle)>180
                                                     abs_angle = 360 + abs_angle;
                                                 end
                                              end
%                                                       flag_find_any_point
%                                                      note='2'
%                                                       pause


                                               %%%% authentication wide of point %%%%%%%%%% 
                                                flag_good_wide = 1;
                                                 size_ROAD_POINT = size(ROAD_POINT);
                                                for s_r = 1 : size_ROAD_POINT(1)
                                                   diff(s_r) = sqrt( ((r_next - ROAD_POINT(s_r,1))^2) + ((c_next - ROAD_POINT(s_r,2))^2) );
                                                   
                                                        if diff(s_r) <= wide
                                                            flag_good_wide = 0;
                                                            break
                                                        end
                                                end
                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                               
                                              if (abs_angle <= TH_ANGLE) && ( flag_good_wide == 0)

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
                    road_points
                    note='this point is not on the road line'
                    flag_find_any_point = 1;
                    pause
                    break
                end
                    
            end %%% END OF SEARCH NEXT POINT
        
        
     
                if flag_find_next_point == 0
                    note='this point is on the road line'
                    FLAG_FIND_LINE = 0;
                    road_points
                    pause
                end


 if  FLAG_FIND_LINE == 0     
     
    ROAD_LINE = road_points;
 else
     
ROAD_LINE =[];
    
 end
















