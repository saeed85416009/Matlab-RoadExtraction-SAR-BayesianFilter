function FUNCTION_PARIS_PARTICLE_1( R_OPTIMUM , C_OPTIMUM , ANGLE , GRAY_ELIMINATE , CONDITION )
% clc;clear all;
global x 
global edge_canny  
global M
global N 
global clusterring 
global test_number
global class_number
global sample_t
global x_total
global remain_clusterring
global x_0

%%% global firm value

 global dt                        %% distance between point in first point
 global dtt
 global  r_optimum                      %% initialize row for priori estimate   (pixel)                    %%---**---%%
 global c_optimum                         %% initialize column for  priori estimate (pixel)                %%---**---%%
 global particle_new_row 
 global particle_new_column 
 global angle                                                                                              %%---**---%%
 global angle_old
 global angle_optimum 
 global contrast_road                 %% firm value for road contrast in edge_canny state for moving in point ( gray level )
 global W
 global WMM                           %% Wide Margin for Matching  
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
global memmory_point

%%
%%%%%% initialize point %%%%%%%%%%%%%
%%%%%% initialize road %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt_right_road= sqrt (4);             %% distance between point in righ road when angle has soft change   %%---**---%%
dt_curve_road = sqrt(4);             %% distance between point in curve road when angle has big change   %%---**---%%

dt=dt_right_road;                        %% distance between point in first point
dtt=dt;

 r_optimum = R_OPTIMUM ;                       %% initialize row for priori estimate   (pixel)                    %%---**---%%
 c_optimum = C_OPTIMUM;                         %% initialize column for  priori estimate (pixel)                %%---**---%%
 particle_new_row = r_optimum ;
particle_new_column = c_optimum ; 

 angle =ANGLE ;                                                                                                %%---**---%%
 angle_old = angle;
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road
 fo = 0;
 fo_optimum = fo;
 end_particle=1;
 p=0;
 contrast_road = 250;                  %% firm value for road contrast in edge_canny state for moving in point ( gray level )
 
 
 W=3;
 WMM = 2*W;                           %% Wide Margin for Matching  
 
 th_angle_particle_1 = 5; %degree
 th_angle_particle_2 = 10; %degree
 th_distance_clusterring = 20;
 th_angle_new_point = 90;  %%degree
 th_forward_dis = 20;  %%distance
 th_angle_merge_cluster = th_angle_particle_1 ;  %degree
 th_angle_measurement = th_angle_particle_1;
 th_angle_measurement_intersection = 90;
 th_angle_true_from_center = 20;
 th_eliminate_angle = 20;
 th_gray_eliminate = GRAY_ELIMINATE;
 %%% for add
 th_angle_add = 10;
 th_gray_add = GRAY_ELIMINATE;
 min_sample_number = 10;
 min_dis_add = 1.5;
 max_dis_add = 8;
 %%%%%%%
 intersection = 1;
 detour = 2;
 %%%%%
 gray_class =255;
 B=1;
 test_number =0;
 %%% imshow
y=x;
z=x;
tiz=x;
class1=x;
class2=x;
 %% section 1
 %% initial sampling

 %%% first method
%   Q_0 = [ 0.04*W 0 0 0 ; 0 0.04*W 0 0 ; 0 0 0.02 0 ; 0 0 0 0.01];            %% covariance of system ( first senario ) - in journal
%   P_0 = 50*Q_0 
%   N=8*W;
%   x_0 = [ r_optimum ; c_optimum ; angle_optimum ; fo_optimum ];   %%  past point  ( x(k-1) )
%   
%   samp = mvnrnd( x_0 , P_0 , N ) %% random sampling with point from EKF & final covariance from EKF & input number of sample
%    z(round(samp(:,1)),round(samp(:,2))) = 255;
%   figure(1)
%   imshow(uint8(z))
%     
%   p_1 =[ 53 54 49  ];        %% initialize reference profile                  %%---**---%%
%   m=max(p_1);
%   k=0;
%   for i=1:N       %%  N=size sample
%        
%       if( x(round(samp(i,1)),round(samp(i,2))) < m )  %% eliminate rand point of out road 
%           k=k+1;
%           y(round(samp(i,1)),round(samp(i,2))) = 255;
%           sample(k,1)=samp(i,1);
%           sample(k,2)=samp(i,2);
%           sample(k,3) = samp(i,3)
%           sample(k,4) = samp(i,4)
%           weight(k)=1/N;
%           
%       
%      end
%   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


  %%% second method for initial sampling with random point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  Q_0 = [ 0.04*W 0 0 0 ; 0 0.04*W 0 0 ; 0 0 0.02 0 ; 0 0 0 0.01];            %% covariance of system ( first senario ) - in journal
  P_0 = 5*Q_0 * [ 1; 1;1;1];  %% regule covariance for wide random
  
  %%% weight need %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  e_opt = 0.3 ; %% e_opt equal from final priori point that create with EKF module
  sigma_fio = ( (pi/30) * (1 + e_opt ))^2;
  R_k = sigma_fio * [  0.4*W 0 0 ; 0 0.4*W 0 ; 0 0 1 ]; 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
  sample_number=8*W;
  x_0 = [ r_optimum ; c_optimum ; angle_optimum ; 0 ];   %%  past point  ( x(k-1) )
  samp(1,:) = normrnd( x_0(1)-sample_number/2 : x_0(1) + sample_number/2 , P_0(1)  );
  samp(2,:) = normrnd( x_0(2)-sample_number/2 : x_0(2) + sample_number/2 , P_0(2)  );
  samp=transpose(samp);  %% samp( x(k)_i  )
    
  

  p_1 =[ 53 54 49  ];        %% initialize reference profile                  %%---**---%%
  m=max(p_1);
  k=0;
  for i=1:sample_number+1       %%  N+1=size sample
      for j=1:sample_number+1
       
        z(round(samp(i,1)),round(samp(j,2))) = 255;  
        
      if( x(round(samp(i,1)),round(samp(j,2))) <=  th_gray_eliminate )  %% eliminate rand point of out road 
          k=k+1;
          y(round(samp(i,1)),round(samp(j,2))) = 255;
          sample(k,1)=samp(i,1);
          sample(k,2)=samp(j,2);
          
          d(1) = sample(k,1);
          d(2) = sample(k,2);
          e(1) = particle_new_row;
          e(2) = particle_new_column;
          angle_sample_new = ANGLE_FIND (d , e );

          sample(k,3) =  ( angle_sample_new * pi )/180 ;  
          sample(k,4) = 0;
          angle_sample(k,3) = ( sample(k,3) * 180 )/ pi  ;
          fo_sample(k,4) = ( sample(k,4) * 180) / pi  ;
         
         
         
          
      else
         r= x(round(samp(i,1)),round(samp(j,2)));
          
      end
      
     end
  end
  

  
  for j=1:k
      
 weight_priori(j)=1/k;
  end
  
  weight_priori = transpose(weight_priori);
 
 sample_number = k ; %%dont toch this thats true
  
  
   figure(1)   %% original random
  imshow(uint8(z))   

  figure(2)  %% eliminate random
  imshow(uint8(y))
  
  %% section 2 
  %% clusterring --------------------------------------------------%%%
 
 s_s = size(sample);
 ss_c=0;
 sample_for_cluster=[];
 flag_duplicate_sample = 0 ;
 for ss = 1:s_s(1)
     
     if sample(ss,2) ~= 0
                       for sss_s = 1:ss_c
                            if ( round(sample(ss,1)) == round(sample_for_cluster(sss_s,2)) )  && ( round(sample(ss,2)) == round(sample_for_cluster(sss_s , 3 )) )
                                flag_duplicate_sample = 1;
                                break;
                            else
                                flag_duplicate_sample = 0;                                                    
                            end
                       end
                       
         if flag_duplicate_sample == 0              
        ss_c = ss_c+1; 
        sample_for_cluster (ss_c , 1 ) = 1;
        sample_for_cluster (ss_c , 2 ) = sample(ss,1);
        sample_for_cluster (ss_c , 3 ) = sample(ss,2);
        sample_for_cluster (ss_c , 4 ) = sample(ss,3);
        sample_for_cluster (ss_c , 5 ) = sample(ss,4);
         end
         
     end
     
 end
 
 
 remain_clusterring =[1];
 clusterring = [];
 class_number =1;
 angle = ( x_0(3) * 180)/pi ;
 [clusterring , sample_for_cluster , flag_find_clusterring ] = CLUSTERRING_OPTIMUM_2_1 (sample_for_cluster  , clusterring , sample_for_cluster , x_0 , angle , th_angle_particle_1, th_distance_clusterring , class_number );
  note='check'
  pause

  single_point=[0 0 0 0 0  ];
      
 while( size(remain_clusterring) ~= 0 )
     
     
     
                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                     if flag_find_clusterring == 0
                     class_number = class_number +1;
                     BB=B+1;
                     B=size(clusterring);

                     gray_class = gray_class - 12.5;
                   
                   for i =BB:B

                                  class1(round(clusterring(i,2)) , round(clusterring(i,3) ) ) = gray_class;
                   end
%                          figure(3)
%                      imshow(uint8(class1))
                     end
                    %  pause
                    %  pause
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 remain_clusterring = REMAIN_CLUSTERRING ( sample_for_cluster , clusterring , class_number );
 
     if size(remain_clusterring ) == 0
         break;
     end
%      note = ' ############################################################################################'
%    pause  

 [ x_new , flag_find_new_point , angle] = FIND_SOURCE_POINT_FOR_NEW_CLUSTER_1_1 ( remain_clusterring , clusterring , single_point , x_0 , th_angle_new_point , 1 , th_forward_dis , th_angle_particle_1 );
 
    if flag_find_new_point ~= 0
        th_angle_new_point_negative = - th_angle_new_point;
        [ x_new , flag_find_new_point , angle  ] = FIND_SOURCE_POINT_FOR_NEW_CLUSTER_1_1 ( remain_clusterring , clusterring , single_point , x_0 , th_angle_new_point_negative , -1 , th_forward_dis , th_angle_particle_1 );
    end
    

    if flag_find_new_point ~= 0
        remain_clusterring
        note = ' dont find any point for start clusterring but exist point from remain clusterring '
        figure(3)
        imshow(uint8(class1))
        pause
        break;
    end
    
 
%  pause

if flag_find_new_point == 0
 [clusterring , sample_for_cluster , single_point , flag_find_clusterring ] = CLUSTERRING_OPTIMUM_2_3 (remain_clusterring  , clusterring , sample_for_cluster , single_point , sample_for_cluster,  x_new , angle , th_angle_particle_2, th_distance_clusterring , class_number , th_angle_true_from_center);
end

  
%  class_number = class_number
%  size(clusterring)
%  size(remain_clusterring)
%  size(sample_for_cluster)
%  
 

 end
 
%  sample_number_old=max(clusterring(:,1));
%  clusterring = ADD_SAMPLE ( clusterring , min_sample_number , sample_number_old , th_angle_add , th_gray_add , min_dis_add , max_dis_add   )
% REGULARIZED_SAMPLE()

 AVG_ANGLE_CLUSTER ()   %% mean angle in each class with 6th element of clusterring
 MERGE_CLUSTER( th_angle_merge_cluster ) %% merge close cluster with mean angle of each class
 AVG_ANGLE_CLUSTER ()   %% mean angle in each class with 6th element of clusterring
 SAMPLE_TOTAL_FIRST_STEP_1_1()  %% total sample with mix of measurement weight and sample 


 ELIMINATE_FALSE_POINT(th_eliminate_angle)

 
 sample_t  %% final sample from process
 x_total
  angle_sample = sample_t ( : , 12 ) * 180 / pi
 note='end'
 pause
                 sample_t(: , 13:16)=0;
 


 
 %% section 3
 %% step 2
         for time = 1:end_particle
 
 
     
 %% update particle    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tiz=[];
 tiz=x;
 %k=sample_number
 sample_number = 0;
 size_sample_t =size(sample_t);
 k=size_sample_t(1)
 angle_sample = sample_t ( : , 12 ) * 180 / pi;
  
%   for i =1 : k
%      zavie = angle_sample(i)+ dtt * (fo_sample(i,4) /2);
%      f_k_priori(i,1)=sample_t(i,2) - dtt*sind ( zavie );
%      f_k_priori(i,2)=sample_t(i,3)  + (dtt)* cosd (zavie );
%      f_k_priori(i,3)=sample_t(i,4)  + dtt * (sample(i,4) );
%      f_k_priori(i,4)=sample_t(i,5) ;
%   end
  
  
             for i=1:k %% generate sample
                
                          zavie = angle_sample(i)+ dtt * (fo_sample(i,4) /2);
     f_k_priori(i,1)=sample_t(i,2) - dtt*sind ( zavie );
     f_k_priori(i,2)=sample_t(i,3)  + (dtt)* cosd (zavie );
     f_k_priori(i,3)=sample_t(i,4)  + dtt * (sample(i,4) );
     f_k_priori(i,4)=sample_t(i,5) ;
     
                          particle_new_row = sample_t(i,10);
                          particle_new_column = sample_t(i,11);
                          Angle_new = sample_t(i,12);
                          Weight_old = sample_t(i,6);
                          S13 = sample_t(i,13);
                          S14 = sample_t(i,14);
                          S15 = sample_t(i,15);
                          S16 = sample_t(i,16);
                          class=sample_t(i,1);
                          
                          bbb=sample_t(i,:)
                          
%                                                     an=Angle_new*180/pi
% dtt*sind ( zavie )
%                           f_kkk=sample_t(i,2) - dtt*sind ( zavie )
%      f_kkkk=sample_t(i,3)  + (dtt)* cosd (zavie )
     
                          s_new(i,1)=normpdf(particle_new_row,f_k_priori(i,1),P_0(1));
                          s_new(i,2)=normpdf(particle_new_column,f_k_priori(i,2),P_0(2));
                          samp(i,1) = f_k_priori(i,1);
                          samp(i,2) = f_k_priori(i,2) ;
%                           SS_NEW1=s_new(i,1)
%                           SS_NEW2 = s_new(i,2)
%                           f_k_priori(i,1)
%                           s_new(i,1)
%                            f_k_priori(i,1) +  s_new(i,1)
%                           s=samp(i,:)
             
                 

                if( x(round(samp(i,1)),round(samp(i,2))) <=  th_gray_eliminate ) && ( samp(i,1) > 1)  %% eliminate rand point of out road 

                      sample_number =sample_number + 1 
                      
                      sample_t(sample_number,1) = class;
                      
                      sample_t(sample_number,2) = samp(i,1);
                      sample_t(sample_number,3) = samp(i,2);
                      
                      sample_t(sample_number,10) = particle_new_row;
                      sample_t(sample_number,11) = particle_new_column;
                      sample_t(sample_number,12) = Angle_new;
                      sample_t(sample_number,6) =Weight_old;
                      
                      sample_t(sample_number,13) =S13;
                      sample_t(sample_number,14) =S14;
                      sample_t(sample_number,15) =S15;
                      sample_t(sample_number,16) =S16;

                      %%%%%%%% create angle %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                      d(1) = sample_t(sample_number,2);
                      d(2) = sample_t(sample_number,3);
                      e(1) = sample_t(sample_number,10);
                      e(2) = sample_t(sample_number,11);
                      angle_sample_new = ANGLE_FIND (d , e );
                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                      sample_t(sample_number,4) =  ( angle_sample_new * pi )/180 ;  
                      sample_t(sample_number,5) = 0;
                      angle_sample(sample_number) = ( sample_t(sample_number,4) * 180 )/ pi  ;
                      fo_sample(i,4) = ( sample_t(sample_number,5) * 180) / pi  ;


                      tiz(round(sample_t(sample_number,2)),round(sample_t(sample_number,3))) = 255;
                      uuu=sample_t(sample_number,:)
% pause
                
                 
             end%%end generate sample
 

   end  %% end of serach in class
 k=sample_number;
 sample_t(sample_number+1 : end , : ) = [];
  
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% section 4
 %% measurment of each particle %%%%%%%%%%%%%%
 flag_eliminate_meas=[];
 eliminate_meas=0;
 for j=1: k
     
     
                 if edge_canny(round(sample_t(j,2)),round(sample_t(j,3)) )< contrast_road 
                     angle_sample_weight = sample_t(j,4)*180/pi;
                     [z_particle(j,1) , z_particle(j,2) , z_particle(j,3) , z_particle(j,4) , flag_intersect] = MEASUREMENT_PARTICLE(sample_t(j,2) , sample_t(j,3)  , contrast_road , WMM , angle_sample_weight , th_angle_measurement , th_angle_measurement_intersection   );
                 else
                     eliminate_meas=eliminate_meas+1;
                      z_particle(j,1) = sample_t(j,2); %% if sample = 0 --> z = inf
                      z_particle(j,2) = sample_t(j,3); 
                      z_particle(j,3) = sample_t(j,4); 
%                      flag_eliminate_meas(eliminate_meas)=j;
                 end
     
     
     
     
     sample_t(j,7) = z_particle(j,1);
     sample_t(j,8) = z_particle(j,2);
     sample_t(j,9) = z_particle(j,3);
      sample_t(j,15)=flag_intersect;
     particle_inf(j,8) = z_particle(j,4);    %%value move measurment around particle
     

 end
 

%  z_particle
%                             if numel(flag_eliminate_meas ~= 0 )
%                             sample_t(flag_eliminate_meas , : )=[];
%                             end

   AVG_ANGLE (sample_t , 4 , 12)                         
 note='vhgvghvg'
 pause

 
%% section 5
 %% clusterring --------------------------------------------------%%%
 REGULARIZED_SAMPLE()
sample_for_cluster=[];
sample_for_cluster  = CREATE_SAMPLE_FOR_CLUSTERRING ()
AVG_ANGLE (sample_for_cluster , 9 , 12)
sample_t
sample_for_cluster
 
 remain_clusterring = [];
 clusterring = [];
 class_number =1;
 class_number_old = max(sample_t(:,1));
 
 %%% this function perform only in step one
 if time == 1
     CREATE_FIRST_SOURCE_POINT_2_1(x_0);
 else
     x_total = [];
     x_total(:,1:12) = x_total_final(:,2:13);
 end
 %%%%%%%%%%%%%%%%%%%%%
 
 remain_clusterring = sample_for_cluster;
 sample_f_c=sample_for_cluster;

 size_remain = size(remain_clusterring);


 
for class = 1 : class_number_old
    
    r_h=0;
    remain=[];
    remain_ext=[];
%     class_number = class_number +1
    
    for r_i = 1 : size_remain(1)
        
        if(remain_clusterring(r_i , 1 ) == class )
          
            r_h=r_h+1;
            remain( r_h , 1 ) = remain_clusterring(r_i , 1);
            remain( r_h , 2 ) = remain_clusterring(r_i , 7);
            remain( r_h , 3 ) = remain_clusterring(r_i , 8);
            remain( r_h , 4 ) = remain_clusterring(r_i , 9);
            remain( r_h , 5 ) = 0;
            
            remain_ext( r_h , 2 ) = remain_clusterring(r_i , 2);
            remain_ext( r_h , 3 ) = remain_clusterring(r_i , 3);
            remain_ext( r_h , 4 ) = remain_clusterring(r_i , 4);
            remain_ext( r_h , 5 ) = remain_clusterring(r_i , 5);
            remain_ext( r_h , 6 ) = remain_clusterring(r_i , 6);
            remain_ext( r_h , 10 ) = remain_clusterring(r_i , 10);
            remain_ext( r_h , 11 ) = remain_clusterring(r_i , 11);
            remain_ext( r_h , 12 ) = remain_clusterring(r_i , 12);
            
        end
        
    end
remain
% pause
     angle = ( x_total(class , 3) * 180)/pi 
      x_total( class , : ) 
      if time ==1
     [clusterring , sample_f_c , flag_find_clusterring ] = CLUSTERRING_OPTIMUM_3_1 (remain  , remain_ext , clusterring , sample_f_c , sample_for_cluster , x_total( class , : ) , angle , th_angle_particle_1, th_distance_clusterring , class );
      else
    [clusterring , sample_f_c , flag_find_clusterring ] = CLUSTERRING_OPTIMUM_3_2 (remain  , remain_ext , clusterring , sample_f_c , sample_for_cluster , x_total( class , : ) , angle , th_angle_particle_1, th_distance_clusterring , class );
      end
     clusterring
%   pause
                 
                 
              
                 remain_clusterring = REMAIN_CLUSTERRING_2 ( sample_f_c , clusterring , class+1  )
                 size_remain = size(remain_clusterring);
% pause
end  %% end search for classes

clusterring(:,13)=clusterring(:,1);
size_sample_for_cluster = size(sample_for_cluster);

% for s_c_f = 1 : size_sample_for_cluster
%     
%     if sample_for_clster( s_c_f , 7 ) == round ( 
AVG_ANGLE (clusterring , 9 , 12)

 note='endddddddddddddddddddd'
 pause

 %% section 6
 %%
 %%%%%%-------------------- repetitive find clusterring ------------------------------------%%%%%%%%%%%%%%%
 class_number = max(clusterring(:,1));
 flag_find_clusterring = 0; 
 sample_f_c = [];
 clusterring_class =[];
 class1=[];
 class1=x;
 
 
for class = 1 : class_number_old
    
    single_point=[];
    single_point=[0 0 0 0 0 0 0 0 0 0 0 0 ];
    sample_f_c = [];
    clusterring_class =[];
    sample_f_c = MATCHING_REPETITIVE_CLUSTERRING( sample_for_cluster , class );
%     clusterring_class = MATCHING_REPETITIVE_CLUSTERRING ( clusterring , class );
    

         while( size(remain_clusterring) > 0  )

             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                             if flag_find_clusterring == 0
                             class_number = class_number +1;
                             BB=B+1;
                             B=size(clusterring);

                             gray_class = gray_class - 12.5;

                           for i =BB:B

                                          class1(round(clusterring(i,7)) , round(clusterring(i,8) ) ) = gray_class;
                           end
%                                  figure(3)
%                              imshow(uint8(class1))
                             end
                            %  pause
                            %  pause
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            
         [ remain_clusterring , flag_finish_remain ]= REMAIN_CLUSTERRING_2 ( sample_f_c , clusterring  )
          if flag_finish_remain == 1
              note=' finish remain '
              break;
          end
          
          if size(remain_clusterring ) == 0
             break;
          end
               note = ' ############################################################################################'
%                    pause  
                
          [ x_new , flag_find_new_point , angle] = FIND_SOURCE_POINT_FOR_NEW_CLUSTER_2 ( remain_clusterring , clusterring , single_point ,  x_total( class , : ) ,  th_angle_new_point , 1 , th_forward_dis , th_angle_particle_1 );
       
                    
          if flag_find_new_point ~= 0
                th_angle_new_point_negative = - th_angle_new_point;
                [ x_new , flag_find_new_point , angle] = FIND_SOURCE_POINT_FOR_NEW_CLUSTER_2 ( remain_clusterring , clusterring , single_point , x_total( class , : ) , th_angle_new_point_negative , -1 , th_forward_dis , th_angle_particle_1 );
         end
    
                if flag_find_new_point ~= 0
                    remain_clusterring
                    note = ' dont find any point for start clusterring but exist point from remain clusterring '
%                     figure(3)
%                     imshow(uint8(class1))
%                     pause
                    break;
                end
                class
                x_new
                note='$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
%                  pause
                
                if flag_find_new_point == 0
                           [clusterring , sample_f_c , single_point , flag_find_clusterring ] = CLUSTERRING_OPTIMUM_4_1 (remain_clusterring  , clusterring , sample_f_c , single_point , sample_for_cluster ,x_new , angle , th_angle_particle_1, th_distance_clusterring , class_number , class);
                end
                    
                
                
                clusterring
                note='&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
%                 pause
         end  %%% end while distance
   class
   note='classssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss'
%    pause

end %% end search clsterring
 
                    figure(3)
                    imshow(uint8(class1))
note='end'
 pause
  
 class_number = max(clusterring(:,1));
 AVG_ANGLE_CLUSTER_2 ()
 REGULARIZED_CLUSTERRING()
 MERGE_CLUSTER_2( th_angle_merge_cluster )
 AVG_ANGLE_CLUSTER_2 ()
 SAMPLE_TOTAL_FIRST_STEP_2()
%  ELIMINATE_FALSE_POINT(th_eliminate_angle)
AVG_ANGLE (sample_t , 4 , 12)

 %% section 7
 %% assign particle too measurment class
 
REGULARIZED_SAMPLE()
ASSIGN(  W , sigma_fio  ) %% assign sample and calculate waight
sample_total=sample_t;
AVG_ANGLE (sample_t , 4 , 12)

 note='end of end'
 pause
 
 CREATE_FIRST_SOURCE_POINT_3();

 
 sample_number_old = max(sample_t(:,1));
 sample_t = ADD_SAMPLE ( sample_t , min_sample_number , sample_number_old , th_angle_add , th_gray_add , min_dis_add , max_dis_add   )
  REGULARIZED_SAMPLE()
  AVG_ANGLE (sample_t , 4 , 12)
    
  
 %%
 

 
 sample_t  %% final sample from process
 
 note='end search'
 pause


 size_sample_t =size(sample_t);
 k=size_sample_t(1);
 angle_sample = sample_t ( : , 4 ) * 180 / pi;
 

 
 
 
 %%     create final x from sample and its weight
 x_total_final=[];
 x_total_final = CREATE_FINAL_X( sample_total );
 
   class_number_new = max(x_total_final(:,1));
   sum_weight=0;
   cons_weight = 1/( ((2*pi)^1.5) * (det( R_k )^0.5) );
   
   for class = 1 : class_number_new

            if edge_canny(round(x_total_final(class,2)),round(x_total_final(class,3)) )< contrast_road 
            angle_sample_weight = x_total_final(class,4)*180/pi;
             [z_particle(class,1) , z_particle(class,2) , z_particle(class,3) ] = MEASUREMENT_PARTICLE(x_total_final(class,2) , x_total_final(class,3)  , contrast_road , WMM , angle_sample_weight , th_angle_measurement , th_angle_measurement_intersection   );
             else
                              z_particle(class,1) = x_total_final(class,2);
                              z_particle(class,2) = x_total_final(class,3); 
    end
     
    
     x_total_final(class , 5 ) = 0;
%      x_total_final(class , 6) = x_total_final(class,4);
     x_total_final(class , 7) = z_particle(class,1);
     x_total_final(class , 8) = z_particle(class,2);
     x_total_final(class , 9) =x_total_final(class,4);
     x_total_final(class , 10) = x_total_final(class,2);
     x_total_final(class , 11) = x_total_final(class,3);
     x_total_final(class , 12) = x_total_final(class,4);
     
     z_m(class,1)= x_total_final(class , 7) ;
     z_m(class,2)= x_total_final(class , 8) ;
     z_m(class,3)= x_total_final(class , 9) ;
     
     x_i(class,1)= x_total_final(class , 2) ;
     x_i(class,2)= x_total_final(class , 3) ;
     x_i(class,3)= x_total_final(class , 4) ;
     
     distance(class) = (z_m(class,:) - x_i(class,:) ) * inv(R_k) *transpose(z_m(class,:) - x_i(class,:) ) ;
     weight_particle(class) = ( 1/class_number_new) * cons_weight * exp( -distance(class)/2 );
     sum_weight = sum_weight + weight_particle(class);
     
     x_total_final(class , 13) = distance(class);
    
   end
 
   
  for class=1:class_number_new %% normalize weight
     weight_particle(class) = weight_particle(class)/sum_weight;
     x_total_final(class , 6) = weight_particle(class);
  end
 
 note='end x total'
 pause
 AVG_ANGLE (sample_t , 4 , 12)

    sample_t(:,16)=sample_t(:,12)*180/pi;
    sample_t(:,13)=sample_t(:,4)*180/pi;
    
    x_total=[];
    x_total = x_total_final;

    class_number_new = max(sample_t(:,1));
    size_sample_t = size(sample_t);
    final_image = x;
    gray=255;
    
    for class = 1:class_number_old
        
        for i = 1:size_sample_t(1)
            
            if(sample_t(i,1)==class)
                
                final_image(round(sample_t(i,2)) , round(sample_t(i,3))) = gray;
                
            end
            
        end
        gray=gray-20;
        
    end
 
     

   

  figure(5)  %% eliminate random
  imshow(uint8(final_image ))
  note='end program'
  pause
 end  %% end repetitive
 
 
 
 
 switch CONDITION
     
     case intersection
         
         note = ' intersection condition'
         
         FINAL_POINT_FOR_INTERSECTION_SITUATION(th_angle_merge_cluster)
         final_point_particle = FIND_FINAL_POINT_PARTICLE ();
         size_final_point = size(final_point_particle);
         ss = size_final_point(1);

         min_dis_angle = 180;
         for f = 1 : ss
             
             distance_angle = abs( angle_old - final_point_particle(f,4) );
             if distance_angle < min_dis_angle
                 
                 min_dis_angle = distance_angle;
                 final_point(1,:) = final_point_particle(f,:);
                 remove_point = f;
                 
             end
             
         end
         
         old_point= [ r_optimum, c_optimum, angle_old]
         r_optimum = final_point(1,2)
         c_optimum = final_point(1,3)
         angle_old = final_point(1,4)
         angle_optimum = angle_old * pi /180;
         
         final_point_particle(remove_point,:)=[]
         pause
         
          size_memmory_point = size( memmory_point );
          add = size_memmory_point(1);
          size_final_point_particle = size(final_point_particle);
          
          for add = 1 : size_final_point_particle(1)
              
              add=add+1;
              memmory_point(add,:) = final_point_particle(i,:);
          end
          
         
     case detour
         
         note = ' detour condition'
         final_point_particle = FIND_FINAL_POINT_PARTICLE ();
         size_final_point = size(final_point_particle);
         ss = size_final_point(1);

         min_dis_angle = 180;
         for f = 1 : ss
             
             distance_angle = abs( angle_old - final_point_particle(f,4) );
             if distance_angle < min_dis_angle
                 
                 min_dis_angle = distance_angle;
                 final_point(1,:) = final_point_particle(f,:);
                 
             end
             
         end
         
         old_point= [ r_optimum, c_optimum, angle_old]
         r_optimum = final_point(1,2)
         c_optimum = final_point(1,3)
         angle_old = final_point(1,4)
         angle_optimum = angle_old * pi /180;
         pause
%          angle_final(:,4) = final_point_particle(:,4) -360;
%          for f = 1 : ss
%              
%              distance_angle = abs( angle_old - angle_final(i,4) );
%              if distance_angle < min_dis_angle
%                  
%                  min_dis_angle = distance_angle;
%                  final_point(1,1:3) = final_point_particle(f,1:3);
%                  final_point(1,4) = angle_final(f,4);
%                  
%              end
%              
%          end
         
 end
         
         
 
 
 
 

 
 
 