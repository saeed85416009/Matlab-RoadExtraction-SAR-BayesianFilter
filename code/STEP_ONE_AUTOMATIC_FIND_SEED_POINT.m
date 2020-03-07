function STEP_ONE_AUTOMATIC_FIND_SEED_POINT(TH_SEARCH , TH_ANGLE , TH_DIS_FIRST , TH_DIS )



global edge_point
global L
global T


add = 0;
for i = L - 10 : -1 : 10
    for j = 10 : T - 10
        
        if edge_point(i,j) > 0
            
            add = add+1;
            prob_point(add,1) = i;
            prob_point(add,2) = j;
            
        end
    end
end
  
% while(1)
    flag_find_any_point = 1;
    
for p_point = 1 : add
    
        %%%%%%%%%% search for find next point of find first point for find angle for later %%%%%%%%%%%%%%%%%%  
        flag_find_any_point = 1; 
        Angle =[];
        add_angle = 0;
        class =0;
        Find_Angle=[];
        for dis = 1.45 : TH_DIS_FIRST
            for fi = 0:180

                 r_prob =  prob_point(p_point , 1) - dis * sind ( fi ) ;   
                 c_prob =  prob_point(p_point , 2) + dis * cosd ( fi );             %% measurement cordinate point
                 
                 if (edge_point(round(r_prob) , round(c_prob) ) ) > 0
                     
                      add_angle = add_angle +1;
                     Angle(add_angle) = fi;
                     flag_find_angle = 0;
                     flag_find_any_point = 0;  
                     
                 else
                     
                     flag_find_angle = 1;
                     
                 end
                 
                 if (flag_find_angle == 0)
                     continue
                 else
                     class = class+1;
                     min_angle = min(Angle);
                     max_angle = max(Angle);
                     size_angle =size(Angle);
                     avg_angle = ( min_angle + max_angle )/2;
                     
                     Find_Angle(class , 1) = size_angle;
                     Find_Angle(class , 2) = avg_angle;
                     Find_Angle(class , 3) = min_angle;
                     Find_Angle(class , 4) = max_angle;
                     
                     Angle =[];
                     add_angle = 0;
                     
                 end
                 
                 
            end
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
                 if flag_find_any_point == 0
                     break
                 end
               
        end %% end of find twice point
        
        
        %%%%%%%%%% if find two point then we know  angle for search around first probably point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if flag_find_any_point == 0
            
            [max_size_angle , place_max] = max(Find_Angle(: , 1));
            angle = Find_Angle(place_max , 2);
            
            for Search = 1 : TH_SEARCH
                
                for dis = 1.45 : TH_DIS

                      for fi = angle - TH_ANGLE :  angle + TH_ANGLE

                            r_next =  prob_point(p_point , 1) - dis * sind ( fi ) ;   
                            c_next =  prob_point(p_point , 2) + dis * cosd ( fi );             %% measurement cordinate point
                            if  (edge_point(round(r_next) , round(c_next) ) ) > 0



                            end

                      end
                end
            end
        end
end

                 


















