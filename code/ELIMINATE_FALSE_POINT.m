function ELIMINATE_FALSE_POINT(TH_CAN_ANGLE)


global sample_t
sample_t(:,16)=sample_t(:,12)*180/pi;
size_sample_t = size(sample_t);
k=0;
eliminate=[];
for i = 1:size_sample_t(1)
    
             %%% angle find%%%%%%%%%%
             d(1) = sample_t(i , 2)
             d(2) = sample_t(i , 3)
             e(1) = sample_t(i , 10)
             e(2) = sample_t(i , 11)
             angle_from_center = ANGLE_FIND( d , e )
             %%%%%%%%%%%%%%%%%%%%
             ANGLE=sample_t(i,16)
             abs_angle = abs(ANGLE - angle_from_center );
             if abs_angle > 180
                 abs_angle = 360 - abs_angle;
             end
    
             if ( abs_angle <= TH_CAN_ANGLE )
                 
                 note='good'
                 
             else
                 
                 if (reverse_angle_from_center == 0) || (reverse_angle_from_center == -90) || (reverse_angle_from_center == -180) || (reverse_angle_from_center == -270)||(reverse_angle_from_center == -360)||(angle_from_center == 0)||(angle_from_center == 90)||(angle_from_center == 180)||(angle_from_center == 270)||(angle_from_center == 360)          
                
                     note='good'
                     
                 else
                     
                     k=k+1;
                     eliminate(k)=i
                 end
%                  pause
                 
             end
                 
              
    
end

if numel(eliminate ~= 0)
sample_t( eliminate,: )= [];   
end



