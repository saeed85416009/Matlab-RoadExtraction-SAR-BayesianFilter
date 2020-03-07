clc;clear all;
global x 
global edge_canny  
global M
global N 
global clusterring 
global test_number
global class_number
global sample_t



a=imread  ( 'E:\internet\uni\proje\matlab\Paris.jpg');    %%---**---%%
b=rgb2gray(a);
x=double(b);
level = graythresh(uint8(x));
level = im2uint8(level)





mask = ( 1/115) * [ 2 4 5 4 2 ; 4 9 12 9 4 ; 5 12 15  12  5 ; 4 9 12 9 4 ; 2 4 5 4 2 ]
x= conv2(mask , x);       %% softening image
x=imadjust(uint8(x), [0 1], [0 1]);
x=double(x);


y=x;
t=x;                  %% use for canny edge detector and find best distance between edge 
[M , N ] =size(t);

for i= 1:M                     %% i know that road in dark position isnt more than ... gray level therfor i assume gray level of image is max in non road  
    for j=1:N
        if x(i,j) > 70            %%---**---%%
            t(i,j) = 255;
        end
    end
end
y=x;
z=x;
tiz=x;
class1=x;
class2=x;
 %%%%%%%%%%%%%%%%%%%  canny edge detector %%%%%%%%%%%%%%%%%%%%%%
edge_canny = EDGE_FND_SOBEL ( t );
figure (1)
imshow(uint8(edge_canny))
 
 %%% regulator parameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%% initialize point %%%%%%%%%%%%%
%%%%%% initialize road %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt_right_road= sqrt (4);             %% distance between point in righ road when angle has soft change   %%---**---%%
dt_curve_road = sqrt(4);             %% distance between point in curve road when angle has big change   %%---**---%%

dt=dt_right_road;                        %% distance between point in first point
dtt=dt;

 r_optimum = 106 ;                       %% initialize row for priori estimate   (pixel)                    %%---**---%%
 c_optimum = 154;                         %% initialize column for  priori estimate (pixel)                %%---**---%%
 particle_new_row = r_optimum ;
particle_new_column = c_optimum ; 

 angle =45 ;                                                                                                %%---**---%%
 angle_old = angle;
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road
 fo = 0;
 fo_optimum = fo;
 end_particle=1;
 p=0;
 contrast_road = 250;                  %% firm value for road contrast in edge_canny state for moving in point ( gray level )
 
 
 W=3;
 WMM = 2*W;                           %% Wide Margin for Matching   
 
 th_angle_particle = 5; %degree
 th_distance_clusterring = 8;
 th_angle_new_point = 90;  %%degree
 th_forward_dis = 20;  %%distance
 th_angle_merge_cluster = th_angle_particle ;  %degree
 th_angle_measurement = th_angle_particle;
 gray_class =255;
 B=1;
 test_number =0;
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
  samp(1,:) = normrnd( x_0(1)-sample_number/2 : x_0(1) + sample_number/2 , P_0(1)  )
  samp(2,:) = normrnd( x_0(2)-sample_number/2 : x_0(2) + sample_number/2 , P_0(2)  )
  samp=transpose(samp)  %% samp( x(k)_i  )
    
  

  p_1 =[ 53 54 49  ];        %% initialize reference profile                  %%---**---%%
  m=max(p_1);
  k=0;
  for i=1:sample_number+1       %%  N+1=size sample
      for j=1:sample_number+1
       
        z(round(samp(i,1)),round(samp(j,2))) = 255;  
        
      if( x(round(samp(i,1)),round(samp(j,2))) <=  m )  %% eliminate rand point of out road 
          k=k+1;
          y(round(samp(i,1)),round(samp(j,2))) = 255;
          sample(k,1)=samp(i,1);
          sample(k,2)=samp(j,2);
          
          d(1) = sample(k,1);
          d(2) = sample(k,2);
          e(1) = particle_new_row;
          e(2) = particle_new_column;
          angle_sample_new = ANGLE_FIND (d , e );
          
%           d=abs((sample(i,1) - particle_new_row)/(sample(i,2) - particle_new_column));
%           if (sample(i,2)>  particle_new_column ) && ( sample(i,1) > particle_new_row )
%               angle_sample_new = atand(d);
%           elseif (sample(i,2)<  particle_new_column ) && ( sample(i,1) > particle_new_row )
%               angle_sample_new = atand(d)+90;
%           elseif (sample(i,2)<  particle_new_column ) && ( sample(i,1) < particle_new_row )
%               angle_sample_new = atand(d)+180;
%           elseif (sample(i,2) >  particle_new_column ) && ( sample(i,1)< particle_new_row )
%               angle_sample_new = atand(d)+270;
%           end
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
 [clusterring , sample_for_cluster , flag_find_clusterring ] = CLUSTERRING_OPTIMUM_2 (sample_for_cluster  , clusterring , sample_for_cluster , x_0 , angle , th_angle_particle, th_distance_clusterring , class_number );
  

      
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
 [ x_new , flag_find_new_point , angle] = FIND_SOURCE_POINT_FOR_NEW_CLUSTER ( remain_clusterring , clusterring ,  x_0 , th_angle_new_point , 1 , th_forward_dis , th_angle_particle );
 
    if flag_find_new_point ~= 0
        th_angle_new_point_negative = - th_angle_new_point;
        [ x_new , flag_find_new_point , angle  ] = FIND_SOURCE_POINT_FOR_NEW_CLUSTER ( remain_clusterring , clusterring , x_0 , th_angle_new_point_negative , -1 , th_forward_dis , th_angle_particle );
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
 [clusterring , sample_for_cluster , flag_find_clusterring ] = CLUSTERRING_OPTIMUM_2 (remain_clusterring  , clusterring , sample_for_cluster , x_new , angle , th_angle_particle, th_distance_clusterring , class_number );
end
     
  
%  class_number = class_number
%  size(clusterring)
%  size(remain_clusterring)
%  size(sample_for_cluster)
%  
 

 end
 
 
 

 AVG_ANGLE_CLUSTER ()
 MERGE_CLUSTER( th_angle_merge_cluster )
 SAMPLE_TOTAL_FIRST_STEP()
 
 note='end'
 pause

 
 
 
 
 
 
 %% step 2
 
 for time = 1:end_particle
 
     
     
 %% update particle    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 tiz=x;
 %k=sample_number
 sample_number = 0;
 
  
  for i =1 : k
     zavie = angle_sample(i,3)+ dtt * (fo_sample(i,4) /2);
     f_k_priori(i,1)=sample(i,1) - dtt*sind ( zavie );
     f_k_priori(i,2)=sample(i,2)  + (dtt)* cosd (zavie );
     f_k_priori(i,3)=sample(i,3)  + dtt * (sample(i,4) );
     f_k_priori(i,4)=sample(i,4) ;
  end
%   f_k_priori = transpose(f_k_priori);
  
%  for i=1:k
%      sample_new(:,:,i) = mvnpdf(x_0,f_k_priori(:,i),sigma)
%  end
%  
 
% P_0_new=50*Q_0;
%  sample_new=mvnpdf(f_k_priori,transpose(x_0),P_0_new)


%%% x_k(i) = f_k(x_k(i)) + N ( x_k ; f_k(x_k(i)) , p_k )
 for i=1:k %% generate sample
     if sample(i,1)>0
              s_new(i,1)=normpdf(particle_new_row,f_k_priori(i,1),P_0(1));
              s_new(i,2)=normpdf(particle_new_column,f_k_priori(i,2),P_0(2));
              samp(i,1) = f_k_priori(i,1) +  s_new(i,1);
              samp(i,2) = f_k_priori(i,2) +  s_new(i,2);
     else
              samp(i,1) = 1;
              samp(i,2) =1;
     end
  
    if( x(round(samp(i,1)),round(samp(i,2))) <=  m ) && ( samp(i,1) > 1)  %% eliminate rand point of out road 
          
          sample_number =sample_number + 1 
          
          sample(i,1) = f_k_priori(i,1) +  s_new(i,1);
          sample(i,2) = f_k_priori(i,2) +  s_new(i,2);
          %%%%%%%% create angle %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         d(1) = sample(i,1);
          d(2) = sample(i,2);
          e(1) = particle_new_row;
          e(2) = particle_new_column;
          angle_sample_new = ANGLE_FIND (d , e );
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          sample(i,3) =  ( angle_sample_new * pi )/180 ;  
          sample(i,4) = 0;
          angle_sample(i,3) = ( sample(i,3) * 180 )/ pi  ;
          fo_sample(i,4) = ( sample(i,4) * 180) / pi  ;
          
          
          tiz(round(sample(i,1)),round(sample(i,2))) = 255;
    else
        sample(i,1)=0;
        sample(i,2)=0;
        sample(i,3)=0;
        sample(i,4)=0;
    end

 end%%end generate sample
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% measurment of each particle %%%%%%%%%%%%%%
 for j=1: k
     
     if  ( sample(j,1) ~= 0 )
                 if edge_canny(round(sample(j,1)),round(sample(j,2)) )< contrast_road 
                     angle_sample = sample(j,3)*180/pi;
                     [z_particle(j,1) , z_particle(j,2) , z_particle(j,4)] = MEASUREMENT_PARTICLE(sample(j,1) , sample(j,2)  , contrast_road , WMM , angle_sample , th_angle_measurement    );
                     z_particle(j,3) = sample(j,3); 
                 else
                      z_particle(j,1) = 1; %% if sample = 0 --> z = inf
                      z_particle(j,2) = 1; 
                      z_particle(j,3) = 1; 
                      z_particle(j,4) = 1; 
                 end
     else
         z_particle(j,1) = 2; %% if sample = 0 --> z = inf
         z_particle(j,2) = 2; 
         z_particle(j,3) = 2; 
         z_particle(j,4) =2; 
     end
     
 
     particle_inf(j,1) = sample(j,1);
     particle_inf(j,2) = sample(j,2);
     particle_inf(j,3) = sample(j,3);
     particle_inf(j,4) = sample(j,4);
     particle_inf(j,5) = z_particle(j,1);
     particle_inf(j,6) = z_particle(j,2);
     particle_inf(j,7) = z_particle(j,3);
     particle_inf(j,8) = z_particle(j,4);
      note = '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% assign weight to particle 

for j=1:k
    z_m(j,1) = z_particle(j,1);
    z_m(j,2) = z_particle(j,2);
    z_m(j,3) = z_particle(j,3);
    
    x_i(j,1) = sample(j,1);
    x_i(j,2) = sample(j,2);
    x_i(j,3) = sample(j,3);
end

sum_weight=0;
cons_weight = 1/( ((2*pi)^1.5) * (det( R_k )^0.5) );
 for j=1:k %% assign weight to sample
          
      
          distance(j) = (z_m(j,:) - x_i(j,:) ) * inv(R_k) *transpose(z_m(j,:) - x_i(j,:) ) ;
          weight_particle(j) = weight_priori(j) * cons_weight * exp( -distance(j)/2 );      %% thats true because my sample now have sample_number ( not N or k )
          sum_weight = sum_weight + weight_particle(j);
 end 
 
 for j=1:k %% normalize weight
     weight_particle(j) = weight_particle(j)/sum_weight;
 end

 weight_priori = weight_particle; 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% clusterring --------------------------------------------------%%%
 
 s_s = size(sample);
 ss_c=0;
 for ss = 1:s_s(1)
     
     if sample(ss,1) ~= 0
        ss_c = ss_c+1; 
        sample_for_cluster (ss_c , 1 ) = sample(ss,1);
        sample_for_cluster (ss_c , 2 ) = sample(ss,2);
        sample_for_cluster (ss_c , 3 ) = sample(ss,3);
        sample_for_cluster (ss_c , 4 ) = sample(ss,4);
     end
     
 end
 
 [clusterring , TEST] = CLUSTERRING_OPTIMUM (sample_for_cluster , th_angle_particle, th_distance_clusterring )
 figure(4)
 B=size(clusterring);
 for i =1:B
     
          class2(round(clusterring(i,2)) , round(clusterring(i,3) ) ) = 255;
 end
 imshow(uint8(class2))
 
 %%     create final x from sample and its weight
     particle_new_row = 0;
     particle_new_column = 0;
     for f=1:k  %% create final x from sample and its weight
         particle_new_row=particle_new_row + (  weight_particle(f) * sample(f,1));
         particle_new_column=particle_new_column + (  weight_particle(f) * sample(f,2));
         
     end %% end create final x from sample and its weight

 
     

   
     
  
  figure(5)  %% eliminate random
  imshow(uint8(tiz ))
  
 end
 
 
 
 
 
 
 
 
 
 
 