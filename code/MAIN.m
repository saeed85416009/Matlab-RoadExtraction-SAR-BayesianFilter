



%% ------------------------------------------- Segmentation road of SAR Image with Bayesian filter -----------------------------------------%%
%%%% use kalman filter for extract straight or curve road and when we reach to intersection  or cut road condition with
%%%% car or bad contrast situation then we switch to particle filter and also when we pass some step we change come back to
%%%% kalman filter and continue this process .
%%%% ----------------------------------------------------------------------------------------------------------------------------------------------------%%%%


%% Initialize Image and set global and seed point
clear all;
clc;
global x
global y
global memmory_point
global memmory_negative_point
global p_1
global Wide
global result_project
global unaceptive_point
global flag_find_any_negative_point
global positive_position_kalman
global negative_position_kalman
global white
global black
global color

flag_find_road_seed =0;

while ( flag_find_road_seed == 0 )

Max_Gray = 200;
 p_1 =[ 10 12 14  ];        %% initialize reference profile
                                                                                             %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
                                                                                             %%%!!! Warning : only chosse angle between -180 to 180  !!!%%%
white =1;
black = 0;
color = black;
%%% automatic seed
th_search_automatic = 50;
th_angle_automatic = 30;
th_dis_first_automatic = 4.2;
th_dis_automatic =2.9;
max_wide_automatic = 40;
coeff_wide_automatic =2;
%%%%
%IMAGE=imread  ( 'E:\internet\uni\proje\matlab\doc fin\docum\docu\comp\maq.bmp');    %%---**---%%
IMAGE=imread  ( 'E:\matlab\final project\final_3 without pause\image\maq11.png');    %%---**---%%

INITIALIZE_test (IMAGE , black )
% pause

 
   [ seed_point , flag_find_road_seed ] = AUTOMATIC_FIND_SEED_POINT(th_search_automatic , th_angle_automatic , th_dis_first_automatic , th_dis_automatic , max_wide_automatic , coeff_wide_automatic)
   pause
  %%%%%%%%%%%%%%%%%%%%%%%%% 
    Iteration_Intesection_Particle = 2;
 Iteration_detour_Particle = 1;
%%%%%

wide_init = 2*seed_point(1,4);
distance_straight_road = 10;
distance_curve_road = 4;

max_search_negative = 10;
%%%% test point %%%%%%%%
seed_point(1,1)=468;
seed_point(1,2)=444;
seed_point(1,3)=110;
seed_point(1,4)=20;
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
   memmory_point =[1 , seed_point(1,1) , seed_point(1,2) , seed_point(1,3);
                               0 , 0 , 0 , 0];
                                
   GLOBAL_INIT (memmory_point(1,2) , memmory_point(1,3) , memmory_point(1,4) , wide_init , Max_Gray , distance_straight_road , distance_curve_road  ) 
  
                          
  Wide  =  FIND_WIDE (memmory_point(1,2) , memmory_point(1,3) , wide_init);  
                                  IMSHOW_IMAGE_KALMAN_ostad(result_project , 1 , 2 , 4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_number_profile = 8*Wide * Wide;
diff_gray_profile = 10;
size_profile = 3;
source_profile = INITIALIZE_REFERENCE_PROFILE(Max_Gray , 2*Wide , max_number_profile , diff_gray_profile , size_profile )
pause
% source_profile = source_profile + 20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                                 result_project(1,1)= memmory_point(1,2);
                                 result_project(1,2)=memmory_point(1,3);
                                 result_project(1,3)=memmory_point(1,4);
                                 result_project(1,4)=Wide;

    

                                
flag_search_negative_first = 1;

while (numel (memmory_point ) ~= 0)
    
while (numel (memmory_point ) ~= 0)
    
    memmory_point
    pause
    
                                IMSHOW_IMAGE_KALMAN_ostad(result_project , 1 , 2 , 4)
                                IMSHOW_IMAGE_KALMAN_ostad(unaceptive_point , 1 , 2 , 5)
                                pause
    Wide  =  FIND_WIDE (memmory_point(1,2) , memmory_point(1,3), wide_init);  
     
   FUNCTION_KALMAN_3(memmory_point(1,2) , memmory_point(1,3) , memmory_point(1,4) ,  Wide , Max_Gray , distance_straight_road , distance_curve_road , source_profile , Iteration_Intesection_Particle , Iteration_detour_Particle , positive_position_kalman )
    
           if flag_search_negative_first == 1
                    [row , coloumn , angle , wide ] =  FUNCTION_KALMAN_SEARCH_NEGATIVE_3(result_project(1,1) , result_project(1,2) , result_project(1,3)-180 ,  Wide , Max_Gray , distance_straight_road , distance_curve_road , source_profile , max_search_negative);
             memmory_point(1,1) = 1;
             memmory_point(1,2) = row;
             memmory_point(1,3) = coloumn;
             memmory_point(1,4) = angle;
             pause
             if memmory_point(1,2)~=0
             FUNCTION_KALMAN_3(memmory_point(1,2) , memmory_point(1,3) , memmory_point(1,4) ,  Wide , Max_Gray , distance_straight_road , distance_curve_road , source_profile , Iteration_Intesection_Particle , Iteration_detour_Particle , positive_position_kalman)
             flag_search_negative_first =0;
             else
                 memmory_point(1,:)=[];
                 flag_search_negative_first =0;
             end
           end
           
            if numel (memmory_point) >0
               if memmory_point(1,2) == 0
                   memmory_point(1,:) = [];
                   note = ' dont detect first negative point'
                   pause
               end
           end
end

note ='saeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeed'
note='finish real point and start in negative angle point'
pause

while ((numel (memmory_negative_point ) ~= 0)||(num==0))
    
   % memmory_negative_point
    %pause
    
                                IMSHOW_IMAGE_KALMAN_ostad(result_project , 1 , 2 , 4)
                                IMSHOW_IMAGE_KALMAN_ostad(unaceptive_point , 1 , 2 , 5)
                                pause
                                
    Wide  =  FIND_WIDE (memmory_negative_point(1,2) , memmory_negative_point(1,3), wide_init);  
  [row , coloumn , angle , wide ] =  FUNCTION_KALMAN_SEARCH_NEGATIVE_3(memmory_negative_point(1,2) , memmory_negative_point(1,3) , memmory_negative_point(1,4) ,  Wide , Max_Gray , distance_straight_road , distance_curve_road , source_profile , max_search_negative)
   
 % flag_find_any_negative_point
 % pause
   
   if flag_find_any_negative_point ==0
          FUNCTION_KALMAN_3(row , coloumn , angle ,  Wide , Max_Gray , distance_straight_road , distance_curve_road , source_profile , Iteration_Intesection_Particle , Iteration_detour_Particle , negative_position_kalman)
   else
       memmory_negative_point(1,:)=[];
   end
end
end %% end total search

IMSHOW_RESULT_PROJECT(result_project,1,2,9,10)


end

