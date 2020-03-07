function [ Z_PARTICLE_ROW , Z_PARTICLE_COLOUMN, ANGLE ,  move , FLAG_INTERSECT] = test_MEASUREMENT_PARTICLE( ROW_PARTICLE , COLOUMN_PARTICLE  , CONTRAST_PR , WIDE_MARGIN , ANGLE_SAMPLE , TH_ANGLE , WIDE_MARGIN_EDGE , WIDE  )

Z_PARTICLE_ROW =[];
d=50;
y=0;
i=0;
for fi = ANGLE_SAMPLE - TH_ANGLE : ANGLE_SAMPLE + TH_ANGLE
    %%% C1 = T ( move back) & C2 = G (move forward)
    [C , edge_canny_wide_C , C1 , C2]  = test_DIFF_PARTICLE_3 ( ROW_PARTICLE ,COLOUMN_PARTICLE  , fi , CONTRAST_PR ,  WIDE_MARGIN);
    
    y=y+1;
    difference(y) = edge_canny_wide_C;
    diff = edge_canny_wide_C;
    
        if edge_canny_wide_C >= (WIDE / 2)
        if ( diff < d )
            d=diff;
        
                %%% with this choose for move if
                %%% -1-  C1 > C2 --> r_4 = sample( j,1 ) - move * sind(90-fi) 
                %%% -2-  C1 < C2 --> r_4 = sample( j,1 ) + move * sind(90-fi)
                %%% -3-  C1 = C2 --> r_4 = sample(j,1)      
                
                
                move = (C2 - C1)/2;
                i=i+1;
                aa(i,1)=edge_canny_wide_C;
                aa(i,2)=move;
                aa(i,3)=fi
                r_4 = ROW_PARTICLE + move*sind(90-fi);
                c_4 = COLOUMN_PARTICLE + move*cosd(90-fi);
%                 ANGLE = fi*pi/180;
                ANGLE =fi
                Z_PARTICLE_ROW =r_4;
                Z_PARTICLE_COLOUMN=c_4;
                
        end
end
end
difference

 FLAG_INTERSECT = 1;
if( numel(Z_PARTICLE_ROW) == 0 )

   note = ' error for dont found suit measurment for this particle... do you want continue ? ( ENTER or control + c ) becuse there have intersection ' 
%    pause


Z_PARTICLE_ROW =[];
d=50;
y=0;
for fi = ANGLE_SAMPLE - TH_ANGLE : ANGLE_SAMPLE + TH_ANGLE
        %%% C1 = T ( move back) & C2 = G (move forward)
    [C , edge_canny_wide_C , C1 , C2]  = DIFF_PARTICLE_3 ( ROW_PARTICLE ,COLOUMN_PARTICLE  , fi , CONTRAST_PR ,  WIDE_MARGIN_EDGE);
    
    y=y+1;
    difference(y) = edge_canny_wide_C;
    diff = edge_canny_wide_C;
    
        if edge_canny_wide_C >= (WIDE / 2)
        if ( diff < d )
            d=diff;
        
                %%% with this choose for move if
                %%% -1-  C1 > C2 --> r_4 = sample( j,1 ) - move * sind(90-fi) 
                %%% -2-  C1 < C2 --> r_4 = sample( j,1 ) + move * sind(90-fi)
                %%% -3-  C1 = C2 --> r_4 = sample(j,1)                   
                move = (C2 - C1)/2;
                r_4 = ROW_PARTICLE + move*sind(90-fi);
                c_4 = COLOUMN_PARTICLE + move*cosd(90-fi);
                ANGLE = fi*pi/180;
                
                Z_PARTICLE_ROW =r_4;
                Z_PARTICLE_COLOUMN=c_4;
                
        end
end
end
end


if( numel(Z_PARTICLE_ROW) == 0 )

   note = ' error for dont found suit measurment for this particle... do you want continue ? ( ENTER or control + c ) ' 
%    pause
   
    Z_PARTICLE_ROW =ROW_PARTICLE;
    Z_PARTICLE_COLOUMN =COLOUMN_PARTICLE;
    ANGLE = ANGLE_SAMPLE*pi/180;
    move=100;
end


% %% test point
% z1=Z_PARTICLE_ROW;
% z2= Z_PARTICLE_COLOUMN;
% m=move;
% row = ROW_PARTICLE;
%  coloumn = COLOUMN_PARTICLE;
               

















