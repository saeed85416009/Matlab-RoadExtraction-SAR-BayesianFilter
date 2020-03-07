function[ grad , value_gradient] =  ORIGINAL_GRADIENT(angle_grad , cut_grad , size_x , size_y , ROW , COLOUMN , mask1 , mask2 , mask3 , mask4)

while( angle_grad > 360)
    angle_grad = angle_grad - 360;
end
while( angle_grad < -360 )
    angle_grad = angle_grad + 360 ;
end

if ( ( angle_grad > - 22.5 ) && ( angle_grad < 22.5 ) ) || ( ( angle_grad > 157 ) && ( angle_grad < 202.5 ) )  ||  ( angle_grad > 337.5 ) || ( ( angle_grad > -202.5 ) && ( angle_grad < -157 )) || ( ( angle_grad > -360 ) && ( angle_grad < -337.5 ) ) 
    grad = M_GRADIENT (cut_grad,size_x , size_y ,mask1);
    
elseif ( ( angle_grad > 22.5) && ( angle_grad <  67.5 ) ) ||  ( ( angle_grad > 202.5 ) && ( fi < 247.5 ) ) ||   ( (angle_grad > -157 ) && ( angle_grad < -112.5) ) || ( ( angle_grad >  -337.5) && ( angle_grad < -292.5) )
    grad = M_GRADIENT(cut_grad,size_x,size_y,mask2);
    
elseif  ( ( angle_grad > 67.5 ) && ( angle_grad < 112.5) ) || ( ( angle_grad  > 247.5) && ( angle_grad <  292.5 ) )  || ( ( angle_grad > -112.5 )  && ( angle_grad < -67.5 ) ) || ( ( angle_grad > -292.5)  && ( angle_grad < -247.5 ))
    grad = M_GRADIENT(cut_grad,size_x,size_y,mask3);
    
elseif ( ( angle_grad > 112.5 )  && ( angle_grad < 157.5) ) || ( ( angle_grad >292.5)  &&( angle_grad < 337.5) ) || ( ( angle_grad > -67.5) && ( angle_grad < -22.5 ) )  || ( ( angle_grad > -247.5) && ( angle_grad < -202.5) )
    grad = M_GRADIENT(cut_grad,size_x,size_y,mask4);
    
else
    pause
    angle_grad
    e_gradient = 'error'
end

%% for check point
value_gradient = grad(ROW , COLOUMN );