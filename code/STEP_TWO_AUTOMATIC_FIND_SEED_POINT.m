function [ADJACENCY_ROAD_LINE , final_adjacency_first_point ,  flag_find_adjacency] =  STEP_TWO_AUTOMATIC_FIND_SEED_POINT (ROAD_LINE , MAX_WIDE , COFF_WIDE ,MIN_FIRST_MOVE , TH_SEARCH_AT , TH_ANGLE_AT , TH_DIS_FIRST_AT , TH_DIS_AT  )

global prob_point
global prob_adjacency_point
global contrast_road
contrast_road =250;

ROAD_LINE
pause
   angle_road_line = median(ROAD_LINE(:,3));
   size_road_line = size(ROAD_LINE);
   prob_first_point =[];
   adjacency_f_p =[];
   ADJACENCY_ROAD_LINE =[];
   final_adjacency_first_point = [];
   flag_find_adjacency = 1;
   
   for fi = angle_road_line + 90 : -1 : angle_road_line - 90 
       
       %%%% margin angle %%%%%%%%%%%%%%
       L_angle = angle_road_line - TH_ANGLE_AT;
        while(abs(L_angle) >= 180)
             if L_angle >=180
                 L_angle = L_angle - 360;
             elseif abs(L_angle)>=180
                 L_angle = 360 + L_angle;
             end
        end
        
        H_angle = angle_road_line + TH_ANGLE_AT;
        while(abs(H_angle) >= 180)
             if H_angle >=180
                 H_angle = H_angle - 360;
             elseif abs(H_angle)>=180
                 H_angle = 360 + H_angle;
             end
        end
         %%%%%%%%%%%%%%%%%%%%%%%%
%          L_angle
%          H_angle
%          pause
       if (fi < L_angle ) || (fi > H_angle )
          
%            note='gcgggggggggggggggggggggggggggggggggggggggggggg'
%           fi
%           pause
        [adjacency_first_point , edge_canny_wide , flag_false_adjacency ]  = MOVE_AUTOMATIC ( ROAD_LINE(1,1) ,ROAD_LINE(1,2)  , fi , contrast_road ,  MAX_WIDE , MIN_FIRST_MOVE);

        flag_repetitive_point = 1;
        if (numel (prob_first_point) ~= 0)
            for s_u = 1: add_first
                if (round(adjacency_first_point(1)) == round(prob_first_point(s_u , 1)))  &&  (round(adjacency_first_point(2)) == round(prob_first_point(s_u , 2) ))

                    flag_repetitive_point = 0;
                    break;

                end
            end
        end

        
        for s_u = 1: size_road_line(1)
            if (round(adjacency_first_point(1)) == round(ROAD_LINE(s_u , 1)))  &&  (round(adjacency_first_point(2)) == round(ROAD_LINE(s_u , 2) ))
                
                flag_repetitive_point = 0;
                break;
                
            end
        end
        
        if (flag_repetitive_point ==1)  && ( flag_false_adjacency == 1 ) 
           
            size_adjacency_f = size(adjacency_f_p);
            add_first = size_adjacency_f(1) +1;
            adjacency_f_p(add_first,1) = adjacency_first_point(1);
            adjacency_f_p(add_first,2) = adjacency_first_point(2);
            adjacency_f_p(add_first,3) = angle_road_line;
            adjacency_f_p(add_first,4) = fi;
            adjacency_f_p(add_first,5) = edge_canny_wide;
%             note = ' find adjancacy point'
%             pause
            
        end
        
        size_prob_first = size(prob_first_point);
        add_first = size_prob_first(1) +1;
        prob_first_point(add_first , : ) = adjacency_first_point;
        
       end
   end
   prob_first_point
       adjacency_f_p
       
        size_adjacency = size(adjacency_f_p);
        adjacency= adjacency_f_p;
        first_point =[];
        j=0;
       while(size_adjacency ~=0)
           j=j+1;
       size_adjacency = size(adjacency);
       
       d=1000;
       for i = 1:size_adjacency(1)
           
           diff = adjacency(i,5);
                 if ( diff < d )
                    
                     d=diff;
                     choose_point = i;

                  end
           
       end
   
       first_point(j,:) = adjacency(choose_point , :);
       adjacency(choose_point,:)=[];
       size_adjacency = size(adjacency);
       end
       size_first_point = size(first_point);
       pause
   
       adjacency_road_line =[];
       flag_find_adjacency =1;
    for s_f = 1 :  size_first_point(1)
        
first_point
                [ adjacency_road_line , flag_find_adjacency ] = AUTOMATIC_FIND_ADJANCENCY_LINE(first_point(s_f,:) , ROAD_LINE , COFF_WIDE  , TH_SEARCH_AT , TH_ANGLE_AT , TH_DIS_AT );

                if flag_find_adjacency == 0
                    final_adjacency_first_point = first_point(s_f,:);
                    first_point
                    note='find total road'
                    pause
                    break
                end
    end

ADJACENCY_ROAD_LINE = adjacency_road_line;






