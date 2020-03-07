clc;clear all;
global x 
global edge_canny  
global match_wide
global M
global N 
global cluster 
global max_profile


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

 r_optimum = 94 ;                       %% initialize row for priori estimate   (pixel)                    %%---**---%%
 c_optimum = 166;                         %% initialize column for  priori estimate (pixel)                %%---**---%%
 particle_new_row = r_optimum ;
particle_new_column = c_optimum ; 

 angle =45 ;                                                                                                %%---**---%%
 angle_old = angle;
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road
 fo = 0;
 fo_optimum = fo;
 end_particle=2;
 p=0;
 contrast_road = 250;                  %% firm value for road contrast in edge_canny state for moving in point ( gray level )
 
 
 W=3;
 WMM = 2*W;                           %% Wide Margin for Matching   
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
          
          d=(samp(j,2) - c_optimum ) / sqrt(( (samp(i,1) - r_optimum  )^2 ) + ( (samp(j,2) - c_optimum ) ^2 ) );
          angle_sample_new = asind(d);
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
 
 sample_number = k ; %%dont toch this thats true
  
  
   figure(1)   %% original random
  imshow(uint8(z))   

  figure(2)  %% eliminate random
  imshow(uint8(y))
  
 
 
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
          d=(sample(i,2) - particle_new_column ) / sqrt(( (sample(i,1) - particle_new_row  )^2 ) + ( (sample(i,2) - particle_new_column ) ^2 ) );
          angle_sample_new = asind(d);
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
                     [z_particle(j,1) , z_particle(j,2) , z_particle(j,3)] = MEASUREMENT_PARTICLE(sample(j,1) , sample(j,2)  , contrast_road , WMM    );
                 else
                      z_particle(j,1) = 10000000000000; %% if sample = 0 --> z = inf
                      z_particle(j,2) = 10000000000000; 
                      z_particle(j,3) = 10000000000000; 
                 end
     else
         z_particle(j,1) = 10000000000000; %% if sample = 0 --> z = inf
         z_particle(j,2) = 10000000000000; 
         z_particle(j,3) = 10000000000000; 
     end
     
 
     particle_inf(j,1) = sample(j,1);
     particle_inf(j,2) = sample(j,2);
     particle_inf(j,3) = sample(j,3);
     particle_inf(j,4) = sample(j,4);
     particle_inf(j,5) = z_particle(j,1);
     particle_inf(j,6) = z_particle(j,2);
     particle_inf(j,6) = z_particle(j,3);
      note = '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% assign weight to particle 

sum_weight=0;
cons_weight = 1/( ((2*pi)^1.5) * (det( R_k )^0.5) );
 for j=1:k %% assign weight to sample
          
          distance = sqrt( (( sample(j,1)-z_particle(j,1) )^2) + (( sample(j,2)-z_particle(j,2) )^2) );
          weight_particle(j) = weight_priori(j) * cons_weight * exp( -distance/2 );      %% thats true because my sample now have sample_number ( not N or k )
          sum_weight = sum_weight + weight_particle(j);
 end 
 
 for j=1:k %% normalize weight
     weight_particle(j) = weight_particle(j)/sum_weight;
 end

 weight_priori = weight_particle; 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%     create final x from sample and its weight
     particle_new_row = 0;
     particle_new_column = 0;
     for f=1:k  %% create final x from sample and its weight
         particle_new_row=particle_new_row + (  weight_particle(f) * sample(f,1));
         particle_new_column=particle_new_column + (  weight_particle(f) * sample(f,2));
         
     end %% end create final x from sample and its weight

 
     

   
     
  
  figure(3)  %% eliminate random
  imshow(uint8(tiz ))
  
 end
 
 
 
 
 
 
 
 
 
 
 