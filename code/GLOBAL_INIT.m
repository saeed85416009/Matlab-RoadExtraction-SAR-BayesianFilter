
function GLOBAL_INIT (R_OPTIMMUM , C_OPTIMMUM , ANGLE , WIDE , TH_MAX_GRAY, D_STRAIGHT , D_CURVE ) 

%%%%%%  create image and smooth that %%%%%%%%%%%%
global x 
global edge_canny  
global match_wide
global M
global N 
global cluster 
global max_profile
WIde = WIDE; 
%%% global firm value

 global dt                                      %% distance between point in first point
 global dtt
 global  r_optimum                        %% initialize row for priori estimate   (pixel)                    %%---**---%%
 global c_optimum                        %% initialize column for  priori estimate (pixel)                %%---**---%%
 global angle
 global angle_old
 global angle_optimum 
 global contrast_road                 %% firm value for road contrast in edge_canny state for moving in point ( gray level )
 global W
 global WMM                           %% Wide Margin for Matching  
 global unaceptive_point
%%%%%%
 global min_wide_break_point
 global th_angle_break_point
 global min_number_of_branch_in_intersection
 global th_merge_angle_break
global th_max_angle_one_branch
global gray_eliminate
%%%%%%%%%%%%%%%%%%%%%%%
global p_1




 global particle_new_row 
 global particle_new_column 
 global angle_first_point                                                                                              %%---**---%%
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
 global th_dis_particle_first_time
 global th_max_dis_particle_first_time
 %%% for add
 global th_angle_add 
 global th_gray_add 
 global min_sample_number 
 global min_dis_add 
 global max_dis_add 
 %%%%%
 global gray_class 
 global B
 %%%%%
global intersection
global detour 
global th_angle_measurement_final_point
%%%%%%%%%%%%%%%%%%%%%%%
global result_project
global WMM_normal
global WMM_high
global WMM_very_high
global add_particle_to_kalman
global normal_change_angle
global margin_change_angle
global memmory_negative_point
global unaccepted_sample
global max_margin
global max_gray_total
global flag_big_wide
global flag_little_wide
global little_wide
global big_wide
global positive_position_kalman
global negative_position_kalman
global search_position_kalman
%%%%%% initialize road %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% kalman function
dt_right_road= sqrt (D_STRAIGHT);             %% distance between point in righ road when angle has soft change   %%---**---%%
dt_curve_road = sqrt(D_CURVE);             %% distance between point in curve road when angle has big change   %%---**---%%

dt=dt_right_road;                        %% distance between point in first point
dtt=dt;

 r_optimum = R_OPTIMMUM ;                       %% initialize row for priori estimate   (pixel)                    %%---**---%%
 c_optimum = C_OPTIMMUM;                         %% initialize column for  priori estimate (pixel)                %%---**---%%
 particle_new_row = r_optimum ;
particle_new_column = c_optimum ;  

 angle =ANGLE ;                                                                                                %%---**---%%
 angle_old = angle;
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road
 
 [ M , N ] = size(x);
result_project = [ r_optimum , c_optimum , angle , WIDE];

 
 W=WIDE;                                         %% initialize road wide                 %%---**---%%
                                       %%% initialize road wide

 contrast_road = 250;                  %% firm value for road contrast in edge_canny state for moving in point ( gray level )


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% particle filter
 min_wide_break_point = 4*W;
 th_angle_break_point = 40;
 min_number_of_branch_in_intersection = 3;
  th_merge_angle_break = 10;
 th_max_angle_one_branch = 70;
 gray_eliminate = TH_MAX_GRAY;
  max_profile = TH_MAX_GRAY + 20;
 %%% for check point
  cluster = 1;                                %% inialial cluster
%   unaceptive_point = [0 0];
  
  WMM_normal = 5*W/4;                           %% Wide Margin for Matching
  WMM_high = 9*W/4;                           %% Wide Margin for Matching
  WMM_very_high = 15*W/4;
  WMM = WMM_normal;
  add_particle_to_kalman =[];
  normal_change_angle = 30;
  margin_change_angle = 90;
  memmory_negative_point =[];
  unaccepted_sample = [];
  max_margin = 10;
 max_gray_total = TH_MAX_GRAY;
flag_big_wide = 1;
flag_little_wide = 1;
little_wide = 8;
big_wide = 30;
positive_position_kalman = 1;
negative_position_kalman = 2;
search_position_kalman = 3;
  %% particle function
  
   angle_first_point =ANGLE ;                                                                                                %%---**---%%

   th_angle_particle_1 = 5; %degree
 th_angle_particle_2 = 10; %degree  ( for firs step befor pass in while(time =..)
 th_distance_clusterring = 20;  %% distance ( use in clusterring only ) 
 th_angle_new_point = 90;  %%degree   ( use in find new point)
 th_forward_dis = 20;  %%distance  ( use in find new point)
 th_angle_merge_cluster = th_angle_particle_2 ;  %degree  ( use in merge clster)
 th_angle_measurement = th_angle_particle_1;  %% degree ( use in measurment )
 th_angle_measurement_intersection = 90;
 th_angle_true_from_center = 20;  %% not use anywhere
 th_eliminate_angle = 20;
 th_gray_eliminate = TH_MAX_GRAY;  %% eliminate point that put over of road
 th_angle_find = th_angle_measurement_intersection;
 %%% for create angle in x_new position
 th_dis_angle_find = 4;
 th_angle_particle_first = 45;
 th_dis_particle_first_time = 5;
 th_max_dis_particle_first_time = 2*th_dis_particle_first_time;
 th_angle_particle_first_time = th_angle_particle_first;
 th_angle_good_find = th_angle_particle_2;
  %%% for add
 th_angle_add = 10;  %% maximmum angle for add in class
 th_gray_add = th_gray_eliminate;  %% maximmum gray level for add in class
 min_sample_number = 10;  %% minimmum sample number for add sample step
 min_dis_add = 1.5;
 max_dis_add = 5; %% maximmum distance for add sample step
 %%%%%%%
 intersection = 1;
 detour = 2;
 %%%%%
 gray_class =255;
 B=1;
 test_number =0;
 th_angle_measurement_final_point = 20;
 
 
 
 
 
 
 
 
 
