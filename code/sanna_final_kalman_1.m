%%
%%% this method create with :
%%% 1 : canny edge detector
%%% 2 :create Automatic  source profile
%%% 3 : variable distance between two point according to curve or right road
%%% 4 : softening image with 5*5 mask 
%%%
%%% 2 step for measurment :
%%% 1 : use ''x'' for search best profile matching with journal method(xcorr2) 
%%% 2 : use ''t'' for search best distance to edge with canny edge detector
%%%

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


a=imread  ( 'E:\internet\uni\proje\matlab\image\sanaa.jpg');   %%---**---%%

x=double(a);
level = graythresh(a)
level = im2uint8(level)




mask = ( 1/115) * [ 2 4 5 4 2 ; 4 9 12 9 4 ; 5 12 15  12  5 ; 4 9 12 9 4 ; 2 4 5 4 2 ]
x= conv2(mask , x);       %% softening image


y=x;
t=x;                  %% use for canny edge detector and find best distance between edge 
[M , N ] =size(t);

for i= 1:M                     %% i know that road in dark position isnt more than ... gray level therfor i assume gray level of image is max in non road  
    for j=1:N
        if x(i,j) > level             %%---**---%%
            t(i,j) = 255;
        end
    end
end



 
 
 %% 
 %%%%%%%% algorithm %%%%%%%%%%%
 
 
 %%
%%%%%% initialize point %%%%%%%%%%%%%
%%%%%% initialize road %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt_right_road= sqrt (10);             %% distance between point in righ road when angle has soft change   %%---**---%%
dt_curve_road = sqrt(4);             %% distance between point in curve road when angle has big change   %%---**---%%

dt=dt_right_road;                        %% distance between point in first point
dtt=dt;

 r_optimum = 1928 ;                       %% initialize row for priori estimate   (pixel)                    %%---**---%%
 c_optimum = 636;                         %% initialize column for  priori estimate (pixel)                %%---**---%%
 r_opt = r_optimum ;
c_opt = c_optimum ; 

 angle =92 ;                                                                                                %%---**---%%
 angle_old = angle;
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road
 
 W=16;                                         %% initialize road wide                 %%---**---%%
 W_P=W;
 W1=W_P; W2 = W_P; W3 = W_P; W4 = W_P;  W5 = W_P; W6 = W_P; W7 = W_P; W8 = W_P ; W9 = W_P; W10 = W_P;

 
 fo_optimum = 0.000001 ;
 fo = fo_optimum;                       %% initialize change in the road direction
 
 p_k_0 = 0.0001;                         %% initialize covariance matrice
 
 %%%%%%%%%%% initialize reference profile%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_profile = 80;                       %%---**---%%    %% this point show when point out of road
 max_clasify_search = 150;
 max_wide_profile =200;
 diff_profile = 10;
 size_profile = 5;
 [ source_profile , pf ] = SOURCE_PROFILE_EXTENDED(r_optimum , c_optimum , angle , W  , max_profile , max_clasify_search , max_wide_profile , diff_profile , size_profile)


p_1 =[53 53 54 49 52 ]        %% initialize reference profile                  %%---**---%%
[yek , M_P ] =size(p_1) ;                        %% for check point
 weight = ones(1,M_P);
[p_1 ,p_2 , p_3 ,p_4] = CREATE_PROFILE ( p_1 , M_P );
%weight = [ 3 6 10 6 3 ];
 
 b_1 =  zeros(1,M_P );
 b_2 = b_1; b_3 = b_1 ; b_4 =b_1; b_5 = b_1 ; b_6 = b_1; b_7 = b_1; b_8 = b_1 ; b_9 = b_1;
 %%%%%%%%%%%%%%%%%%%  canny edge detector %%%%%%%%%%%%%%%%%%%%%%
edge_canny = EDGE_FND_CANNY ( t );
figure (1)
imshow(uint8(edge_canny))
 
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
 %% 
 %%%%%%%% algorithm %%%%%%%%%%%

 for yy = 2 : 1 :SA  %% start algorithm main
dt=dt_right_road;
dtt=dt;
     
     %% first stage    ( prediction stage )
     %%%%%%% priori estimate and covariance of that %%%%%%%%%%%%
    
     x_p = [ r_optimum ; c_optimum ; angle_optimum ; fo_optimum ];   %%  past point  ( x(k-1) )
     
     zavie = angle+ dtt * (fo/2);
     f_k = [ 1, 0, (dtt*cosd ( zavie )) , (0.5*(dtt^2)* cosd (zavie ))  ; 0, 1, (-dtt*sind (zavie )) ,  (-0.5*(dtt^2)*sind ( zavie ))  ; 0, 0, 1, dtt ; 0, 0, 0, 1 ];       %% liniarization function ( system Dynamic )


     a_1=r_optimum - dtt*sind ( zavie );
     a_2=c_optimum + (dtt)* cosd (zavie );
     a_3=angle_optimum + dtt * (fo_optimum);
     a_4=fo_optimum;

                        %%%%%%% you should be choose 1 senario of below for
                        %%%%%%% priori estimate
                        
     x_manfi_k = [ a_1 ; a_2 ; a_3 ; a_4 ]                        %% first senario for priori estimate 
    % x_manfi_k = f_k * x_p  ;                                          %% second senario for priori estimate
     
     
     Q_k = [ 0.04*W 0 0 0 ; 0 0.04*W 0 0 ; 0 0 0.02 0 ; 0 0 0 0.01];            %% covariance of system ( first senario ) - in journal

%      Q_k =( sigma_fis ) * [ (( (dtt^4)/3 ) * ((cosd( angle ))^2)) , (( ( dtt^4 )/3 ) * sind ( angle ) * cosd ( angle ) )  ,  ( (( dtt^3 )/3 ) * cosd ( angle )) , 0  ;  
%          (( ( dtt^4 )/3 ) * sind ( angle ) * cosd ( angle ) ), (( (dtt^4)/3 ) * ((sind( angle ))^2)) ,   ( (( dtt^3 )/3 ) * sind ( angle))  ,  0  ; 
%          (((dtt^3)/3)*cosd(angle))  ,  (((dtt^3)/3)*sind(angle))  ,  (dtt^2)/3  ,  dtt/2  ; 
%          0 , 0  , dtt/2 , 1 ] ;                                                                        %% covariance of system ( second senario ) - in thesis
   
     p_manfi_k = (f_k * p_k_0 *  transpose ( f_k ))+Q_k   %% covariance of priori state
     
     
     %% second stage ( measurment )
     %%%%%%%%% generate measurment for fusion with priori estimate and use in update stage
     %%%( 3-1 algorithm in thesis )
     
     %%% step1 : use x( k-1 ) that generated in last step
     %%% step 2 :  create set of probable point and angle
     
    e_opt = e_optimum;                                 %% initial measurement error
    C_opt=C_optima;                                   %% i assumed that my first wide of road is ....
    q=1;
    AA=1:M_P;
    reg = 0 ; 
    p_com_angle = 1000;

    
      for fi = ( angle -angle_change ) : 1 : ( angle + angle_change)
          
              find_error_flag = 1;         %% flag for detect bad var and cov  ( flag = 0 is right )
              flag_edge_canny = 1 ;           %%%% flag for edge_canny value... if edge_canny value in condidate point is more than maximmum edge_canny ( constant value that we set first initial)
                                                    %%%% flag set 1 and we
                                                     %%%% remove condidate
                                                     %%%% point continue
                                                     %%%% search again

    
    r_prob =  r_optimum - dt * sind ( fi ) ;   
    c_prob =  c_optimum + dt * cosd ( fi );             %% measurement cordinate point
    
    r_2= round ( r_optimum - dt * sind ( fi )) 
    c_2 = round ( c_optimum + dt * cosd ( fi ))
    fi
    
   
    
    %%
    %%%% profile matching %%%%
    
      aa=ORIGINAL_MATCH(r_prob , c_prob , fi)    
      
       %%% check ingredient %%%%%
      [ var_max ] = CHOOSE_OPTIMUM_VAR_MAX( aa , p_1 , p_2, p_3 , p_4 , b_1 , b_2 , b_3 , b_4 , b_5 , b_6 , b_7 , b_8 , b_9 , var_mean_good , var_mean_bad );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     %%% algorithm for check exist car %%%%%%%%%%  
        if ( var(aa) > var_max)
               aa = CAR( aa ,th_car , p_1 , th_pixel_car , th_first_dis_edge_car , th_end_dis_edge_car , max_gay_prof_car )
           end
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%% error find %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
      if var(aa) > var_max  
                if aa < mean(p_1)
                    var(aa) = var(p_1);
                end
      end

      
if ( var(aa) < var_max ) 
[error_1] = ERROR_MATCH_ARRANGED (p_1,aa);
[error_2] = ERROR_MATCH_ARRANGED (b_1,aa);
[error_3] = ERROR_MATCH_ARRANGED (b_2,aa);
[error_4] = ERROR_MATCH_ARRANGED (b_3,aa);
[error_5] = ERROR_MATCH_ARRANGED (b_4,aa);
[error_6] = ERROR_MATCH_ARRANGED (b_5,aa);
[error_7] = ERROR_MATCH_ARRANGED (b_6,aa);
[error_8] = ERROR_MATCH_ARRANGED (b_7,aa);
[error_9] = ERROR_MATCH_ARRANGED (b_8,aa);
[error_10] = ERROR_MATCH_ARRANGED (b_9,aa);
[error_11] = ERROR_MATCH_ARRANGED (p_2,aa);
[error_12] = ERROR_MATCH_ARRANGED (p_3,aa);
[error_13] = ERROR_MATCH_ARRANGED (p_4,aa);
find_error_flag = 0;

end

if  find_error_flag == 0
   error_out = [error_1,error_2,error_3,error_4,error_5,error_6,error_7,error_8,error_9,error_10,error_11,error_12,error_13 ];
   e=min(error_out)
   aa
   
   if error_2 == e
       W = W1;
   elseif error_3 == e
       W = W2;
   elseif error_4 == e
       W = W3;
   elseif error_5 == e
       W=W4;
   elseif error_6 == e
       W=W5;
   elseif error_7 == e
       W=W6;
   elseif error_8 == e
       W = W7;
   elseif error_9 == e
       W = W8;
   elseif error_10 == e
       W = W9;
   else
       W = W_P;
   end

   if (var(aa) == 0 )  %% for good variance of aa
       e = 0.002;
   end
   
else
    e = 1000;
    note = ' variance is bad situation and is over max '
   
end  %% the end of find error flag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
e = OUT_ROAD ( aa , th_pixel_car , e , max_profile )

%%%% equal diffrential between right and left of point from edge %%%%%%%%%%%%%%%%%%%%%%%%%%
if  ( abs(e) < abs(e_opt) && ( edge_canny(r_2,c_2) < max_canny )  )
    
      %%% equal " C " :  for locate point on center of road
      [C , edge_canny_wide_C]  = DIFF_PROFILE ( r_prob , c_prob , fi , contrast_road ,  WMM);
      C
      flag_edge_canny = 0 ;
      %%% detect wrong point %%%
      %%% if earned point in hole situation
        if ( edge_canny_wide_C < ( edge_canny_wide ) ) && ( abs(fi-angle) > T_angle )
            C = 1000;
            flag_edge_canny = 1 ;
        end
      %%%%%%%%%%%%%%%%%%%%%%%%%
else
flag_edge_canny = 1 ;
note = ' bad error in this point or point in edge'
end  %% end edge_canny
         
%%%%%%%%%%%%%%%%

%% compairing mision and equal Z
if       flag_edge_canny == 0 ;

            note = ' new condidate point'
            Error(q)=e;
            Diff(q)=C;
            Row(q)=r_prob;
            Column(q)=c_prob;
            Angle(q)=fi;
            AA(q,:)=aa;
            q=q+1
end%%% the end of compairing mision

            
       
      end         %% the end of search for angle ( or fi ) 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      C_opt = C_optima;
      q=q-1;
        change_A   = angle_change;
              while ( q )
                   if ( Diff(q) < C_opt )
                       C_opt = Diff (q);
                       reg = q;
                   elseif ( Diff(q) == C_opt )
                       if ( abs(angle - Angle(q)) < change_A )
                           change_A = abs( angle - Angle(q));
                           C_opt = Diff (q);
                           reg = q;
                       end
                   end
                   q=q-1;
              end
              
              
      
                   
              
             %% if error of road more than normal_error i assume between normal error and max error  
              if (reg == 0)
                  
                    e_opt = e_optimum + error_margin                                 %% initial measurement error
                    C_opt=C_optima;                                %% i assumed that my first wide of road is ....
                    q=1;
                    AA=1:M_P;
                    reg = 0 ; 
                    note = ' bad error and increase maximum error '
                    

                    
                    for fi = ( angle -angle_change ) : 1 : ( angle + angle_change)
          
              find_error_flag = 1;         %% flag for detect bad var and cov  ( flag = 0 is right )
              flag_edge_canny = 1 ;           %%%% flag for edge_canny value... if edge_canny value in condidate point is more than maximmum edge_canny ( constant value that we set first initial)
                                                    %%%% flag set 1 and we
                                                     %%%% remove condidate
                                                     %%%% point continue
                                                     %%%% search again

    
    r_prob =  r_optimum - dt * sind ( fi ) ;   
    c_prob =  c_optimum + dt * cosd ( fi );             %% measurement cordinate point
    
    r_2= round ( r_optimum - dt * sind ( fi )) 
    c_2 = round ( c_optimum + dt * cosd ( fi ))
    fi
    
   
    
    %%
    %%%% profile matching %%%%
    
      aa=ORIGINAL_MATCH(r_prob , c_prob , fi)    
      
       %%% check ingredient %%%%%
      [ var_max ] = CHOOSE_OPTIMUM_VAR_MAX( aa , p_1 , p_2, p_3 , p_4 , b_1 , b_2 , b_3 , b_4 , b_5 , b_6 , b_7 , b_8 , b_9 , var_mean_good , var_mean_bad );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     %%% algorithm for check exist car %%%%%%%%%%  
        if ( var(aa) > var_max)
               aa = CAR( aa ,th_car , p_1 , th_pixel_car , th_first_dis_edge_car , th_end_dis_edge_car , max_gay_prof_car )
           end
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%% error find %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
      if var(aa) > var_max  
                if aa < mean(p_1)
                    var(aa) = var(p_1);
                end
      end

      
if ( var(aa) < var_max ) 
[error_1] = ERROR_MATCH_ARRANGED (p_1,aa);
[error_2] = ERROR_MATCH_ARRANGED (b_1,aa);
[error_3] = ERROR_MATCH_ARRANGED (b_2,aa);
[error_4] = ERROR_MATCH_ARRANGED (b_3,aa);
[error_5] = ERROR_MATCH_ARRANGED (b_4,aa);
[error_6] = ERROR_MATCH_ARRANGED (b_5,aa);
[error_7] = ERROR_MATCH_ARRANGED (b_6,aa);
[error_8] = ERROR_MATCH_ARRANGED (b_7,aa);
[error_9] = ERROR_MATCH_ARRANGED (b_8,aa);
[error_10] = ERROR_MATCH_ARRANGED (b_9,aa);
[error_11] = ERROR_MATCH_ARRANGED (p_2,aa);
[error_12] = ERROR_MATCH_ARRANGED (p_3,aa);
[error_13] = ERROR_MATCH_ARRANGED (p_4,aa);
find_error_flag = 0;

end

if  find_error_flag == 0
   error_out = [error_1,error_2,error_3,error_4,error_5,error_6,error_7,error_8,error_9,error_10,error_11,error_12,error_13 ];
   e=min(error_out)
   aa
   
   if error_2 == e
       W = W1;
   elseif error_3 == e
       W = W2;
   elseif error_4 == e
       W = W3;
   elseif error_5 == e
       W=W4;
   elseif error_6 == e
       W=W5;
   elseif error_7 == e
       W=W6;
   elseif error_8 == e
       W = W7;
   elseif error_9 == e
       W = W8;
   elseif error_10 == e
       W = W9;
   else
       W = W_P;
   end

   if (var(aa) == 0 )  %% for good variance of aa
       e = 0.002;
   end
   
else
    e = 1000;
    note = ' variance is bad situation and is over max '
   
end  %% the end of find error flag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
e = OUT_ROAD ( aa , th_pixel_car , e , max_profile )
   
%%%% equal diffrential between right and left of point from edge %%%%%%%%%%%%%%%%%%%%%%%%%%
if  ( abs(e) < abs(e_opt) && ( edge_canny(r_2,c_2) < max_canny )  )
    
      %%% equal " C " :  for locate point on center of road
      [C , edge_canny_wide_C]  = DIFF_PROFILE ( r_prob , c_prob , fi , contrast_road ,  WMM);
      C
      flag_edge_canny = 0 ;
      %%% detect wrong point %%%
      %%% if earned point in hole situation
        if ( edge_canny_wide_C < ( edge_canny_wide ) ) && ( abs(fi-angle) > T_angle )
            C = 1000;
            flag_edge_canny = 1 ;
        end
      %%%%%%%%%%%%%%%%%%%%%%%%%
else
flag_edge_canny = 1 ;
note = ' bad error in this point or point in edge'
end  %% end edge_canny
         
%%%%%%%%%%%%%%%%

%% compairing mision and equal Z
if       flag_edge_canny == 0 ;

            note = ' new condidate point'
            Error(q)=e;
            Diff(q)=C;
            Row(q)=r_prob;
            Column(q)=c_prob;
            Angle(q)=fi;
            AA(q,:)=aa;
            q=q+1
end%%% the end of compairing mision

            
       
      end         %% the end of search for angle ( or fi ) 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      C_opt = C_optima;
      q=q-1;
        change_A   = angle_change;
              while ( q )
                   if ( Diff(q) < C_opt )
                       C_opt = Diff (q);
                       reg = q;
                   elseif ( Diff(q) == C_opt )
                       if ( abs(angle - Angle(q)) < change_A )
                           change_A = abs( angle - Angle(q));
                           C_opt = Diff (q);
                           reg = q;
                       end
                   end
                   q=q-1;
              end
              
              end   %% the end of bad error  ( reg == 0 )
      
       
              
                
                %%% optional state when error occrure%%%%
                regular1(yy) = reg;
                if reg == 0
                    figure(2)
                    imshow(uint8(y))
                    figure(1)
                    note = ' there dont found suit point and error occure '
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%

                  
                r_z = Row(reg)
                c_z = Column(reg)                                %% measurement point cordinate
                fi_z = Angle(reg)
           
                e_opt = Error(reg)
                C_opt = Diff(reg)
                
                angle_z = ( fi_z * pi )/180 ;             %%  angle change( degree to radian ) 

                ee(1,e56) = e;
                ee(2,e56) = fi_z;
                e56=e56+1;

                aa = AA(reg,:)
                
                
      %% change distance between point if angle change more than threshould
      
      if abs( abs(angle_old) - abs(fi_z) ) > th_angle_change
          note = ' angle change is more than maximmum'
    dt = dt_curve_road
    dtt = dt;

    %% first stage    ( prediction stage )
     %%%%%%% priori estimate and covariance of that %%%%%%%%%%%%
    
     x_p = [ r_optimum ; c_optimum ; angle_optimum ; fo_optimum ];   %%  past point  ( x(k-1) )
     
     zavie = angle+ dtt * (fo/2);
     f_k = [ 1, 0, (dtt*cosd ( zavie )) , (0.5*(dtt^2)* cosd (zavie ))  ; 0, 1, (-dtt*sind (zavie )) ,  (-0.5*(dtt^2)*sind ( zavie ))  ; 0, 0, 1, dtt ; 0, 0, 0, 1 ];       %% liniarization function ( system Dynamic )


     a_1=r_optimum - dtt*sind ( zavie );
     a_2=c_optimum + (dtt)* cosd (zavie );
     a_3=angle_optimum + dtt * (fo_optimum);
     a_4=fo_optimum;

                        %%%%%%% you should be choose 1 senario of below for
                        %%%%%%% priori estimate
                        
     x_manfi_k = [ a_1 ; a_2 ; a_3 ; a_4 ]                        %% first senario for priori estimate 
    % x_manfi_k = f_k * x_p  ;                                          %% second senario for priori estimate
     
     
     Q_k = [ 0.04*W 0 0 0 ; 0 0.04*W 0 0 ; 0 0 0.02 0 ; 0 0 0 0.01];            %% covariance of system ( first senario ) - in journal

%      Q_k =( sigma_fis ) * [ (( (dtt^4)/3 ) * ((cosd( angle ))^2)) , (( ( dtt^4 )/3 ) * sind ( angle ) * cosd ( angle ) )  ,  ( (( dtt^3 )/3 ) * cosd ( angle )) , 0  ;  
%          (( ( dtt^4 )/3 ) * sind ( angle ) * cosd ( angle ) ), (( (dtt^4)/3 ) * ((sind( angle ))^2)) ,   ( (( dtt^3 )/3 ) * sind ( angle))  ,  0  ; 
%          (((dtt^3)/3)*cosd(angle))  ,  (((dtt^3)/3)*sind(angle))  ,  (dtt^2)/3  ,  dtt/2  ; 
%          0 , 0  , dtt/2 , 1 ] ;                                                                        %% covariance of system ( second senario ) - in thesis
   
     p_manfi_k = (f_k * p_k_0 *  transpose ( f_k ))+Q_k   %% covariance of priori state
     
     
     %% second stage ( measurment )
     %%%%%%%%% generate measurment for fusion with priori estimate and use in update stage
     %%%( 3-1 algorithm in thesis )
     
     %%% step1 : use x( k-1 ) that generated in last step
     %%% step 2 :  create set of probable point and angle
     
    e_opt = e_optimum;                                 %% initial measurement error
    C_opt=C_optima;                                   %% i assumed that my first wide of road is ....
    q=1;
    AA=1:M_P;
    reg = 0 ; 
    p_com_angle = 1000;

    
      for fi = ( angle -angle_change ) : 1 : ( angle + angle_change)
          
              find_error_flag = 1;         %% flag for detect bad var and cov  ( flag = 0 is right )
              flag_edge_canny = 1 ;           %%%% flag for edge_canny value... if edge_canny value in condidate point is more than maximmum edge_canny ( constant value that we set first initial)
                                                    %%%% flag set 1 and we
                                                     %%%% remove condidate
                                                     %%%% point continue
                                                     %%%% search again

    
    r_prob =  r_optimum - dt * sind ( fi ) ;   
    c_prob =  c_optimum + dt * cosd ( fi );             %% measurement cordinate point
    
    r_2= round ( r_optimum - dt * sind ( fi )) 
    c_2 = round ( c_optimum + dt * cosd ( fi ))
    fi
    
   
    
    %%
    %%%% profile matching %%%%
    
      aa=ORIGINAL_MATCH(r_prob , c_prob , fi)    
      
       %%% check ingredient %%%%%
      [ var_max ] = CHOOSE_OPTIMUM_VAR_MAX( aa , p_1 , p_2, p_3 , p_4 , b_1 , b_2 , b_3 , b_4 , b_5 , b_6 , b_7 , b_8 , b_9 , var_mean_good , var_mean_bad );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     %%% algorithm for check exist car %%%%%%%%%%  
        if ( var(aa) > var_max)
               aa = CAR( aa ,th_car , p_1 , th_pixel_car , th_first_dis_edge_car , th_end_dis_edge_car , max_gay_prof_car )
           end
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%% error find %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
      if var(aa) > var_max  
                if aa < mean(p_1)
                    var(aa) = var(p_1);
                end
      end

      
if ( var(aa) < var_max ) 
[error_1] = ERROR_MATCH_ARRANGED (p_1,aa);
[error_2] = ERROR_MATCH_ARRANGED (b_1,aa);
[error_3] = ERROR_MATCH_ARRANGED (b_2,aa);
[error_4] = ERROR_MATCH_ARRANGED (b_3,aa);
[error_5] = ERROR_MATCH_ARRANGED (b_4,aa);
[error_6] = ERROR_MATCH_ARRANGED (b_5,aa);
[error_7] = ERROR_MATCH_ARRANGED (b_6,aa);
[error_8] = ERROR_MATCH_ARRANGED (b_7,aa);
[error_9] = ERROR_MATCH_ARRANGED (b_8,aa);
[error_10] = ERROR_MATCH_ARRANGED (b_9,aa);
[error_11] = ERROR_MATCH_ARRANGED (p_2,aa);
[error_12] = ERROR_MATCH_ARRANGED (p_3,aa);
[error_13] = ERROR_MATCH_ARRANGED (p_4,aa);
find_error_flag = 0;

end

if  find_error_flag == 0
   error_out = [error_1,error_2,error_3,error_4,error_5,error_6,error_7,error_8,error_9,error_10,error_11,error_12,error_13 ];
   e=min(error_out)
   aa
   
   if error_2 == e
       W = W1;
   elseif error_3 == e
       W = W2;
   elseif error_4 == e
       W = W3;
   elseif error_5 == e
       W=W4;
   elseif error_6 == e
       W=W5;
   elseif error_7 == e
       W=W6;
   elseif error_8 == e
       W = W7;
   elseif error_9 == e
       W = W8;
   elseif error_10 == e
       W = W9;
   else
       W = W_P;
   end

   if (var(aa) == 0 )  %% for good variance of aa
       e = 0.002;
   end
   
else
    e = 1000;
    note = ' variance is bad situation and is over max '
   
end  %% the end of find error flag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
e = OUT_ROAD ( aa , th_pixel_car , e , max_profile )
   
%%%% equal diffrential between right and left of point from edge %%%%%%%%%%%%%%%%%%%%%%%%%%
if  ( abs(e) < abs(e_opt) && ( edge_canny(r_2,c_2) < max_canny )  )
    
      %%% equal " C " :  for locate point on center of road
      [C , edge_canny_wide_C]  = DIFF_PROFILE ( r_prob , c_prob , fi , contrast_road ,  WMM);
      C
      flag_edge_canny = 0 ;
      %%% detect wrong point %%%
      %%% if earned point in hole situation
        if ( edge_canny_wide_C < ( edge_canny_wide ) ) && ( abs(fi-angle) > T_angle )
            C = 1000;
            flag_edge_canny = 1 ;
        end
      %%%%%%%%%%%%%%%%%%%%%%%%%
else
flag_edge_canny = 1 ;
note = ' bad error in this point or point in edge'
end  %% end edge_canny
         
%%%%%%%%%%%%%%%%

%% compairing mision and equal Z
if       flag_edge_canny == 0 ;

            note = ' new condidate point'
            Error(q)=e;
            Diff(q)=C;
            Row(q)=r_prob;
            Column(q)=c_prob;
            Angle(q)=fi;
            AA(q,:)=aa;
            q=q+1
end%%% the end of compairing mision

            
       
      end         %% the end of search for angle ( or fi ) 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      C_opt = C_optima;
      q=q-1;
        change_A   = angle_change;
              while ( q )
                   if ( Diff(q) < C_opt )
                       C_opt = Diff (q);
                       reg = q;
                   elseif ( Diff(q) == C_opt )
                       if ( abs(angle - Angle(q)) < change_A )
                           change_A = abs( angle - Angle(q));
                           C_opt = Diff (q);
                           reg = q;
                       end
                   end
                   q=q-1;
              end
              
              
      
                   
              
             %% if error of road more than normal_error i assume between normal error and max error  
              if (reg == 0)
                  
                    e_opt = e_optimum + error_margin                                 %% initial measurement error
                    C_opt=C_optima;                                %% i assumed that my first wide of road is ....
                    q=1;
                    AA=1:M_P;
                    reg = 0 ; 
                    note = ' bad error and increase maximum error '
                    

                    
                    for fi = ( angle -angle_change ) : 1 : ( angle + angle_change)
          
              find_error_flag = 1;         %% flag for detect bad var and cov  ( flag = 0 is right )
              flag_edge_canny = 1 ;           %%%% flag for edge_canny value... if edge_canny value in condidate point is more than maximmum edge_canny ( constant value that we set first initial)
                                                    %%%% flag set 1 and we
                                                     %%%% remove condidate
                                                     %%%% point continue
                                                     %%%% search again

    
    r_prob =  r_optimum - dt * sind ( fi ) ;   
    c_prob =  c_optimum + dt * cosd ( fi );             %% measurement cordinate point
    
    r_2= round ( r_optimum - dt * sind ( fi )) 
    c_2 = round ( c_optimum + dt * cosd ( fi ))
    fi
    
   
    
    %%
    %%%% profile matching %%%%
    
      aa=ORIGINAL_MATCH(r_prob , c_prob , fi)    
      
       %%% check ingredient %%%%%
      [ var_max ] = CHOOSE_OPTIMUM_VAR_MAX( aa , p_1 , p_2, p_3 , p_4 , b_1 , b_2 , b_3 , b_4 , b_5 , b_6 , b_7 , b_8 , b_9 , var_mean_good , var_mean_bad );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     %%% algorithm for check exist car %%%%%%%%%%  
        if ( var(aa) > var_max)
               aa = CAR( aa ,th_car , p_1 , th_pixel_car , th_first_dis_edge_car , th_end_dis_edge_car , max_gay_prof_car )
           end
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%% error find %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
      if var(aa) > var_max  
                if aa < mean(p_1)
                    var(aa) = var(p_1);
                end
      end

      
if ( var(aa) < var_max ) 
[error_1] = ERROR_MATCH_ARRANGED (p_1,aa);
[error_2] = ERROR_MATCH_ARRANGED (b_1,aa);
[error_3] = ERROR_MATCH_ARRANGED (b_2,aa);
[error_4] = ERROR_MATCH_ARRANGED (b_3,aa);
[error_5] = ERROR_MATCH_ARRANGED (b_4,aa);
[error_6] = ERROR_MATCH_ARRANGED (b_5,aa);
[error_7] = ERROR_MATCH_ARRANGED (b_6,aa);
[error_8] = ERROR_MATCH_ARRANGED (b_7,aa);
[error_9] = ERROR_MATCH_ARRANGED (b_8,aa);
[error_10] = ERROR_MATCH_ARRANGED (b_9,aa);
[error_11] = ERROR_MATCH_ARRANGED (p_2,aa);
[error_12] = ERROR_MATCH_ARRANGED (p_3,aa);
[error_13] = ERROR_MATCH_ARRANGED (p_4,aa);
find_error_flag = 0;

end

if  find_error_flag == 0
   error_out = [error_1,error_2,error_3,error_4,error_5,error_6,error_7,error_8,error_9,error_10,error_11,error_12,error_13 ];
   e=min(error_out)
   aa
   
   if error_2 == e
       W = W1;
   elseif error_3 == e
       W = W2;
   elseif error_4 == e
       W = W3;
   elseif error_5 == e
       W=W4;
   elseif error_6 == e
       W=W5;
   elseif error_7 == e
       W=W6;
   elseif error_8 == e
       W = W7;
   elseif error_9 == e
       W = W8;
   elseif error_10 == e
       W = W9;
   else
       W = W_P;
   end

   if (var(aa) == 0 )  %% for good variance of aa
       e = 0.002;
   end
   
else
    e = 1000;
    note = ' variance is bad situation and is over max '
   
end  %% the end of find error flag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
e = OUT_ROAD ( aa , th_pixel_car , e , max_profile )
   
%%%% equal diffrential between right and left of point from edge %%%%%%%%%%%%%%%%%%%%%%%%%%
if  ( abs(e) < abs(e_opt) && ( edge_canny(r_2,c_2) < max_canny )  )
    
      %%% equal " C " :  for locate point on center of road
      [C , edge_canny_wide_C]  = DIFF_PROFILE ( r_prob , c_prob , fi , contrast_road ,  WMM);
      C
      flag_edge_canny = 0 ;
      %%% detect wrong point %%%
      %%% if earned point in hole situation
        if ( edge_canny_wide_C < ( edge_canny_wide ) ) && ( abs(fi-angle) > T_angle )
            C = 1000;
            flag_edge_canny = 1 ;
        end
      %%%%%%%%%%%%%%%%%%%%%%%%%
else
flag_edge_canny = 1 ;
note = ' bad error in this point or point in edge'
end  %% end edge_canny
         
%%%%%%%%%%%%%%%%

%% compairing mision and equal Z
if       flag_edge_canny == 0 ;

            note = ' new condidate point'
            Error(q)=e;
            Diff(q)=C;
            Row(q)=r_prob;
            Column(q)=c_prob;
            Angle(q)=fi;
            AA(q,:)=aa;
            q=q+1
end%%% the end of compairing mision

            
       
      end         %% the end of search for angle ( or fi ) 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      C_opt = C_optima;
      q=q-1;
        change_A   = angle_change;
              while ( q )
                   if ( Diff(q) < C_opt )
                       C_opt = Diff (q);
                       reg = q;
                   elseif ( Diff(q) == C_opt )
                       if ( abs(angle - Angle(q)) < change_A )
                           change_A = abs( angle - Angle(q));
                           C_opt = Diff (q);
                           reg = q;
                       end
                   end
                   q=q-1;
              end
              
end   %% the end of bad error  ( reg == 0 )
      
       
              
                
                %%% optional state when error occrure%%%%
                regular1(yy) = reg;
                if reg == 0
                    figure(2)
                    imshow(uint8(y))
                    figure(1)
                    note = ' there dont found suit point and error occure '
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%

                  
                r_z = Row(reg)
                c_z = Column(reg)                                %% measurement point cordinate
                fi_z = Angle(reg)
           
                e_opt = Error(reg)
                C_opt = Diff(reg)
                
                angle_z = ( fi_z * pi )/180 ;             %%  angle change( degree to radian ) 

                ee(1,e56) = e;
                ee(2,e56) = fi_z;
                e56=e56+1;

                aa = AA(reg,:)
      end
  
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      z = [ r_z ; c_z ; angle_z ]   %%measurment point
      sigma_fio = ( (pi/30) * (1 + e_opt ))^2;   %%variance of measurment

        
     
   %% third stage  ( update stage )
   %%%%%% fusion priori estimate and measurment for equal posteriori
   %%%%%% estimate and final covariance
   
    h = [1 0 0 0 ; 0 1 0 0 ; 0 0 1 0  ];
    I = [ 1 0 0 0 ; 0 1 0 0 ; 0 0 1 0 ; 0 0 0 1 ];                                         %% define

    R_k = sigma_fio * [  0.4*W 0 0 ; 0 0.4*W 0 ; 0 0 1 ];                      %% measurment covariance ( first senario ) - in journal
    
%     R_k = [ ((dtt^2)* (sigma_fio) * ( ( (cosd ( fi_z ))^2 ))) , 0 , 0  ;
%                    0 , ((dtt^2)* (sigma_fio) * ( ( (sind ( fi_z ))^2 ))) , 0  ; 
%                    0 , 0 , ( sigma_fio  )  ]  ;                                                   %% measurment covariance ( second senario ) - in thesis
    h * p_manfi_k *  transpose (h ); 
    R_k;
      p_manfi_k * transpose( h );
     k_k = p_manfi_k * transpose( h ) * inv(( h * p_manfi_k *  transpose (h )) + R_k )    %% kalman Gain
     
      x_k = x_manfi_k + k_k * ( z - h*x_manfi_k )                                %% posteriori estimate
      
      p_k_0 = ( I - ( k_k * h ))* p_manfi_k ;                                          %% covariance
      
      
      %%%%%%%%%%%%%%%%%%%%%%  result %%%
 r_optimum =  x_k ( 1 );
 c_optimum = x_k ( 2 );
 angle_optimum =x_k(3);
 fo_optimum =x_k(4);                                 %% cordinate of new estimate ( x(k) )
 
 fo = ( fo_optimum * 180 )/ pi  ;
 angle = ( angle_optimum * 180) / pi  ;          %%  angle change( radian to degree )
 angle_old = angle;
 
 y(round(r_optimum) , round(c_optimum)) = 255;
 
ee(3,yy)=c_z;
ee(4,yy)=x_manfi_k(2);
ee(5,yy)=c_optimum;


ee(6,yy)=r_z;
ee(7,yy)=x_manfi_k(1);
ee(8,yy)=r_optimum;

 %% fourth stage  ( update reference profile ) 
   [ b_1 , b_2 , b_3 , b_4 , b_5 , b_6 , b_7 , b_8 , b_9 , W1 , W2 , W3 , W4 , W5 , W6 , W7 , W8 , W9  ] = CLUSTER_FIND (p_1, b_1 , b_2 , b_3 , b_4 , b_5 , b_6 , b_7 , b_8 , b_9 , W1 , W2 , W3 , W4 , W5 , W6 , W7 , W8 , W9 , r_optimum , c_optimum , angle , contrast_road , WMM , contrast_match , C_max_cluster , var_max_cluster , CSM )

  

%% display result image

if (round(c_optimum) == 636) && ( round(r_optimum) == 1900   )
    break
    note = 'break'
end
 
 yy= yy+1;

 end

 figure(2)
imshow ( uint8(y))
pause