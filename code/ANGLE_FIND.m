%%% ---------------------------%%%
%%% R : first point   ---------- R(1) ----> y -------------- R(2)--------> x
%%% W : twice point
%%%ANGLE = ANGLE_FIND ( W , R )
%%% check shode doroste yekhurde ba halate addi fargh dare k  be khatere halate motefavete mokhtasat tu tasvire 


function ANGLE = ANGLE_FIND ( W , R )

          d=abs((W(1) - R(1))/(W(2)- R(2)));
          flag_0 = 0;
          
          
          if W(2)- R(2) == 0
               
          if  ( W(1) <=  R(1) )
              ANGLE = 90;
          elseif  ( W(1) > R(1) )
              ANGLE =-90;
          end
          flag_0 = 1;
          end
          
          if W(1)- R(1) == 0
               
          if  ( W(2) <=  R(2) )
              ANGLE = 180;
          elseif  ( W(2) > R(2) )
              ANGLE = 0;
          end
          flag_0 = 1;
          end
          
          if flag_0 == 0
              if (W(2) >=  R(2) ) && ( W(1) <=  R(1) )
                  ANGLE = atand(d);
              elseif (W(2) <  R(2) ) && ( W(1) < R(1) )
                  ANGLE = 180 - atand(d);
              elseif (W(2) <  R(2) ) && ( W(1) > R(1) )
                  ANGLE = atand(d)-180;
              elseif (W(2) >  R(2) ) && ( W(1) > R(1) )
                  ANGLE =  - atand(d);
              end
          end
          
          
          