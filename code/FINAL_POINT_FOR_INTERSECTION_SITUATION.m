function FINAL_POINT_FOR_INTERSECTION_SITUATION(TH_MERGE_ANGLE)

global sample_t
size_sample_t = size(sample_t);

max_angle = max(sample_t(:,14));
min_angle = min(sample_t(:,14));

dis_angle = abs(max_angle - min_angle);
th_angle = TH_MERGE_ANGLE;

if dis_angle <= 90
    
    kalman_point = 2;
    
elseif ( dis_angle >90) && ( dis_angle <= 180)
    
    kalman_point = 3;
    
else
    
    kalman_point = 4;
    
end

A=[ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
sample_t(:,20) = sample_t(:,1);
while( numel(A) > kalman_point)
    
    MERGE_SAMPLE_NEW_4(th_angle , 20);
     sample_t(:,19)=sample_t(:,14)
    A = unique(sample_t(:,20))
 

        th_angle = th_angle + TH_MERGE_ANGLE 
           pause
        
end
    
    sample_t(:,15)=sample_t(:,20);
%     sample_t = MEDIAN_ANGLE_2(sample_t , 4 , 21 , 20 );
    sample_t(:,15)=sample_t(:,20);
    sample_t(:,16)=sample_t(:,14);
    REGULARIZED_SAMPLE_3(20)
    sample_t(:,15)=sample_t(:,20);
    sample_t(:,16)=sample_t(:,14);
    sample_t(:,17:end) = [];
pause
    
    
    
    
    
    