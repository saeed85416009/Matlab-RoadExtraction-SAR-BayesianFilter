% 
%%%%%%  create image and smooth that %%%%%%%%%%%%
global x 
global edge_canny  
global match_wide
global M
global N 
global cluster 
global max_profile
global sample_t
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
global memmory_point
global memmory_negative_point
% global unaceptive_point
%%%%%% initialize road %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% x=1:100
% m=mean(x)
% v=var(x)
% norm = normpdf(51,m,0.6)
% stem(norm)



% x_1 =0.89;
% x_0_m = 2.93;
% x_1_m = (1/sqrt(2*pi))*exp(-((x_1-x_0_m)^2)/2)
% x_1_m_original=4.21;
% x=(x_1_m_original - x_1_m ) /x_0_m
% 
% y_1=0.98;
% x_1_m =4.21;
% y_1_m=exp(-((y_1-x_1_m)^2)/2)

%  D = pdist(sample,'euclidean');
%  Z = linkage(D);
%  c = cluster(Z,'cutoff',2);
% global x
% s=[];
% clusterring(:,7:12)=0
% s=clusterring;
% s = ADD_SAMPLE ( clusterring , 5 , 9 , 10 , 70 , 1.4   )
% size_s=size(s);
% class1=x;
% gray =255;
% for i=1:size_s
%     
%             
%             gray_class = gray-((s(i,1)) * 25)
%             class1(round(s(i,2)) , round(s(i,3) ) ) = gray_class;
% end
% imshow(uint8(class1))
%
% s = ADD_SAMPLE ( clusterring , 10 , 3 , 10 , 70 ,1.5 , 8   )
% 

% img(:,1:3)=sample_t(:,1:3);
% img(:,4)=sample_t(:,4)*180/pi;
% img(:,5:6)=sample_t(:,10:11);
% img(:,7)=sample_t(:,12)*180/pi

% clc       
% th_angle_measurement_final_point =90;
% sample_t(:,15:end)=[];
%   %%% tarkibe class ha be 2 ya 3 ya 4 class baste be mizane min va max zaviehae mojud
%          FINAL_POINT_FOR_INTERSECTION_SITUATION(th_angle_particle_1);
%          sample_t(:,5)=sample_t(:,4)*180/pi
%          %%% entekhab e 2 ya 3 ya 4 noghte be hamrahe zavie monaseb baraie vorud be filtere kalman va vorud be memmory point
%          final_point_particle = FIND_FINAL_POINT_PARTICLE_2(15 , 16);  
%          IMSHOW_IMAGE_3( sample_t , 2 , 3 , 15 )
%          pause
%          %%% avardan noghat be vasate jade
%          size_final_point = size(final_point_particle);
%          ss = size_final_point(1);
%          angle_sample_weight = final_point_particle(4)*180/pi;
%          for i = 1 : ss
%                  [ r , c] = MEASUREMENT_PARTICLE( final_point_particle(i,2) , final_point_particle(i,3)  ,contrast_road , WMM , angle_sample_weight , th_angle_measurement_final_point , th_angle_measurement_final_point   );
%                    
%                  final_point_particle(i,2) = r;
%                  final_point_particle(i,3) = c;
%          
%          end
%          
%          %%% entekhab e 1 noghte baraie shoru be filtere kalman beravad va noghtei k bishtarin nazdiki ra be zavie ghablie old point darad
%          
% 
%          min_dis_angle = 180;
%          for f = 1 : ss
%              
%              distance_angle = abs( angle_old - final_point_particle(f,4) );
%              if distance_angle < min_dis_angle
%                  
%                  min_dis_angle = distance_angle;
%                  final_point(1,:) = final_point_particle(f,:);
%                  remove_point = f;
%                  
%              end
%              
%          end
%          
%          old_point= [ r_optimum, c_optimum, angle_old]
%          r_optimum = final_point(1,2)
%          c_optimum = final_point(1,3)
%          angle_old = final_point(1,4)
%          angle_optimum = angle_old * pi /180
%          %%% pak kardane behtarin noghte az matrix final point
%          final_point_particle(remove_point,:)=[]
%          pause
%          
%          %%% ezafe kardane noghtehae yaft shode be memory point baraye inke dar ayande az anha estefade shavad 
%           size_memmory_point = size( memmory_point );
%           add = size_memmory_point(1);
%           size_final_point_particle = size(final_point_particle);
%           
%           for add = 1 : size_final_point_particle(1)
%               
%               add=add+1;
%               memmory_point(add,:) = final_point_particle(i,:);
%           end



global WMM_high
% WMM = WMM_high
% min_wide_break_point
% ROW_PARTICLE=437.0659
% COLOUMN_PARTICLE = 41.9166 
% fi =53.7515
% contrast_road = 250
% min_wide_break_point = 18
%   final_point_particle = [ 1.0000  434.3302   42.4939   53.9536 ]
% %  t  = test_DIFF_MOVE_BREAK ( ROW_PARTICLE ,COLOUMN_PARTICLE  , fi , contrast_road ,  WMM)
% % % 
% %  [C , edge_canny_wide_C , C1 , C2]   = test_DIFF_PARTICLE_3 ( ROW_PARTICLE ,COLOUMN_PARTICLE  , fi , contrast_road ,  WMM);
% %  edge_canny_wide_C
% %  wide  =  FIND_WIDE ( ROW_PARTICLE , COLOUMN_PARTICLE)
% 
% % flag_exchange_particle = FIND_BREAK_POINT_2( ROW_PARTICLE , COLOUMN_PARTICLE , fi , gray_eliminate , 5 , 2)
% 
% angle_sample_weight = final_point_particle(4);
%                    [ r , c] = test_MEASUREMENT_PARTICLE( final_point_particle(1,2) , final_point_particle(1,3)  ,contrast_road , WMM , angle_sample_weight , th_angle_measurement_final_point , th_angle_measurement_final_point , W   );
%    
% 
% 
% 

%  %% avardan noghat be vasate jade
%  final_point_particle = [ 1 235 152 70]
%          size_final_point = size(final_point_particle);
%          ss = size_final_point(1);
%          WMM_very_high =15*W/2
%          th_angle_measurement_final_point=30
%          for i = 1 : ss
%              
%                 angle_sample_weight = final_point_particle(i,4);
%                  [ r , c , f , m] = test_MEASUREMENT_PARTICLE( final_point_particle(i,2) , final_point_particle(i,3)  ,contrast_road , WMM , angle_sample_weight , th_angle_measurement_final_point , WMM_very_high, 8   )
%                    
%                  final_point_particle(i,2) = r;
%                  final_point_particle(i,3) = c;
%          
%          end



% r_optimum = 254.02;
% c_optimum = 144.21;
% angle_old = 1.574*180/pi;
% WIDE = 12;
% error_kalman = 0.1;
% iteration_detour_particle =3;
% flag_exchange_particle = FIND_BREAK_POINT_2( r_optimum , c_optimum , angle_old , gray_eliminate , WIDE , error_kalman , iteration_detour_particle);
% pause
%                                 FUNCTION_PARTICLE_5( r_optimum , c_optimum , angle_old , gray_eliminate , WIDE , detour , 4 , error_kalman ,  iteration_detour_particle )
% 
% 
% IMSHOW_IMAGE_KALMAN(result_project , 1 , 2 , 1)
%                                 IMSHOW_IMAGE_KALMAN(unaceptive_point , 1 , 2 , 2)
%                                 pause
%     
% 
%      memmory_point(1,:) = [ 1, 482.1228 ,   10.6144,-102.6167]
% 
% 
% 
% 
% while (numel (memmory_point ) ~= 0)
%     
%                                 IMSHOW_IMAGE_KALMAN(result_project , 1 , 2 , 1)
%                                 IMSHOW_IMAGE_KALMAN(unaceptive_point , 1 , 2 , 2)
% %                                 pause
%     
%     a=memmory_point(1,2);
%     b=memmory_point(1,3);
%     c=memmory_point(1,4);
%     FUNCTION_KALMAN_2(memmory_point(1,2) , memmory_point(1,3) , memmory_point(1,4) ,  Wide , Max_Gray , distance_straight_road , distance_curve_road , source_profile , Iteration_Intesection_Particle , Iteration_detour_Particle)
%     note='finish this memmory pont and start with below point'
%     memmory_point
%     pause
% % end
% max_w = 6
% W=6
% WMM = 5*W/4; 
%      WMM_normal = 5*W/4;                           %% Wide Margin for Matching
%      WMM_high = 9*W/4;                           %% Wide Margin for Matching
%      WMM_very_high = 15*W/4;
%      min_wide_break_point = max_w *W
%       edge_canny_wide = W/10 ;
% 
%      [wide , uku]  =  FIND_WIDE ( r_optimum , c_optimum , W)
% 




while (numel (memmory_point ) ~= 0) || (numel (memmory_negative_point ) ~= 0)
    
while (numel (memmory_point ) ~= 0)
    
    memmory_point
    pause
    
                                IMSHOW_IMAGE_KALMAN(result_project , 1 , 2 , 4)
                                IMSHOW_IMAGE_KALMAN(unaceptive_point , 1 , 2 , 5)
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

while (numel (memmory_negative_point ) ~= 0)
    
    memmory_negative_point
    pause
    
                                IMSHOW_IMAGE_KALMAN(result_project , 1 , 2 , 4)
                                IMSHOW_IMAGE_KALMAN(unaceptive_point , 1 , 2 , 5)
                                pause
                                
    Wide  =  FIND_WIDE (memmory_negative_point(1,2) , memmory_negative_point(1,3), wide_init);  
  [row , coloumn , angle , wide ] =  FUNCTION_KALMAN_SEARCH_NEGATIVE_3(memmory_negative_point(1,2) , memmory_negative_point(1,3) , memmory_negative_point(1,4) ,  Wide , Max_Gray , distance_straight_road , distance_curve_road , source_profile , max_search_negative)
   
  flag_find_any_negative_point
  pause
   
   if flag_find_any_negative_point ==0
          FUNCTION_KALMAN_3(row , coloumn , angle ,  Wide , Max_Gray , distance_straight_road , distance_curve_road , source_profile , Iteration_Intesection_Particle , Iteration_detour_Particle , negative_position_kalman)
   else
       memmory_negative_point(1,:)=[];
   end
end
end %% end total search

IMSHOW_RESULT_PROJECT(result_project,1,2,9,10)







