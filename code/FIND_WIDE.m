function [ WIDE , angle ] = FIND_WIDE ( R_OPTIMUM , C_OPTIMUM , WIDE_OLD)

global contrast_road
global WMM
global WMM_high

min_distance = 100;

for fi = 1: 360
    
    [C , edge_canny_wide_C ]  = DIFF_PARTICLE_2 ( R_OPTIMUM ,C_OPTIMUM  , fi , contrast_road ,  WMM);
    
    if (edge_canny_wide_C < min_distance) && (edge_canny_wide_C >1)
        
        min_distance = edge_canny_wide_C;
        angle = 90 - fi;
        
    end
    
end

if min_distance < WMM_high
    WIDE = min_distance;
else
    WIDE = WIDE_OLD;
end

if WIDE <= 3
    note = ' wide is less than little wide'
    WIDE = WIDE_OLD;
%     pause
end


