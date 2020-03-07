
%%
%%%%%%  create image and smooth that %%%%%%%%%%%%
clc;clear all;

a=imread  ( 'E:\mat\London.jpg');
b=rgb2gray(a);
v=double(b);




x=median(v,3);



for i=1:600
    for j=1:650
        if x(i,j) <=5 && x(i,j)>0
            x(i,j)=0;
        elseif x(i,j) <=10  && x(i,j)>5
            x(i,j)=1;
        elseif          x(i,j) <=15  && x(i,j)>10
            x(i,j)=0;
                    elseif          x(i,j) <=20   && x(i,j)>15
            x(i,j)=1;
                                elseif          x(i,j) <=25   && x(i,j)>20
            x(i,j)=0;
                                elseif          x(i,j) <=30   && x(i,j)>25
            x(i,j)=1;
                                elseif          x(i,j) <=35   && x(i,j)>30
            x(i,j)=0;

                               elseif          x(i,j) <=40   && x(i,j)>35
            x(i,j)=1;
                                elseif          x(i,j) <=45   && x(i,j)>40
            x(i,j)=0;
                                elseif          x(i,j) <=50   && x(i,j)>45
            x(i,j)=1;
                                elseif          x(i,j) <=55   && x(i,j)>50
            x(i,j)=0;
                                elseif          x(i,j) <=60   && x(i,j)>55
            x(i,j)=1;
                                elseif          x(i,j) <=65   && x(i,j)>60
            x(i,j)=0;
                               elseif          x(i,j) <=70   && x(i,j)>65
            x(i,j)=1;
                               elseif          x(i,j) <=75   && x(i,j)>70
            x(i,j)=0;
                               elseif          x(i,j) <=80   && x(i,j)>75
            x(i,j)=1;
            

    end
    end
end

x(567,80) = 0;
x(567,81) = 1;
x(568,80) = 0;
x(557,149) = 0;
x(557,150) = 1;
x(558,150) = 0;
x(559,114) = 1;
x(478,173) = 1;
x(478,174) = 0;
x(479,175) = 1;
x(471,182) = 0;
x(473,80) = 0;
x(473,189) = 1;
x(470,189) = 0;
x(449,231) = 0;
x(449,232) = 0;
x(448,231) = 0;
x(448,232) = 0;
x(447,231) = 1;
x(446,238) = 0;
x(445,238) = 0;
x(447,238) = 1;
x(420,288) = 0;
x(420,289) = 0;
x(420,290) = 0;
x(420,291) = 0;
x(421,290) = 0;
x(421,291) = 0;
x(398,294) = 0;
x(398,292) = 0;
x(396,293) = 0;
x(394,292) = 0;
x(388,290) = 0;
x(388,291) = 0;
x(388,292) = 0;
x(402,296) = 256;
x(387,293) = 0;
x(387,294) = 0;
x(387,295) = 0;
x(359,291) = 1;
x(359,292) = 1;
x(359,286) = 1;
x(359,293) = 1;

x(367,286) = 1;
x(363,286) = 1;
x(360,286) = 1;
x(360,287) = 1;
x(360,288) = 1;
x(360,289) = 1;
x(360,290) = 1;
x(359,289) = 1;
x(359,290) = 1;
x(357,289) = 1;
x(356,289) = 1;
x(356,289) = 1;
x(356,290) = 1;
x(355,289) = 1;
x(355,290) = 1;
x(358,291) = 255;
x(322,293) = 1;
x(322,294) = 1;
x(322,295) = 1;
x(321,294) = 1;
x(323,294) = 1;
x(323,295) = 1;
x(321,292) = 1;
x(321,293) = 1;
x(320,293) = 1;
x(317,300) = 1;
x(317,301) = 1;
x(318,300) = 1;
x(318,301) = 1;

















y = x;  

%%
%%%%%% initialize point %%%%%%%%%%%%%

e56=1;  %% for check point

dt= sqrt (10);
dtt=dt;          %% lenght of step

 r_optimum = 487 ;                       %% initialize row for priori estimate
 c_optimum = 11;                         %% initialize column for  priori estimate
 r_opt = r_optimum ;
c_opt = c_optimum ; 

 angle =-30 ;
 angle_optimum = ( angle * pi )/180 ;    %% initialize angle of road
 
 W=5;                                         %% initialize road wide
 
 fo_optimum = 0.000001 ;
 fo = fo_optimum;                       %% initialize change in the road direction
 
 p_k_0 = 0.0001;                         %% initialize covariance matrice
 
 p_1 = [0 1 0 1 0 1 0 1 1  ]           %% initialize reference profile
 
   sigma_fis = (1/280)^2;           %% variance af system noise
 % sigma_fis = 0;                           %% variance af system noise
  
 
 %% 
 %%%%%%%% algorithm %%%%%%%%%%%
 
 
 for yy = 2 : 1 :450  
     
   
     
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
     
    e_opt = 3;                                 %% initial measurement error
    C_opt=26;
    q=1;
    AA=1:9;
    reg = 0 ; 
    
      for fi = ( angle -30 ) : 1 : ( angle + 30)
    
    r_prob =  r_optimum - dt * sind ( fi ) ;   
    c_prob =  c_optimum + dt * cosd ( fi );             %% measurement cordinate point
    
    r_2= round ( r_optimum - dt * sind ( fi ))  
    c_2 = round ( c_optimum + dt * cosd ( fi ))
    fi
    
    %%%% profile matching %%%%
    aa(1,1) = x(r_2 , c_2 );
    aa(1,2) = x(r_2+1,c_2+1);
    aa(1,3) = x(r_2-1,c_2+1);
    aa(1,4) = x(r_2+1,c_2-1);
    aa(1,5) = x(r_2-1,c_2-1);
    aa(1,6) = x(r_2,c_2+1);
    aa(1,7) = x(r_2,c_2-1);
    aa(1,8) = x(r_2+1,c_2);
    aa(1,9) = x(r_2-1,c_2);
    
[e]=ERROR_MATCH(p_1,aa);


   if (var(aa) == 0 )  %% for bad variance of aa
       e = 0.002;
   end

     %%%% search for best regular 
         if     (    (( fi >0 ) & ( fi < 45 ) ) | ( ( fi >90 ) & (fi<135) ) | ( ( fi>180 ) & ( fi<225) ) | ( ( fi>270) & ( fi < 315)) | (( fi <0 )&(fi>-45)) )

              c_4 = c_2; 
       r_4 = r_2;
       i=2;
       R_1(1,1) = x(r_2 , c_2+1 );
       R_1(1,2) = x(r_2 , ( c_2 ));
        
while   ( R_1 ( 1 , i ) - R_1(1 , i-1 ) ) < 10          
        i = i + 1;
       r_4 = r_4 + 1;
      
       R_1(1,i) = x(r_4,c_4);
       T = i 
       
      
    end
   
       c_4 = c_2; 
       r_4 = r_2;
       i=2;
       R_2(1,1) = x(r_2 , c_2-1 );
       R_2(1,2) = x(r_2 , ( c_2));
      
while   ( R_2 ( 1 , i ) - R_2(1 , i-1 ) ) < 10          
        i = i + 1;
       r_4 = r_4 - 1;
      
       R_2(1,i) = x(r_4,c_4);
       G = i 
       
      
    end
   C=abs (T-G)
         else %%%%%%%%%%%%%%%%%%%
             
       c_4 = c_2; 
       r_4 = r_2;
       i=2;
       R_1(1,1) = x(r_2 , c_2 );
       R_1(1,2) = x(r_2 , ( c_2 +1));
        
while   ( R_1 ( 1 , i ) - R_1(1 , i-1 ) ) < 10          
        i = i + 1;
       c_4 = c_4 + 1;
      
       R_1(1,i) = x(r_4,c_4);
       T = i ;
       
      
    end
   
       c_4 = c_2; 
       r_4 = r_2;
       i=2;
       R_2(1,1) = x(r_2 , c_2 );
       R_2(1,2) = x(r_2 , ( c_2 -1));
      
while   ( R_2 ( 1 , i ) - R_2(1 , i-1 ) ) < 10          
        i = i + 1;
       c_4 = c_4 - 1;
      
       R_2(1,i) = x(r_4,c_4);
       G = i ;
       
      
    end
   C=abs (T-G)
      
     
        
      
    end
   
   %%%%%%%%%%%%%%%%%%%%
        if  ( abs(e) < abs(e_opt) )
            
            Error(q)=e;
            Diff(q)=C;
            Row(q)=r_prob;
            Column(q)=c_prob;
            Angle(q)=fi;
            AA(q,:)=aa;
            q=q+1;
        end
            
       
      end         %% the end of search for angle ( or fi ) 
      
        %%% choose optimal measurment
        q=q-1;
              while ( q )
                   if ( Diff(q) < C_opt )
                       C_opt = Diff (q)
                       Error(q);
                       reg = q
                   end
                   q=q-1;
               end
                e_opt = Error(reg);
                C_opt = Diff(reg);

                fi_z = Angle(reg)  
                r_z = Row(reg);
                c_z = Column(reg);                                %% measurement point cordinate
      
                angle_z = ( fi_z * pi )/180 ;             %%  angle change( degree to radian ) 

                ee(1,e56) = e;
                ee(2,e56) = fi_z;
                e56=e56+1;

                aa = AA(reg,:);
                
   
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


figure(1)
imshow ( uint8(y))

 
 yy= yy+1;

 end
























