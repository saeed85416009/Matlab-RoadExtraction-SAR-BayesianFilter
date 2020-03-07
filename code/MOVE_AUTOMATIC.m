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





function [ ADJACENCY_FIRST_POINT , T , flag_prob_point ] = MOVE_AUTOMATIC ( ROW , COLOUMN , ANGLE , CONTRAST_ROAD ,  MAX_WIDE_ROAD , MIN_MOVE_FIRST)

global edge_point
global prob_point

[M , N ] = size(edge_point);
r_adjacency_prob =0;
%% move from center
       u=0; 
       i=1;
       T=i;
       R_1 = [];
       R_1(1,i) = 0;
       R_2 = [];
       R_2(1,i) = 0;
       R_3 = [];
       R_3(1,i) = 0;
       R_4 = 0;
       R_4(1,i) = 0;
       R_5 = [];
       R_5(1,i) = 0;
      flag_prob_point = 1;
while    (R_1 ( 1 , i )  < CONTRAST_ROAD) &&   (R_2 ( 1 , i )  < CONTRAST_ROAD) && (R_3 ( 1 , i )  < CONTRAST_ROAD)  && (R_4 ( 1 , i )  < CONTRAST_ROAD) && (R_5 ( 1 , i )  < CONTRAST_ROAD)       
        i = i + 1;
        u=u+1;
        r_4 =  ROW - u *sind (ANGLE ) ;   %  check shode dorosre
        c_4 = COLOUMN + u *cosd ( ANGLE );
        
%          for s_u = 1: size_prob_point(1)
%             if (round(r_4) == round(prob_point(s_u , 1)))  &&  (round(c_4) == round(prob_point(s_u , 2) ))
%                 
%                 flag_prob_point = 0;
%                 
%                 break;
%                 
%             end
%         end
%         
%         if flag_prob_point == 0
%             break;
%         end
       

        
       if ( ceil(r_4) > M-10 ) || ( floor(r_4) < 10 ) || ( ceil(c_4) > N-10 ) || ( floor(c_4) < 10 )   %% [M,N] = size(x)
           flag_prob_point = 0;
           T=100000;
           break;
       end 
       
       if u < MIN_MOVE_FIRST
            
           R_1(1,i) = 0;
           R_2(1,i) = 0;
           R_3(1,i) = 0;
           R_4(1,i) = 0;
           R_5(1,i) = 0;
           continue
       end
           
           R_1(1,i) = edge_point(round(r_4),round(c_4));
           R_2(1,i) = edge_point(ceil(r_4),ceil(c_4));
           R_3(1,i) = edge_point(floor(r_4),floor(c_4));
           R_4(1,i) = edge_point(floor(r_4),ceil(c_4));
           R_5(1,i) = edge_point(ceil(r_4),floor(c_4));



           if R_1 ( 1 , i )  >= CONTRAST_ROAD

               r_adjacency_prob = round(r_4);
               c_adjacency_prob = round(c_4);

           elseif R_2 ( 1 , i )  >= CONTRAST_ROAD

               r_adjacency_prob = ceil(r_4);
               c_adjacency_prob = ceil(c_4);

            elseif R_3 ( 1 , i )  >= CONTRAST_ROAD

               r_adjacency_prob = floor(r_4);
               c_adjacency_prob = floor(c_4);

             elseif R_4 ( 1 , i )  >= CONTRAST_ROAD

               r_adjacency_prob = floor(r_4);
               c_adjacency_prob = ceil(c_4);

             elseif R_5 ( 1 , i )  >= CONTRAST_ROAD

               r_adjacency_prob = ceil(r_4);
               c_adjacency_prob = floor(c_4);

           end
       
       
       T = i ;
%        pause
       
       
       if (T>MAX_WIDE_ROAD)
           flag_prob_point = 0;
           T=1000;
           break
       end

       
      
end

if T < 1000
T = sqrt ( ( r_4 - ROW )^2 + ( c_4 - COLOUMN)^2 );    %%% measurement T
end

if flag_prob_point ~= 0
%     r_4
%     c_4
%     
%     T
ADJACENCY_FIRST_POINT = [ r_adjacency_prob , c_adjacency_prob ];
% ANGLE
%     pause
else
    ADJACENCY_FIRST_POINT =[0 0 ]
%     r_4
%     c_4
%     ANGLE
%     T
%     pause
end

      T = T -1;
