

%%
%%%%%%  create image and smooth that %%%%%%%%%%%%
clc;clear all;

a=imread  ( 'E:\internet\uni\proje\matlab\Paris.jpg');
b=rgb2gray(a);
x=double(b);


global x ;
global gradient ; 
global y ;
global match_wide;
CUT_IMAGE_PARIS_3()




figure(2)
imshow(uint8(x))

y = x;  


 
 %% 
 %%%%%%%% algorithm %%%%%%%%%%%
 
 
 %%
%%%%%% initialize point %%%%%%%%%%%%%



dt= sqrt (10);
dtt=dt;                                          %% lenght of step (distance)

 r_optimum = 270 ;                       %% initialize row for priori estimate   (pixel)
 c_optimum = 26;                         %% initialize column for  priori estimate (pixel)
 r_opt = r_optimum ;
c_opt = c_optimum ; 

 angle =45 ;                                        %% initialize angle of road ( degree )
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road ( radian )
 
 W=5;                                            %% initialize road wide ( pixel )
 W_P=W;  
 W1=W_P; W2 = W_P; W3 = W_P; W4 = W_P;  W5 = W_P; W6 = W_P; W7 = W_P; W8 = W_P ; W9 = W_P; W10 = W_P;

 
 fo_optimum = 0.000001 ;
 fo = fo_optimum;                       %% initialize change in the road direction ( degree )
 
 p_k_0 = 0.0001;                         %% initialize covariance matrice
 
 %%%%%%%%%%% initialize reference profile
 p_1 =[43 43 44 39 42 ];
 weight = [ 3 6 10 6 3 ];
 
 if ( p_1 - 10 > 0 )
 p_2 = p_1 -10;
 end

 if ( p_1 - 20 > 0 )
 p_3 = p_1 -20;
 end
 
 if ( p_1 -30 >0 )
 p_4 = p_1 - 30;
 end
 %%%%%%%%%%%%%%%%%%%
 
 
 b_1 = [ 2550 2550 2550 2550 2550  ];
 b_2 = b_1; b_3 = b_1 ; b_4 =b_1; b_5 = b_1 ; b_6 = b_1; b_7 = b_1; b_8 = b_1 ; b_9 = b_1;
 
   sigma_fis = (1/88)^2;           %% variance af system noise
 % sigma_fis = 0;                           %% variance af system noise
 
 [ M,N] = size(x);
 cluster = 1;                                %% inialial cluster
 contrast_match = 80;                %% firm value for cluster contrast (gray level )
 angle_change = 30;                   %% angle change for find best condidate ( degree )
 CSM = 3;                                   %% Cluster Similarity Modify ( regulation similarity between clusters )  ( pixel )
 match_wide = 2;                        %% wide of profile matching 
 WMM = 2*W;                           %% Wide Margin for Matching
 CG = 200;                                  %% Cut Gradient
 contrast_road = 150;                   %% firm value for road contrast in gradient state ( gray level )
 SA = 450;                                   %% Stop Algorithm
 e_optimum = 0.3;                       %% maximum error in EKF
 error_margin = 0.4;                       %% margin of error for research
 
 %%% for check point
  e56=1;  
  rowpb = r_optimum;
  columnpb= c_optimum;
  fujitso = 1;
 %%%%%%%%%%
 %% 
 %%%%%%%% algorithm %%%%%%%%%%%
 gradient = GRADIENT(CG);
 figure (1)
imshow(uint8(gradient))

 for yy = 2 : 1 :SA  %% start algorithm

     
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
%          0 , 0  , dtt/2 , 1 ] ;                                                                                                                                                                     %% covariance of system ( second senario ) - in thesis
   
     p_manfi_k = (f_k * p_k_0 *  transpose ( f_k ))+Q_k   %% covariance of priori state
     
     
     %% second stage ( measurment )
     %%%%%%%%% generate measurment for fusion with priori estimate and use in update stage
     %%%( 3-1 algorithm in thesis )
     
     %%% step1 : use x( k-1 ) that generated in last step
     %%% step 2 :  create set of probable point and angle
     
    e_opt = e_optimum;                                 %% initial measurement error
    C_opt=80;                                   %% i assumed that my first wide of road is ....
    q=1;
    AA=1:5;
    reg = 0 ; 
    p_com_angle = 1000;

    
      for fi = ( angle -angle_change ) : 1 : ( angle + angle_change)
    
    r_prob =  r_optimum - dt * sind ( fi ) ;   
    c_prob =  c_optimum + dt * cosd ( fi );             %% measurement cordinate point
    
    r_2= round ( r_optimum - dt * sind ( fi )) ;
    c_2 = round ( c_optimum + dt * cosd ( fi ));
    fi;
    
   
    
    
    %%%% profile matching %%%%
    
      aa=ORIGINAL_MATCH(r_2 , c_2 , fi);      

    
[error_1] = ERROR_MATCH_WEIGHTED (p_1,aa,weight);
[error_2] = ERROR_MATCH_WEIGHTED (b_1,aa,weight);
[error_3] = ERROR_MATCH_WEIGHTED (b_2,aa,weight);
[error_4] = ERROR_MATCH_WEIGHTED (b_3,aa,weight);
[error_5] = ERROR_MATCH_WEIGHTED (b_4,aa,weight);
[error_6] = ERROR_MATCH_WEIGHTED (b_5,aa,weight);
[error_7] = ERROR_MATCH_WEIGHTED (b_6,aa,weight);
[error_8] = ERROR_MATCH_WEIGHTED (b_7,aa,weight);
[error_9] = ERROR_MATCH_WEIGHTED (b_8,aa,weight);
[error_10] = ERROR_MATCH_WEIGHTED (b_9,aa,weight);
[error_11] = ERROR_MATCH_WEIGHTED (p_2,aa,weight);
[error_12] = ERROR_MATCH_WEIGHTED (p_3,aa,weight);
[error_13] = ERROR_MATCH_WEIGHTED (p_4,aa,weight);
[error_2] = ERROR_MATCH_WEIGHTED (b_1,aa,weight);
[error_3] = ERROR_MATCH_WEIGHTED (b_2,aa,weight);
[error_4] = ERROR_MATCH_WEIGHTED (b_3,aa,weight);
[error_5] = ERROR_MATCH_WEIGHTED (b_4,aa,weight);
[error_6] = ERROR_MATCH_WEIGHTED (b_5,aa,weight);
[error_7] = ERROR_MATCH_WEIGHTED (b_6,aa,weight);
[error_8] = ERROR_MATCH_WEIGHTED (b_7,aa,weight);
[error_9] = ERROR_MATCH_WEIGHTED (b_8,aa,weight);
[error_10] = ERROR_MATCH_WEIGHTED (b_9,aa,weight);
[error_11] = ERROR_MATCH_WEIGHTED (p_2,aa,weight);
[error_12] = ERROR_MATCH_WEIGHTED (p_3,aa,weight);
[error_13] = ERROR_MATCH_WEIGHTED (p_4,aa,weight);


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

   if (var(aa) == 0 )  %% for bad variance of aa
       e = 0.002;
   end

     %%%% search for best regular  
                 if  ( abs(e) < abs(e_opt) && ( gradient(r_2,c_2) ~= 255 )  )
      %%% equal " C " :  for locate point on center of road
      
        
       i=2;
       R_1(1,1) = gradient(r_2 , c_2 );
       R_1(1,2) = gradient(r_2+1 ,  c_2 );
       c_4 = c_2; 
       r_4 = r_2+1;
       T=2;
        
while    R_1 ( 1 , i )  < contrast_road          
        i = i + 1;
       r_4 = r_4 + 1;
       
       if ( r_4 > M ) || ( r_4 == 0 )   %% [M,N] = size(x)
           break;
       end 
       
       R_1(1,i) = gradient(r_4,c_4);
       T = i ;
       
       if (T>WMM)
           T=1000;
           break
       end

       
      
    end
   
       i=2;
       R_2(1,1) = gradient(r_2 , c_2 );
       R_2(1,2) = gradient(r_2 - 1 ,  c_2);
       c_4 = c_2; 
       r_4 = r_2-1;
       G=2;
      
while   R_2 ( 1 , i ) < contrast_road          
        i = i + 1;
       r_4 = r_4 - 1;
       
       if ( ( r_4 > M ) || ( r_4 == 0 ) )   
           break;
       end
      
       R_2(1,i) = gradient(r_4,c_4);
       G = i ;
       
       if (G>WMM)
           G=100;
           break
       end
      
end
    
      C1=abs(T-G);
      
          %%%%%%%%%%%%%%%%%%% column
             

       i=2;
       R_1(1,1) = gradient(r_2 , c_2 );
       R_1(1,2) = gradient(r_2 , ( c_2 +1));
       c_4 = c_2+1; 
       r_4 = r_2;
       T=2;
        
while   R_1 ( 1 , i )  < contrast_road          
        i = i + 1;
       c_4 = c_4 + 1;
       
       if ( c_4 > N ) || ( c_4 == 0 )
           break;
       end
      
       R_1(1,i) = gradient(r_4,c_4);
       T = i;

       if (T>WMM)
           T=1000;
           break
       end
      
    end
   
       i=2;
       R_2(1,1) = gradient(r_2 , c_2 );
       R_2(1,2) = gradient(r_2 , ( c_2 -1));
       c_4 = c_2 - 1; 
       r_4 = r_2;
       G=2;
      
while    R_2 ( 1 , i )  < contrast_road          
        i = i + 1;
       c_4 = c_4 - 1;
       
       if ( c_4 > N ) || ( c_4 == 0 )
           break;
       end
      
       R_2(1,i) = gradient(r_4,c_4);
       G = i ;
       if (G>WMM)
           G=100;
           break
       end
   
    end

  
       
    
      C2=abs (T-G);
      C = min(C1,C2)
   
   %%%%%%%%%%%%%%%%%%%%
   r_2
   rowpb
   c_2
   columnpb
    
  
     
    p_com_angle 
   if ( r_2 == rowpb ) && ( c_2 == columnpb )
       if ( abs(fi - angle ) < p_com_angle )
           p_com_angle = abs(fi - angle )
            
                %%%%%%%%%%%%% for check point
                
                r_2
                c_2
                fi
                e
                C
                
                %%%%%%%%%%%%%%%%%
            Error(q)=e;
            Diff(q)=C
            Row(q)=r_prob;
            Column(q)=c_prob;
            Angle(q)=fi;
            AA(q,:)=aa;
            q=q+1
            
            
            
            
       end
   else
            %%% 
            

            p_com_angle = 1000;
            fujitso = fujitso +1
            rowpb=r_2;
            columnpb=c_2;
                %%%%%%%%%%%%% for check point
                 new_coardinate = 100000000000000
                r_2
                c_2
                fi
                e
                C
               
                %%%%%%%%%%%%%%%%%
            
            Error(q)=e;
            Diff(q)=C;
            Row(q)=r_prob;
            Column(q)=c_prob;
            Angle(q)=fi;
            AA(q,:)=aa;
            q=q+1
     
   end
                 end
   
   
   
            
       
      end         %% the end of search for angle ( or fi ) 
      
        %%% choose optimal measurment
        q=q-1;
        change_angle   = 30;
              while ( q )
                   if ( Diff(q) < C_opt )
                       C_opt = Diff (q);
                       Error(q);
                       reg = q;
                   elseif ( Diff(q) == C_opt )
                       if ( abs(angle - Angle(q)) < change_angle )
                           change_angle = abs( angle - Angle(q));
                           C_opt = Diff (q);
                           Error(q);
                           reg = q;
                       end
                   end
                   q=q-1;
              end
              
              %%%%
              %%%%
             %%%% if error of road more than normal_error i assume between normal error and max error  
              if (reg == 0)
                    e_opt = e_optimum + error_margin;                                 %% initial measurement error
                    C_opt=80;                                %% i assumed that my first wide of road is ....
                    q=1;
                    AA=1:5;
                    reg = 0 ; 

                    
                    p_com_angle = 1000;
                  for fi = ( angle -angle_change ) : 1 : ( angle + angle_change)
    
    r_prob =  r_optimum - dt * sind ( fi ) ;   
    c_prob =  c_optimum + dt * cosd ( fi );             %% measurement cordinate point
    
    r_2= round ( r_optimum - dt * sind ( fi )); 
    c_2 = round ( c_optimum + dt * cosd ( fi ));
    fi;
    
    
    
    
    %%%% profile matching %%%%
   aa=ORIGINAL_MATCH(r_2 , c_2 , fi );      
   
[error_1] = ERROR_MATCH_WEIGHTED (p_1,aa,weight);
[error_2] = ERROR_MATCH_WEIGHTED (b_1,aa,weight);
[error_3] = ERROR_MATCH_WEIGHTED (b_2,aa,weight);
[error_4] = ERROR_MATCH_WEIGHTED (b_3,aa,weight);
[error_5] = ERROR_MATCH_WEIGHTED (b_4,aa,weight);
[error_6] = ERROR_MATCH_WEIGHTED (b_5,aa,weight);
[error_7] = ERROR_MATCH_WEIGHTED (b_6,aa,weight);
[error_8] = ERROR_MATCH_WEIGHTED (b_7,aa,weight);
[error_9] = ERROR_MATCH_WEIGHTED (b_8,aa,weight);
[error_10] = ERROR_MATCH_WEIGHTED (b_9,aa,weight);
[error_11] = ERROR_MATCH_WEIGHTED (p_2,aa,weight);
[error_12] = ERROR_MATCH_WEIGHTED (p_3,aa,weight);
[error_13] = ERROR_MATCH_WEIGHTED (p_4,aa,weight);


   error_out = [error_1,error_2,error_3,error_4,error_5,error_6,error_7,error_8,error_9,error_10,error_11,error_12,error_13 ];
   e=min(error_out)
   e=min(error_out);
   
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

   if (var(aa) == 0 )  %% for bad variance of aa
       e = 0.002;
   end

     %%%% search for best regular  
                 if  ( abs(e) < abs(e_opt) )
      %%% equal " C " :  for locate point on center of road
       
       i=2;
       R_1(1,1) = gradient(r_2 , c_2 );
       R_1(1,2) = gradient(r_2+1 ,  c_2 );
       c_4 = c_2; 
       r_4 = r_2+1;
       T=2;
        
while    R_1 ( 1 , i ) < contrast_road          
        i = i + 1;
       r_4 = r_4 + 1;
       
       if ( r_4 > M ) || ( r_4 == 0 )    %% [M,N] = size(x)
           break;
       end 
       
       R_1(1,i) = gradient(r_4,c_4);
       T = i ;
       
       if (T>WMM)
           T=1000;
           break
       end
       

       
      
    end
   
       i=2;
       R_2(1,1) = gradient(r_2 , c_2 );
       R_2(1,2) = gradient(r_2 - 1 ,  c_2);
       c_4 = c_2; 
       r_4 = r_2-1;
       G=2;
      
while    R_2 ( 1 , i )  < contrast_road          
        i = i + 1;
       r_4 = r_4 - 1;
       
       if ( ( r_4 > M ) || ( r_4 == 0 ) )   
           break;
       end
      
       R_2(1,i) = gradient(r_4,c_4);
       G = i ;
       
       if (G>WMM)
           G=100;
           break
       end
       
      
end
    C1 = abs( T-G );
         %%%%%%%%%%%%%%%%%%% column
             

       i=2;
       R_1(1,1) = gradient(r_2 , c_2 );
       R_1(1,2) = gradient(r_2 , ( c_2 +1));
       c_4 = c_2+1; 
       r_4 = r_2;
       T=2;
        
while    R_1 ( 1 , i )  < contrast_road          
        i = i + 1;
       c_4 = c_4 + 1;
       
       if ( c_4 > N ) || ( c_4 == 0 )
           break;
       end
      
       R_1(1,i) = gradient(r_4,c_4);
       T = i;
       
       if (T>WMM)
           T=1000;
           break
       end

       
      
    end
   
       i=2;
       R_2(1,1) = gradient(r_2 , c_2 );
       R_2(1,2) = gradient(r_2 , ( c_2 -1));
       c_4 = c_2 - 1; 
       r_4 = r_2;
       G=2;
      
while    R_2 ( 1 , i )  < contrast_road          
        i = i + 1;
       c_4 = c_4 - 1;
       
       if ( c_4 > N ) || ( c_4 == 0 ) ;
           break;
       end
      
       R_2(1,i) = gradient(r_4,c_4);
       G = i ;
       
       if (G>WMM)
           G=100;
           break
       end
   
    end

  
               
    C2 = abs(T-G);
      C = min(C1,C2)

   %%%%%%%%%%%%%%%%%%%%
    p_com_angle 
   if ( r_2 == rowpb ) && ( c_2 == columnpb )
       if ( abs(fi - angle ) < p_com_angle )
           p_com_angle = abs(fi - angle )
            
                %%%%%%%%%%%%% for check point
                
                r_2
                c_2
                fi
                e
                C
                
                %%%%%%%%%%%%%%%%%
            Error(q)=e;
            Diff(q)=C;
            Row(q)=r_prob;
            Column(q)=c_prob;
            Angle(q)=fi;
            AA(q,:)=aa;
            q=q+1
            
            
            
            
       end
   else
            %%% 
            
            p_com_angle = 1000;
            fujitso = fujitso +1;
            rowpb=r_2;
            columnpb=c_2;
                %%%%%%%%%%%%% for check point
                 new_coardinate = 100000000000000
                r_2
                c_2
                fi
                e
                C
               
                %%%%%%%%%%%%%%%%%
            
            Error(q)=e;
            Diff(q)=C;
            Row(q)=r_prob;
            Column(q)=c_prob;
            Angle(q)=fi;
            AA(q,:)=aa;
            q=q+1
     
   end
                 end
   
   
   
            
       
      end         %% the end of search for angle ( or fi ) 
      
        %%% choose optimal measurment
        q=q-1;
        change_angle   = 30;

              while ( q )
                   if ( Diff(q) < C_opt )
                       C_opt = Diff (q);
                       Error(q);
                       reg = q
                   elseif ( Diff(q) == C_opt )
                       if ( abs(angle - Angle(q)) < change_angle )
                           change_angle = abs ( angle - Angle(q));
                           C_opt = Diff (q);
                           Error(q);
                           reg = q;
                       end
                   end
                   q=q-1;
              end
              end
                  
                
                %%% optional state when error occrure%%%%
                regular1(yy) = reg;
                if reg == 0
                    figure(2)
                    imshow(uint8(y))
                    reg
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
                
                
   
      %%%%%%%%%%%%%%%%%%%%
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
      
      
      %%%%%%%%%%%%%%%%%%%%%%
 r_optimum =  x_k ( 1 );
 c_optimum = x_k ( 2 );
 angle_optimum =x_k(3);
 fo_optimum =x_k(4);                                 %% cordinate of new estimate ( x(k) )
 
 fo = ( fo_optimum * 180 )/ pi  ;
 angle = ( angle_optimum * 180) / pi  ;          %%  angle change( radian to degree )
 
 y(round(r_optimum) , round(c_optimum)) = 255;
 
ee(3,yy)=c_z;
ee(4,yy)=x_manfi_k(2);
ee(5,yy)=c_optimum;


ee(6,yy)=r_z;
ee(7,yy)=x_manfi_k(1);
ee(8,yy)=r_optimum;

 %% fourth stage  ( update reference profile ) 
   
%%%%%%%%%%%%%%% create new cluster%%%%%%%%%%%%%%%%%%%%%
%%% build new cluster accourding to new coardinate that founded and compare
%%% that with old cluster. 

 %%% measurment wide of road 
       u=2;
       i=2;
       R_3(1,1) = x(round(r_optimum) , round(c_optimum) );
       r_4 = round ( r_optimum +  sind (90-angle ));    
       c_4 = round ( c_optimum + cosd ( 90-angle ));
       R_3(1,2) = x(r_4 , c_4 );
       T=i;
      
    while  (( R_3(1,i) - R_3(1,i-1) ) < 10)
       r_4 = round ( r_optimum + u *sind (90-angle ));    
       c_4 = round ( c_optimum + u *cosd ( 90-angle ));
       
       
       
       i = i + 1;
       R_3(1,i) = x(r_4,c_4);
       u=u+1;
       T = i ;
       
    end
   
       u=2;
       i=2;
       R_4(1,1) = x(round(r_optimum) , round(c_optimum) );
       r_4 = round ( r_optimum +  sind (90-angle ));    
       c_4 = round ( c_optimum + cosd ( 90-angle ));
       R_4(1,2) = x(r_4 , c_4 );
       G=i;
      
    while  (( R_4(1,i) - R_4(1,i-1) ) < 10)
       r_4 = round ( r_optimum + u *sind (90-angle ));    
       c_4 = round ( c_optimum + u *cosd ( 90-angle ));
       
       
       
       i = i + 1;
       R_4(1,i) = x(r_4,c_4);
       u=u+1;
       G = i ;
       
    end %% the end of find wide of road
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

       j=1;
       i=2; %%initial point for cluster
               %%%%%% new cluster 1 %%%%%%%%%%%%%%%%%%%%%%%%

    if cluster == 1      
    
   bb= ORIGINAL_MATCH(round(r_optimum) , round(c_optimum) , angle );      

   bb= double(bb);

   if  ( bb < contrast_match )
       

   A=intersect(p_1,bb)
   Asize=size(A)
   Asize(2)
   
   if ( Asize(2) < CSM )
       b_1 = bb 
       cluster=cluster+1
        W1 = T + G - 2;
   end
  

   end 

                   %%%%%% new cluster 2 %%%%%%%%%%%%%%%%%%%%%%%%

    
    elseif cluster == 2

   bb= ORIGINAL_MATCH(round(r_optimum) , round(c_optimum) , angle);      
   bb= double(bb);
       
   if   ( bb < contrast_match )
   
   
   A=intersect(p_1,bb);
   Asize=size(A);
   B = intersect(b_1 , bb );
   Bsize=size(B);
   
   if ( Asize(2) < CSM ) && ( Bsize(2) <CSM )
       b_2 = bb ;
          cluster=cluster+1;
          W2 = T + G - 2

   end
   end
                  %%%%%% new cluster 3 %%%%%%%%%%%%%%%%%%%%%%%%

   
        elseif cluster == 3
            
   bb= ORIGINAL_MATCH(round(r_optimum) , round(c_optimum) , angle );      
   bb= double(bb);
            
   if  ( bb < contrast_match )
       
   A=intersect(p_1,bb);
   Asize=size(A);
   B = intersect(b_1 , bb );
   Bsize=size(B);
   C=intersect(b_2,bb);
   Csize=size(C);
   if ( Asize(2) < CSM )&&(Bsize(2)< CSM)&&(Csize(2)<CSM)
          b_3 = bb ;
          cluster=cluster+1;
          W3 = T + G - 2;

   end
   end
                  %%%%%% new cluster 4 %%%%%%%%%%%%%%%%%%%%%%%%

            elseif cluster == 4
                
   bb= ORIGINAL_MATCH(round(r_optimum) , round(c_optimum) , angle);      
   bb= double(bb);
   
   if  ( bb < contrast_match )
   
 
   A=intersect(p_1,bb);
   Asize=size(A);
   B = intersect(b_1 , bb );
   Bsize=size(B);
   C=intersect(b_2,bb);
   Csize=size(C);
   D=intersect(b_3,bb);
   Dsize=size(D);
   if ( Asize(2) < CSM )&&( Bsize(2)<CSM ) && ( Csize(2)<CSM)&& ( Dsize(2)<CSM)
       b_4 = bb ;
          cluster=cluster+1;
          W4 = T + G - 2;

   end
   end
                  %%%%%% new cluster 5 %%%%%%%%%%%%%%%%%%%%%%%%

   
                elseif cluster == 5
                    
   bb= ORIGINAL_MATCH(round(r_optimum) , round(c_optimum) , angle );      
   bb= double(bb);
   
   if  ( bb < contrast_match )

   A=intersect(p_1,bb);
   Asize=size(A);
   B = intersect(b_1 , bb );
   Bsize=size(B);
   C=intersect(b_2,bb);
   Csize=size(C);
   D=intersect(b_3,bb);
   Dsize=size(D);
   E=intersect(b_4,bb);
   Esize=size(E);
   if ( Asize(2) < CSM )&&(Bsize(2)<CSM)&&(Csize(2)<CSM)&(Dsize(2)<CSM)&&(Esize(2)<CSM)
          b_5 = bb ;
          cluster=cluster+1;
          W5 = T+G-2;

   end
   end
                     %%%%%% new cluster 6 %%%%%%%%%%%%%%%%%%%%%%%%

                    elseif cluster == 6
                        
   bb= ORIGINAL_MATCH(round(r_optimum) , round(c_optimum) , angle );      
   bb= double(bb);
                        
   if  ( bb < contrast_match )

   A=intersect(p_1,bb);
   Asize=size(A);
   B = intersect(b_1 , bb );
   Bsize=size(B);
   C=intersect(b_2,bb);
   Csize=size(C);
   D=intersect(b_3,bb);
   Dsize=size(D);
   E=intersect(b_4,bb);
   Esize=size(E);
   F=intersect(b_5,bb);
   Fsize=size(F);
   if ( Asize(2) < CSM )&&(Bsize(2)<CSM)&&(Csize(2)<CSM)&(Dsize(2)<CSM)&&(Esize(2)<CSM)&&(Fsize(2)<CSM)
          b_6 = bb ;
          cluster=cluster+1;
          W6=T+G-2;

   end
   end
               %%%%%% new cluster 7 %%%%%%%%%%%%%%%%%%%%%%%%

                        elseif cluster == 7
                            
   bb= ORIGINAL_MATCH(round(r_optimum) , round(c_optimum) , angle );      
   bb= double(bb);
   
   if  ( bb < contrast_match )

   A=intersect(p_1,bb);
   Asize=size(A);
   B = intersect(b_1 , bb );
   Bsize=size(B);
   C=intersect(b_2,bb);
   Csize=size(C);
   D=intersect(b_3,bb);
   Dsize=size(D);
   E=intersect(b_4,bb);
   Esize=size(E);
   F=intersect(b_5,bb);
   Fsize=size(F);
   R=intersect(b_6,bb);
   Rsize=size(R);
   if ( Asize(2) < CSM )&&(Bsize(2)<CSM)&&(Csize(2)<CSM)&&(Dsize(2)<CSM)&&(Esize(2)<CSM)&&(Fsize(2)<CSM)&&(Rsize(2)<CSM)
     
          b_7 = bb ;
      
          W7 = T+G-2;
          cluster=cluster+1;

          
   end
   end
         %%%%%% new cluster 8%%%%%%%%%%%%%%%%%%%%%%%%

                            elseif cluster == 8
                               
   bb= ORIGINAL_MATCH(round(r_optimum) , round(c_optimum) , angle );      
   bb= double(bb);
   
   if  ( bb < contrast_match )

   A=intersect(p_1,bb);
   Asize=size(A);
   B = intersect(b_1 , bb );
   Bsize=size(B);
   C=intersect(b_2,bb);
   Csize=size(C);
   D=intersect(b_3,bb);
   Dsize=size(D);
   E=intersect(b_4,bb);
   Esize=size(E);
   F=intersect(b_5,bb);
   Fsize=size(F);
   R=intersect(b_6,bb);
   Rsize=size(R);
   J=intersect(b_7,bb);
   Jsize=size(J);
   if ( Asize(2) < CSM )&&(Bsize(2)<CSM)&&(Csize(2)<CSM)&&(Dsize(2)<CSM)&&(Esize(2)<CSM)&&(Fsize(2)<CSM)&&(Rsize(2)<CSM)&&(Jsize(2)<CSM)
    
          b_8 = bb ;
          cluster=cluster+1;
          W8=T+G-2;

   end
   end
     
   %%%%%% new cluster 9%%%%%%%%%%%%%%%%%%%%%%%%
                                elseif cluster == 9
                                    
   bb= ORIGINAL_MATCH(round(r_optimum) , round(c_optimum) , angle);      
   bb= double(bb);
   
   if  ( bb < contrast_match )

   A=intersect(p_1,bb);
   Asize=size(A);
   B = intersect(b_1 , bb );
   Bsize=size(B);
   C=intersect(b_2,bb);
   Csize=size(C);
   D=intersect(b_3,bb);
   Dsize=size(D);
   E=intersect(b_4,bb);
   Esize=size(E);
   F=intersect(b_5,bb);
   Fsize=size(F);
   R=intersect(b_6,bb);
   Rsize=size(R);
   J=intersect(b_7,bb);
   Jsize=size(J);
   L=intersect(b_8,bb);
   Lsize = size(L);
   
   if ( Asize(2) < CSM )&&(Bsize(2)<CSM)&&(Csize(2)<CSM)&&(Dsize(2)<CSM)&&(Esize(2)<CSM)&&(Fsize(2)<CSM)&&(Rsize(2)<CSM)&&(Jsize(2)<CSM)&&(Lsize(2)<CSM)
       b_9 = bb ;
       W9=T+G-2;
       cluster = 1;
   end
 
   end    
    %%%%%%%%%  
    end   %% end of new cluster search and build that

%% display result image

if (round(x_k(1)) == 138) && ( round(x_k(2)) == 126    )
    break
end
 
 yy= yy+1;

 end

 figure(2)
imshow ( uint8(y))
pause