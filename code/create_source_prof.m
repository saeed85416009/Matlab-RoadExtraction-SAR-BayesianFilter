%%
%%%%%%  create image and smooth that %%%%%%%%%%%%
clc;clear all;
global x ;
global gradient ; 
global match_wide;

a=imread  ( 'E:\mat\paris.jpg');
b=rgb2gray(a);
x=double(b);



CUT_IMAGE_PARIS_3()



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

  r_optimum = 270 ;                       %% initialize row for priori estimate   (pixel)
 c_optimum = 26;                         %% initialize column for  priori estimate (pixel)
 r_opt = r_optimum ;
 r_opt = r_optimum ;
c_opt = c_optimum ; 

 angle =45 ;
 angle_old = angle;
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road
 
 W=21;                                         %% initialize road wide
 W_P=W;
 W1=W_P; W2 = W_P; W3 = W_P; W4 = W_P;  W5 = W_P; W6 = W_P; W7 = W_P; W8 = W_P ; W9 = W_P; W10 = W_P;

 
 fo_optimum = 0.000001 ;
 fo = fo_optimum;                       %% initialize change in the road direction
 
 p_k_0 = 0.0001;                         %% initialize covariance matrice
 
 %%%%%%%%%%% initialize reference profile
 p_1 =[53 53 54 49 52 ];        %% initialize reference profile
 [yek , M_P ] =size(p_1) ;                        %% for check point
 %weight = [ 3 6 10 6 3 ];
 weight = ones(1,M_P);
 
 if ( p_1 - 10 > 0 )
 p_2 = p_1 -10;
 else
     p_2 = zeros(1,M_P);
 end

 if ( p_1 - 20 > 0 )
 p_3 = p_1 -20;
  else
     p_3 = zeros(1,M_P);
 end
 
 if ( p_1 -30 >0 )
 p_4 = p_1 - 30;
  else
     p_4 = zeros(1,M_P);
 end
 
 b_1 =  zeros(1,M_P );
 b_2 = b_1; b_3 = b_1 ; b_4 =b_1; b_5 = b_1 ; b_6 = b_1; b_7 = b_1; b_8 = b_1 ; b_9 = b_1;
 %%%%%%%%%%%%%%%%%%%
 
 [ M,N] = size(x);
 cluster = 1;                                %% inialial cluster
 
%%% sobel gradient %%%%%%%%%%%%%%%%
 mask_1 = [ 1 2 1 ; 0 0 0 ; -1 -2 -1 ] ;
 mask_3 = [ 1 0 -1 ; 2 0 -2 ; 1 0 -1 ] ;
 mask_2 = [ -2 -1 0 ; -1 0 1 ; 0 1 2 ] ;
 mask_4 = [ 0 1 2 ; -1 0 1 ; -2 -1 0 ] ;
 
gradient1 = abs( M_SOBEL_GRADIENT (mask_1));
gradient2 = abs( M_SOBEL_GRADIENT (mask_2));
gradient3 = abs( M_SOBEL_GRADIENT (mask_3));
gradient4 = abs( M_SOBEL_GRADIENT (mask_4));

gradient5 = sqrt(gradient1.^2 + gradient3.^2 );
gradient6 = sqrt(gradient2.^2 + gradient4.^2 );
%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %%% regulator parameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 W=16;                                         %% initialize road wide
 sigma_fis = (1/88)^2;                %% variance af system noise
 contrast_match = 80;                %% firm value for cluster contrast (gray level )
 angle_change = 30;                   %% angle change for find best condidate ( degree )
 CSM = 1;                                   %% Cluster Similarity Modify ( regulation similarity between clusters )  ( pixel )
 match_wide =( M_P - 1 ) / 2;    %% (wide of profile matching -1 ) / 2
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
th_end_dis_edge_car=M_P +1;
th_angle_change = 20;                 %% if angle change between measurement point and old point more than threshould we change distance between point and we change little
max_gay_prof_car = 80;
C_max_cluster = 4;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%% for check point
  e56=1;  
  rowpb = r_optimum;
  columnpb= c_optimum;
  fujitso = 1;
  %%
y = x;  
[ M,N] = size(x);
seed = x;

%% create seed for earn profile
wide_source_profile = W;
for i= 1:M
    for j=1:N
        if x(i,j) <=10
            seed(i,j) =10;
        elseif x(i,j) <= 20
                seed(i,j) = 20;
                elseif x(i,j) <=30
                    seed(i,j)=30;
                    elseif x(i,j) <=40
                        seed(i,j) = 40;
                        elseif x(i,j) <= 50
                            seed(i,j) = 50;
                            elseif x(i,j) <= 60
                                seed(i,j) =60;
                                elseif x(i,j) <= 70
                                    seed(i,j) = 70;
                                    elseif x(i,j) <= 80
                                        seed(i,j) = 80;
                                        elseif x(i,j) <= 90
                                            seed(i,j) = 90;
                                            elseif x(i,j) <=100
                                                seed(i,j) =100;
        end
    end
end

figure(1)
imshow(uint8(seed))

max_search =0;
flag_seed = 0;
while ( max_search < 150 )
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
    max_search = max_search +1
end

%%

r_prof = r_optimum;
c_prof = c_optimum;
prof_count = 1;


while(abs(seed(r_prof,c_prof ) - seed(r_optimum,c_optimum ))<= 10 )&& ( prof_count <100)
    flag_wide_source_profile=1;
    R_prof =0;
    R_prof(1,1) = seed(r_prof,c_prof );
    r_4 = r_prof;
    c_4 = c_prof;
    i=1;
    %%
    while(abs( R_prof (1,i) - seed(r_optimum,c_optimum )) < 10 )
      

            
            source_profile(1,prof_count) = x(r_prof , c_4 );
            
             i = i + 1;
             c_4 = c_4 + 1;
             prof_count = prof_count + 1 ;
             
             R_prof(1,i) = seed(r_prof , c_4 );
             
        

                   if ( r_prof > M ) || ( r_prof == 0 ) || ( c_4 > N ) || ( c_4 == 0 )   %% [M,N] = size(x)
                       break;
                   end 
        
      
    end
  %%
    R_prof =0;
    R_prof(1,1) = seed(r_prof,c_prof );
    r_4 = r_prof;
    c_4 = c_prof;
    i=1;
    
    while(abs( R_prof (1,i) - seed(r_optimum,c_optimum )) <= 10 )
      

            
            source_profile(1,prof_count) = x(r_prof , c_4 );
            
             i = i + 1;
             c_4 = c_4 - 1;
             prof_count = prof_count + 1 ;
             
             R_prof(1,i) = seed(r_prof , c_4 );
             
        

                   if ( r_prof > M ) || ( r_prof == 0 ) || ( c_4 > N ) || ( c_4 == 0 )   %% [M,N] = size(x)
                       break;
                   end 
        
      
    end
  
    %%
        r_prof = round( r_optimum - dt * sind ( angle )) ;   
        c_prof = round( c_optimum + dt * cosd ( angle ));
        
        if (abs(seed(r_prof,c_prof ) - seed(r_optimum,c_optimum ))<= 10 )
            
       u=0; 
       i=1;
       R_wide_prof = 0;
       R_wide_prof(1,1) =  seed(r_prof,c_prof )  ;     
              
    while(abs( R_wide_prof (1,i) - seed(r_optimum,c_optimum )) < 10 )
        i = i + 1;
        u=u+1;
        r_4 = round ( r_prof + u *sind (90-angle ));    %  check shode dorosre
        c_4 = round ( c_prof + u *cosd ( 90-angle ));
       
       if ( r_4 > M ) || ( r_4 == 0 ) || ( c_4 > N ) || ( c_4 == 0 )   %% [M,N] = size(x)
           break;
       end 
       
       R_wide_prof(1,i) = seed(r_4 , c_4 );
       T = i ;
       
       if (T>wide_source_profile)
           T=1000;
           flag_wide_source_profile = 0;
           break
       end

       
      
end

if T ~= 1000
T = sqrt ( ( r_4 - r_prof )^2 + ( c_4 - c_prof)^2 );    %%% measurement T
end
    
       u=0; 
       i=1;
       R_wide_prof = 0;
       R_wide_prof(1,1) =  seed(r_prof,c_prof )  ;  
      
while(abs( R_wide_prof (1,i) - seed(r_optimum,c_optimum )) < 10 )
        i = i + 1;
        u=u+1;
        r_4 = round ( r_prof - u *sind (90-angle ));    %  check shode dorosre
        c_4 = round ( c_prof - u *cosd ( 90-angle ));
       
       if ( r_4 > M ) || ( r_4 == 0 ) || ( c_4 > N ) || ( c_4 == 0 )   %% [M,N] = size(x)
           break;
       end 
       
       R_wide_prof(1,i) = seed(r_4 , c_4 );
       G = i ;
       
       if (G>wide_source_profile)
           G=1000;
           flag_wide_source_profile = 0;
           break
       end

       
      
end
    
if G ~= 100
G = sqrt ( ( r_4 - r_prof )^2 + ( c_4 - c_prof)^2 );    %%% measurement T
end
    

%%
                if            flag_wide_source_profile ~= 0

                if G >= T
                    u=abs(T-G);
                    r_prof = round ( r_prof - u *sind (90-angle ));    %  check shode dorosre
                    c_prof = round ( c_prof - u *cosd ( 90-angle ));
                else
                    r_prof = round ( r_prof + u *sind (90-angle ));    %  check shode dorosre
                    c_prof = round ( c_prof + u *cosd ( 90-angle ));
                end

                end
                        
        end
        
end









    
    
    
%%
for i= 1:M
    for j=1:N
        if seed(i,j) > 100
            seed(i,j) = 255;
        end
    end
end

figure(2)
imshow(uint8(seed))
             