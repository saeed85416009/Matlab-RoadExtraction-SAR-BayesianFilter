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





function T = test_DIFF_MOVE_BREAK ( ROW , COLOUMN , ANGLE , CONTRAST_ROAD ,  MAX_WIDE_ROAD)

global edge_canny
global M
global N

%% move left of center
       u=0; 
       i=1;
       T=i;
       R_1 = 0;
       R_1(1,i) = 0;
       R_2 = 0;
       R_2(1,i) = 0;
       R_3 = 0;
       R_3(1,i) = 0;
       R_4 = 0;
       R_4(1,i) = 0;
       R_5 = 0;
       R_5(1,i) = 0;
      
while    (R_1 ( 1 , i )  < CONTRAST_ROAD) &&   (R_2 ( 1 , i )  < CONTRAST_ROAD) && (R_3 ( 1 , i )  < CONTRAST_ROAD)  && (R_4 ( 1 , i )  < CONTRAST_ROAD) && (R_5 ( 1 , i )  < CONTRAST_ROAD)       
        i = i + 1;
        u=u+1;
        r_4 =  ROW - u *sind (ANGLE )    %  check shode dorosre
        c_4 = COLOUMN + u *cosd (ANGLE )
        
       
       if ( ceil(r_4) > M ) || ( floor(r_4) == 0 ) || ( ceil(c_4) > N ) || ( floor(c_4) == 0 )   %% [M,N] = size(x)
           break;
       end 
       
       R_1(1,i) = edge_canny(round(r_4),round(c_4));
       R_2(1,i) = edge_canny(ceil(r_4),ceil(c_4));
       R_3(1,i) = edge_canny(floor(r_4),floor(c_4));
       R_4(1,i) = edge_canny(floor(r_4),ceil(c_4));
       R_5(1,i) = edge_canny(ceil(r_4),floor(c_4));
       
       T = i 
       pause
       
       
       if (T>MAX_WIDE_ROAD)
           T=1000;
           break
       end

       
      
end

if T ~= 1000
T = sqrt ( ( r_4 - ROW )^2 + ( c_4 - COLOUMN)^2 );    %%% measurement T
end    


      T = T -1;
