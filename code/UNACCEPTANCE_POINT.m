function UNACCEPTANCE_POINT( ANGLE , R_OPTIMUM , C_OPTIMUM ,Wide_Old )

global unaceptive_point
ANGLE = 180 + ANGLE;

Wide = FIND_WIDE ( R_OPTIMUM , C_OPTIMUM , Wide_Old );

size_unaceptive_point = size(unaceptive_point);
p = size_unaceptive_point(1);

for dis = 0 : Wide
    
    for fi = ANGLE - 90 : ANGLE +90
        
        r_4 = R_OPTIMUM - dis*sind(fi);
        c_4 = C_OPTIMUM + dis*cosd(fi);
        
        flag_duplicate_point = 1;
        
        for j = 1:p
            if ( round(r_4) == round(unaceptive_point(j,1)) ) && ( round(c_4) == round(unaceptive_point(j,2)) ) 
                
                flag_duplicate_point = 0;
                
            end
        end
        
        if (r_4 > 1) && (c_4 >1)
                if flag_duplicate_point ~= 0

                    p = p+1;
                    unaceptive_point(p,1)=r_4;
                    unaceptive_point(p,2)=c_4;

                end
        end
        
    end
    
end
        
        

