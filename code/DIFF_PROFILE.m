%%----------------- equal diffrential between right and left of center point-----------------------------%%%%%%%%%%%%%%%%%%%%%%%
%%% input :
%%% ROW : condidate point row in non round situation
%%% COLOUMN : condidate point coloumn in non round situation
%%% ANGLE : condidate point angle
%%% CONTRAST_ROAD : maximum value for diffrential between 2 point in process
%%% MAX_WIDE_ROAD : maximum value that we can move in left or right
%%%
%%% output :
%%% DIFF : diffrential between right and left of center point
%%% EDGE_CANNY_WIDE : lengh moving right and left
%%--------------------------------------------------------------------------------------------------------------------%%%%%%%%%%%%%%%%%%%%%%%





function [DIFF , EDGE_CANNY_WIDE]  = DIFF_PROFILE ( ROW , COLOUMN , ANGLE , CONTRAST_ROAD ,  MAX_WIDE_ROAD)

global edge_canny
global M
global N

%% move left of center
u=0; 
       i=1;
       R_1 = 0;
       R_1(1,i) = 0;
      
              
while    R_1 ( 1 , i )  < CONTRAST_ROAD          
        i = i + 1;
        u=u+1;
        r_4 =  ROW - u *sind (90-ANGLE ) ;   %  check shode dorosre
        c_4 = COLOUMN - u *cosd ( 90-ANGLE );
       
       if ( round(r_4) > M ) || ( round(r_4) == 0 ) || ( round(c_4) > N ) || ( round(c_4) == 0 )   %% [M,N] = size(x)
           break;
       end 
       
       R_1(1,i) = edge_canny(round(r_4),round(c_4));
       T = i ;
       
       if (T>MAX_WIDE_ROAD)
           T=1000;
           break
       end

       
      
end

if T ~= 1000
T = sqrt ( ( r_4 - ROW )^2 + ( c_4 - COLOUMN)^2 );    %%% measurement T
end    

%% move right of center

       u=0; 
       i=1;
       R_2 = 0;
       R_2(1,i) = 0;
      
while   R_2 ( 1 , i ) < CONTRAST_ROAD   
        u= u+1;
        i = i + 1;
        r_4 =  ROW + u *sind (90-ANGLE );    %  check shode dorosre
        c_4 = COLOUMN + u *cosd ( 90-ANGLE );
       
       if ( round(r_4) > M ) || ( round(r_4) == 0 ) || ( round(c_4) > N ) || ( round(c_4) == 0 )   %% [M,N] = size(x)
           break;
       end 
       
       R_2(1,i) = edge_canny(round(r_4),round(c_4));
       G = i ;
       
       if (G>MAX_WIDE_ROAD)
           G=100;
           break
       end
      
end
    
if G ~= 100
G = sqrt ( ( r_4 - ROW )^2 + ( c_4 - COLOUMN)^2 );    %%% measurement T
end
      EDGE_CANNY_WIDE = T+G ;
      DIFF=abs(T-G);
