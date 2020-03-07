
%%
%%%%%%  create image and smooth that %%%%%%%%%%%%
%%
%%%%%%  create image and smooth that %%%%%%%%%%%%
clc;clear all;
global x ;
global gradient ; 
global match_wide;

a=imread  ( 'E:\internet\uni\proje\matlab\image\sanaa.jpg');
x=double(a);





figure(2)
imshow(uint8(x))

y = x;  

 
 
 %% 
 %%%%%%%% algorithm %%%%%%%%%%%
 
 
 %%
%%%%%% initialize point %%%%%%%%%%%%%

dt_right_road= sqrt (10);
dt_curve_road = sqrt(4);

dt=dt_right_road;
dtt=dt;

 r_optimum = 1928 ;                       %% initialize row for priori estimate   (pixel)
 c_optimum = 633;                         %% initialize column for  priori estimate (pixel)
 r_opt = r_optimum ;
 r_opt = r_optimum ;
c_opt = c_optimum ; 

 angle =92 ;
 angle_old = angle;
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road
 
 W=16;                                         %% initialize road wide
 W_P=W;
 W1=W_P; W2 = W_P; W3 = W_P; W4 = W_P;  W5 = W_P; W6 = W_P; W7 = W_P; W8 = W_P ; W9 = W_P; W10 = W_P;

 
 fo_optimum = 0.000001 ;
 fo = fo_optimum;                       %% initialize change in the road direction
 
 p_k_0 = 0.0001;                         %% initialize covariance matrice
 
 %%%%%%%%%%% initialize reference profile

 
 %%% regulator parameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 W=16;                                         %% initialize road wide
 sigma_fis = (1/88)^2;                %% variance af system noise
 contrast_match = 80;                %% firm value for cluster contrast (gray level )
 angle_change = 30;                   %% angle change for find best condidate ( degree )
 CSM = 1;                                   %% Cluster Similarity Modify ( regulation similarity between clusters )  ( pixel )
 WMM = 5*W/4;                           %% Wide Margin for Matching
 CG = 200;                                  %% Cut Gradient
 contrast_road = 150;                  %% firm value for road contrast in gradient state for moving in point ( gray level )
 max_grad = contrast_road;                       %% maximum gradian that my measurment point can be value
 SA = 450;                                   %% Stop Algorithm
 e_optimum = 0.1;                       %% maximum error in EKF
 error_margin = 0.1;                     %% margin of error for research
 C_optima = 80;                          %% i assumed that my first wide of road is ...
 var_mean_good = 500;               %% maximum variance that my condidate point profile can be have if all of ingredient of profile less than source profile
 var_mean_bad = 300;                  %% maximum variance that my condidate point profile can be have if few of ingredient of profile more than source profile
 var_max_cluster = 200;              %% maximmum variance that cluster can be have
 gradient_wide = W/10 ;
 T_angle = angle_change / 3;        %% if occure big change in angle compaire past angle ''and'' we detect bad gradiend wide remove condidate point ( Threshould_angle change )      
th_car = 100 ;                               %% threshoul value for detect car in the road
th_pixel_car = 1;                           %% maximum lengh of car in the picture
th_first_dis_edge_car = 0 ;           %% distance from car to end of profle
th_angle_change = 20;                 %% if angle change between measurement point and old point more than threshould we change distance between point and we change little
max_gay_prof_car = 80;
C_max_cluster = 4;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%% for check point
  e56=1;  
  rowpb = r_optimum;
  columnpb= c_optimum;
  fujitso = 1;
 %%%%%%
 
 ANGLE = angle


[M , N ] =size(x)

%% create seed for earn profile
W = W;
max_profile =80;
max_clasify_search = 80;
for k = 10 : 10 : max_profile
for i= 1:M
    for j=1:N
      
        if (x(i,j) <=k) && ( x(i,j) > k - 10 )
        seed(i,j) = k;
        end
        
        end
    end
end

m_search =0;
flag_seed = 0;
while ( m_search < max_clasify_search )
    flag_seed = 0;
    for i=2:M-2
        for j=2:N-2
            if seed(i,j) <=70
           if  (abs(seed(i,j) - seed(i+1,j-1) ) <= 10) &&  ( seed( i+1 , j-1 ) <= 100 )
               flag_seed = flag_seed + 1;
               seed(i,j)  = seed(i+1,j-1);
            elseif (abs(seed(i,j) - seed(i,j-1) ) <= 10) &&  ( seed( i , j-1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i,j-1);
           elseif (abs(seed(i,j) - seed(i+1,j) ) <= 10) &&  ( seed( i+1 , j ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i+1,j);
           elseif (abs(seed(i,j) - seed(i+1,j+1) ) <= 10) &&  ( seed( i+1 , j+1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i+1,j+1);
           elseif (abs(seed(i,j) - seed(i,j+1) ) <= 10) &&  ( seed( i , j+1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i,j+1);
             elseif (abs(seed(i,j) - seed(i+1,j) ) <= 10) &&  ( seed( i+1 , j ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i+1,j);
             elseif (abs(seed(i,j) - seed(i-1,j-1) ) <= 10) &&  ( seed( i-1 , j-1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i-1,j-1);
             elseif (abs(seed(i,j) - seed(i-1,j+1) ) <= 10) &&  ( seed( i-1 , j+1 ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i-1,j+1);
             elseif (abs(seed(i,j) - seed(i-1,j) ) <= 10) &&  ( seed( i-1 , j ) <= 100 ) 
             flag_seed = flag_seed + 1;
             seed(i,j)  = seed(i-1,j);
           end
            end
        end
    end
    m_search = m_search +1
end

 max_profile = 80;
 max_clasify_search = 150;
 max_wide_profile =200;
 Dt = 1.4;
 

r_prof = r_optimum
c_prof = c_optimum
prof_count = 1;


%%

r_prof = r_optimum
c_prof = c_optimum
prof_count = 1;


    R_prof =0;
    R_prof(1,1) = seed(r_prof,c_prof );
    r_4 = r_prof;
    c_4 = c_prof;
    i=1;
    %%
    while(abs( R_prof (1,i) - seed(r_optimum,c_optimum )) <= DIFF_PROF ) && ( i < wide_SOURCE_PROFILE ) && ( prof_count <MAX_WIDE_PROFILE)
      

            if x(r_prof,c_4 ) < MAX_PROF
            SOURCE_PROF(1,prof_count) = x(r_prof , c_4 )
            end
            
             i = i + 1
             c_4 = c_4 + 1
             prof_count = prof_count + 1 
             
             R_prof(1,i) = seed(r_prof , c_4 )
             
        

                   if ( r_prof > M-2 ) || ( r_prof == 2 ) || ( c_4 > N-2 ) || ( c_4 == 2 )   %% [M,N] = size(x)
                       break;
                   end 
                   
                   j=1;
                   C_prof =0;
                   C_prof(1,1) = seed(r_prof,c_4 );
                   while(abs( C_prof (1,j) - seed(r_optimum,c_optimum )) <= DIFF_PROF ) && ( j< wide_SOURCE_PROFILE )
                       
                             if x(r_4,c_4 ) < MAX_PROF
                             SOURCE_PROF(1,prof_count) = x(r_4 , c_4 )
                             end
                             
                             j= j + 1
                             r_4 = r_4 + 1
                             prof_count = prof_count + 1 

                             C_prof(1,j) = seed(r_4 , c_4 )
                             
                               if ( r_4 > M-2 ) || ( r_4 == 2 ) || ( c_4 > N-2 ) || ( c_4 == 2 )   %% [M,N] = size(x)
                                   break;
                               end
                               
                   end
                       

                          
      
    end

  %%

    R_prof =0;
    R_prof(1,1) = seed(r_prof,c_prof );
    r_4 = r_prof;
    c_4 = c_prof;
    i=1;
    
    while(abs( R_prof (1,i) - seed(r_optimum,c_optimum )) <= DIFF_PROF ) && ( i < wide_SOURCE_PROFILE ) &&  ( prof_count <MAX_WIDE_PROFILE)
      

            if x(r_prof,c_4 ) < MAX_PROF
            SOURCE_PROF(1,prof_count) = x(r_prof , c_4 )
            end
            
             i = i + 1
             c_4 = c_4 - 1
             prof_count = prof_count + 1 
             
             R_prof(1,i) = seed(r_prof , c_4 )
             
        

                   if ( r_prof > M-2 ) || ( r_prof == 2 ) || ( c_4 > N-2 ) || ( c_4 == 2 )   %% [M,N] = size(x)
                       break;
                   end 
                   
                   j=1;
                   C_prof =0;
                   C_prof(1,1) = seed(r_prof,c_4 );
                   while(abs( C_prof (1,j) - seed(r_optimum,c_optimum )) <= DIFF_PROF ) && ( j< wide_SOURCE_PROFILE )
                       
                             if x(r_4,c_4 ) < MAX_PROF
                             SOURCE_PROF(1,prof_count) = x(r_4 , c_4 )
                             end
                             
                             j= j + 1
                             r_4 = r_4 + 1
                             prof_count = prof_count + 1 

                             C_prof(1,j) = seed(r_4 , c_4 )
                             
                               if ( r_4 > M-2 ) || ( r_4 == 2 ) || ( c_4 > N-2 ) || ( c_4 == 2 )   %% [M,N] = size(x)
                                   break;
                               end
                               
                   end
        
      
    end



imshow(uint8(seed))

