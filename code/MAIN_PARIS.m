
%%
%%%%%%  create image and smooth that %%%%%%%%%%%%
clc;clear all;
global x 
global edge_canny  
global match_wide
global M
global N 
global cluster 
global max_profile

global clusterring 
global test_number
global class_number
global sample_t
global x_total
global remain_clusterring
global x_0

%%% global firm value

 global dt                                      %% distance between point in first point
 global dtt
 global  r_optimum                        %% initialize row for priori estimate   (pixel)                    %%---**---%%
 global c_optimum                        %% initialize column for  priori estimate (pixel)                %%---**---%%
 global particle_new_row 
 global particle_new_column 
 global angle_first_point                                                                                              %%---**---%%
 global angle
 global angle_old
 global angle_optimum 
 global contrast_road                 %% firm value for road contrast in edge_canny state for moving in point ( gray level )
 global W
 global WMM                           %% Wide Margin for Matching  
 global unaceptive_point
 global th_angle_particle_1 
 global th_angle_particle_2 
 global th_distance_clusterring
 global th_angle_new_point 
 global th_forward_dis
 global th_angle_merge_cluster 
 global th_angle_measurement 
 global th_angle_measurement_intersection 
 global th_angle_true_from_center 
 global th_eliminate_angle 
 global th_gray_eliminate
 global th_angle_find
 global th_dis_angle_find
 global th_angle_particle_first
 global th_angle_good_find
 global th_angle_particle_first_time
 %%% for add
 global th_angle_add 
 global th_gray_add 
 global min_sample_number 
 global min_dis_add 
 global max_dis_add 
 %%%%%
 global gray_class 
 global B
 global min_wide_break_point
 global th_angle_break_point
 global min_number_of_branch_in_intersection
 global th_merge_angle_break
global th_max_angle_one_branch
global gray_eliminate
global intersection
global detour
global memmory_point
%%%%%%%%%%%%%%%%%%%%%%%




memmory_point =[1 , 270 , 26 , 45];

while (numel (memmory_point ) ~= 0)
    
    a=memmory_point(1,2);
    b=memmory_point(1,3);
    c=memmory_point(1,4);
    FUNCTION_PARIS_KALMAN(memmory_point(1,2) , memmory_point(1,3) , memmory_point(1,4))
    
end












