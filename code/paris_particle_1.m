%%
%%%%%%  create image and smooth that %%%%%%%%%%%%
clc;clear all;
a=imread  ( 'E:\internet\uni\proje\matlab\Paris.jpg');    %%---**---%%
b=rgb2gray(a);
x=double(b);

mask = ( 1/115) * [ 2 4 5 4 2 ; 4 9 12 9 4 ; 5 12 15  12  5 ; 4 9 12 9 4 ; 2 4 5 4 2 ]
x= conv2(mask , x);       %% softening image
y=x;
z=x;
tiz=x;

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
 end_particle=100;
 p=0;
 
 W=3;    
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
  P_0 = 5*Q_0 * [ 1; 1;1;1];
  N=8*W;
  x_0 = [ r_optimum ; c_optimum ; angle_optimum ; 0 ];   %%  past point  ( x(k-1) )
  samp(1,:) = normrnd( x_0(1)-N/2 : x_0(1) + N/2 , P_0(1)  )
  samp(2,:) = normrnd( x_0(2)-N/2 : x_0(2) + N/2 , P_0(2)  )
  samp=transpose(samp)  %% samp( x(k)_i  )
    
  

  p_1 =[ 53 54 49  ];        %% initialize reference profile                  %%---**---%%
  m=max(p_1);
  k=0;
  for i=1:N+1       %%  N+1=size sample
      for j=1:N+1
       
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
         
         
          weight(k)=1/N;
          
      else
         r= x(round(samp(i,1)),round(samp(j,2)));
          
      end
      
     end
  end


 
  
  
   figure(1)   %% original random
  imshow(uint8(z))   

  figure(2)  %% eliminate random
  imshow(uint8(y))
  
 
 
 %% step 2
 
 for time = 1:end_particle
 tiz=x;
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
 for i=1:k
  s_new(i,1)=normpdf(x_0(1),f_k_priori(i,1),P_0(1));
  s_new(i,2)=normpdf(x_0(2),f_k_priori(i,2),P_0(2));
  samp_new(i,1) = f_k_priori(i,1) +  s_new(i,1);
  samp_new(i,2) = f_k_priori(i,2) +  s_new(i,2);
 
  
 
          
          sample_number =sample_number + 1 
          
          sample_new(i,1) = f_k_priori(i,1) +  s_new(i,1);
          sample_new(i,2) = f_k_priori(i,2) +  s_new(i,2);
          d=(sample_new(i,2) - particle_new_column ) / sqrt(( (sample_new(i,1) - particle_new_row  )^2 ) + ( (sample_new(i,2) - particle_new_column ) ^2 ) );
          angle_sample_new = asind(d);
          sample(i,3) =  ( angle_sample_new * pi )/180 ;  
          sample(i,4) = 0;
          angle_sample(i,3) = ( sample(i,3) * 180 )/ pi  ;
          fo_sample(i,4) = ( sample(i,4) * 180) / pi  ;
          weight_particle(i) = 1/sample_number;      %% thats true because my sample now have sample_number ( not N or k )
          tiz(round(sample_new(i,1)),round(sample_new(i,2))) = 255;
    
 
 
 end

     k=sample_number
     particle_new_row = 0;
     particle_new_column = 0;
     for i=1:k
         particle_new_row=particle_new_row + (  weight_particle(i) * sample_new(i,1));
         particle_new_column=particle_new_column + (  weight_particle(i) * sample_new(i,2));
         
     end

     a_1=r_optimum - dtt*sind ( zavie );
     a_2=c_optimum + (dtt)* cosd (zavie );
     a_3=angle_optimum + dtt * (fo_optimum);
     a_4=fo_optimum;

                                         
     x_manfi_k = [ a_1 ; a_2 ; a_3 ; a_4 ]   
     

   
     
  
  figure(3)  %% eliminate random
  imshow(uint8(tiz ))
  
 end
 
 
 
 
 
 
 
 
 
 
 