

function INITIALIZE_PARIS_KALMAN ()

%% global

global x 
global edge_canny  
global match_wide
global M
global N 
global cluster 
global max_profile


%%% global firm value

 global dt                                      %% distance between point in first point
 global dtt
 global  r_optimum                        %% initialize row for priori estimate   (pixel)                    %%---**---%%
 global c_optimum                        %% initialize column for  priori estimate (pixel)                %%---**---%%
                                                                                        %%---**---%%
 global angle
 global angle_old
 global angle_optimum 
 global contrast_road                 %% firm value for road contrast in edge_canny state for moving in point ( gray level )
 global W
 global WMM                           %% Wide Margin for Matching  
 
 %%% for add
 
 %%%%%
 global gray_class 
 global B
 global min_wide_break_point
 global th_angle_break_point
 global min_number_of_branch_in_intersection
 global th_merge_angle_break
global th_max_angle_one_branch

%%%
global dt_right_road
global dt_curve_road
global r_opt
global c_opt
global W_P
global W1
global W2
global W3
global W4
global W5
global W6
global W7
global W8
global W9
global W10
global fo_optimum
global fo
global p_k_0
global p_1
global p_2
global p_3
global p_4
global m
global max_clasify_search
global max_wide_profile
global diff_profile
global size_profile
global source_profile
global pf
global M_P
global weight
global b_1
global b_2
global b_3
global b_4
global b_5
global b_6
global b_7
global b_8
global b_9
global sigma_fis
global max_canny
global contrast_match
global angle_change
global CSM
global CG
global SA 
global e_optimum
global error_margin
global C_optima
global var_mean_good
global var_mean_bad
global var_max_cluster
global edge_canny_wide
global T_angle
global th_car
global th_pixel_car
global th_first_dis_edge_car
global th_end_dis_edge_car
global th_angle_change
global max_gay_prof_car
global C_max_cluster
global e56
global rowpb
global columnpb
global fujitso



dt_right_road= sqrt (10);             %% distance between point in righ road when angle has soft change   %%---**---%%
dt_curve_road = sqrt(4);             %% distance between point in curve road when angle has big change   %%---**---%%

dt=dt_right_road;                        %% distance between point in first point
dtt=dt;

 r_optimum = 270 ;                       %% initialize row for priori estimate   (pixel)                    %%---**---%%
 c_optimum = 26;                         %% initialize column for  priori estimate (pixel)                %%---**---%%
 r_opt = r_optimum ;
c_opt = c_optimum ; 

 angle =45 ;                                                                                                %%---**---%%
 angle_old = angle;
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road
 
 W=16;                                         %% initialize road wide                 %%---**---%%
 W_P=W;
 W1=W_P; W2 = W_P; W3 = W_P; W4 = W_P;  W5 = W_P; W6 = W_P; W7 = W_P; W8 = W_P ; W9 = W_P; W10 = W_P;

 
 fo_optimum = 0.000001 ;
 fo = fo_optimum;                       %% initialize change in the road direction
 
 p_k_0 = 0.0001;                         %% initialize covariance matrice
 
 %%%%%%%%%%% initialize reference profile%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 p_1 =[ 53 54 49  ];        %% initialize reference profile                  %%---**---%%
 m=max(p_1);
max_profile = m+30;                       %%---**---%%    %% this point show when point out of road
 max_clasify_search = 150;
 max_wide_profile =200;
 diff_profile = 10;
 size_profile = 3;
 [ source_profile , pf ] = SOURCE_PROFILE_EXTENDED(r_optimum , c_optimum , angle , W  , max_profile , max_clasify_search , max_wide_profile , diff_profile , size_profile)



[yek , M_P ] =size(p_1) ;                        %% for check point
 weight = ones(1,M_P);
[p_1 ,p_2 , p_3 ,p_4] = CREATE_PROFILE ( p_1 , M_P );
%weight = [ 3 6 10 6 3 ];
 
 b_1 =  zeros(1,M_P );
 b_2 = b_1; b_3 = b_1 ; b_4 =b_1; b_5 = b_1 ; b_6 = b_1; b_7 = b_1; b_8 = b_1 ; b_9 = b_1;
 
 %%% regulator parameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 W=W;                                         %% initialize road wide
 sigma_fis = (1/88)^2;                %% variance af system noise
 contrast_match = max_profile;                %% firm value for cluster contrast (gray level )
 angle_change = 30;                   %% angle change for find best condidate ( degree )
 CSM = 1;                                   %% Cluster Similarity Modify ( regulation similarity between clusters )(less than this value is bad situation )  ( pixel )       %%---**---%%
 match_wide =( M_P - 1 ) / 2;    %% (wide of profile matching -1 ) / 2
 WMM = 5*W/4;                           %% Wide Margin for Matching
 CG = 200;                                  %% Cut Gradient
 contrast_road = 250;                  %% firm value for road contrast in edge_canny state for moving in point ( gray level )
 max_canny = contrast_road;       %% maximum gradian that my measurment point can be value
 SA = 450;                                   %% Stop Algorithm
 e_optimum = 0.1;                       %% maximum error in EKF                         %%---**---%%
 error_margin = 0.1;                     %% margin of error for research                    %%---**---%%
 C_optima = WMM;                          %% i assumed that my first wide of road is ...              
 var_mean_good = 500;               %% maximum variance that my condidate point profile can be have if all of ingredient of profile less than source profile    %%---**---%%
 var_mean_bad = 300;                  %% maximum variance that my condidate point profile can be have if few of ingredient of profile more than source profile   %%---**---%%
 var_max_cluster = 200;              %% maximmum variance that cluster can be have
 edge_canny_wide = W/10 ;        %% bad canny wide (canny minimmum wide  )    %%---**---%%
 T_angle = angle_change / 3;        %% if occure big change in angle compaire past angle ''and'' we detect bad canny wide remove condidate point ( Threshould_angle change )     %%---**---%%  
th_car = contrast_match ;            %% threshoul value for detect car in the road
th_pixel_car = 1;                           %% maximum lengh of car in the picture     %%---**---%%
th_first_dis_edge_car = 0 ;           %% distance from car to end of profle         %%---**---%%
th_end_dis_edge_car=M_P +2;
th_angle_change = 20;                 %% if angle change between measurement point and old point more than threshould we change distance between point and we change little   %%---**---%%
max_gay_prof_car = contrast_match;              %% maximum value for car_profile ( detect car in--- aa except car point < max_gay_prof_car ---) 
C_max_cluster = 4;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%% for check point
  e56=1;  
  rowpb = r_optimum;
  columnpb= c_optimum;
  fujitso = 1;
  cluster = 1;                                %% inialial cluster
 %%%%%%%%%%
  %% particle filter
 min_wide_break_point = 2*W;
 th_angle_break_point = 30;
 min_number_of_branch_in_intersection = 3;
  th_merge_angle_break = 10;
 th_max_angle_one_branch = 45;
 
 
 
 
 