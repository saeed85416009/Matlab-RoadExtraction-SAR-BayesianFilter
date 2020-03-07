function  FIND_BREAK_POINT ( ROW_PARTICLE , COLOUMN_PARTICLE )

global contrast_road
global min_wide_break_point
global th_angle_break_point
global min_number_of_branch_in_intersection
k=0;
Angle = [0];
for fi =  1 : 270
    
        [C , edge_canny_wide_C ]  = DIFF_PARTICLE ( ROW_PARTICLE ,COLOUMN_PARTICLE  , fi , contrast_road ,  min_wide_break_point);
        
        fi
                edge_canny_wide_C
            if  edge_canny_wide_C >= min_wide_break_point
               
                
                k = k + 1;
                Angle(k) = fi;
                Wide(k) = edge_canny_wide_C;
                
            end
            
end
Angle
Angle = ARRANGE_MATRIX_2(Angle)
branch = 1 ;
angle=[];
t=1;
wide =[];

if k>0
angle(t) = Angle(1)
wide(t) = Wide(1)
end

for i = 2 : k
    
    abs_angle = abs( Angle(i-1) - Angle(i)) ; 
    if abs_angle > 180
        abs_angle = 360 - abs_angle ;
    end
    if abs_angle >= th_angle_break_point
        
        t=t+1
        branch = branch + 1;
        angle(t) = Angle(i);
        wide(t) = Wide(i);
    end
    
end

branch
angle
wide

if branch >=  min_number_of_branch_in_intersection
    
%     PARTICLE_FILTER()
angle
wide
note = 'break_point'
pause
end

        


